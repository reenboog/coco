//
//  HelloWorldLayer.m
//  openGLExample
//
//  Created by Mac on 25.07.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "Line.h"
#import "MainMenuLayer.h"
#import "GameConfig.h"
#import "GB2ShapeCache.h"
#import "MyContactListener.h"
#import "Settings.h"
#import "Common.h"

#import "VRope.h"
#import <vector>

#import "Fish.h"
#import "Shark.h"

using namespace std;

enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

// HelloWorldLayer implementation
@implementation GameLayer

@synthesize guiLayer;

@synthesize pos;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];

	
	// add layer as a child to scene
	[scene addChild: layer];
    
    GUILayer *gui = [GUILayer node];
    [scene addChild: gui];
    
    layer.guiLayer = gui;
    gui.gameLayer = layer;
	
	// return the scene
	return scene;
}

- (void) dealloc
{
	[super dealloc];
    
    [fishesArray release];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) 
    {
        
        //////// BackGround
        
        CCSprite *bg = [CCSprite spriteWithFile: @"bg.png"];
        bg.position = ccp(GameCenterX, GameCenterY);
        //[bg setOpacity: 100];
        [self addChild: bg z: kZBackGroundPic];
        
        
        waveBack = [CCSprite spriteWithFile: @"waveBack.png"];
        waveBack.position = ccp(GameCenterX, GameCenterY + 85);
        [self addChild: waveBack];
        waveBackSpeed = 7;
        ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
        [waveBack.texture setTexParameters: &tp];
        
        waveFront = [CCSprite spriteWithFile: @"waveFront.png"];
        waveFront.position = ccp(GameCenterX, GameCenterY + 85);
        [self addChild: waveFront z: 15];
        waveFrontSpeed = -4;
        ccTexParams tpF = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
        [waveFront.texture setTexParameters: &tpF];
        
        CCSprite *highLight1 = [CCSprite spriteWithFile: @"highLight1.png"];
        highLight1.position = ccp(GameCenterX - 170, GameCenterY + 50);
        [self addChild: highLight1];
        
        CCSprite *highLight2 = [CCSprite spriteWithFile: @"highLight2.png"];
        highLight2.position = ccp(GameCenterX, GameCenterY + 50);
        [self addChild: highLight2];
        
        CCSprite *highLight3 = [CCSprite spriteWithFile: @"highLight3.png"];
        highLight3.position = ccp(GameCenterX + 170, GameCenterY + 50);
        [self addChild: highLight3];
        
        CCSprite *clouds = [CCSprite spriteWithFile: @"clouds.png"];
        clouds.position = ccp(GameCenterX, GameHeight);
        [self addChild: clouds];
        
        CCSprite *birds = [CCSprite spriteWithFile: @"birds.png"];
        birds.position = ccp(GameCenterX - 30, GameHeight - 15);
        birds.scale = 0.8;
        [self addChild: birds];
        
        [birds runAction: 
                        [CCRepeatForever actionWithAction: 
                                                    [CCSequence actions: 
                                                                    [CCMoveTo actionWithDuration: 2.0 
                                                                                         position: ccp(birds.position.x, birds.position.y - 10)], 
                                                                    [CCMoveTo actionWithDuration: 2.0 
                                                                                         position: ccp(birds.position.x, birds.position.y)],
                                                     nil]
                         ]
         ];
        
        [clouds runAction: 
                        [CCRepeatForever actionWithAction: 
                                                    [CCSequence actions: 
                                                                    [CCScaleTo actionWithDuration: 2.5 
                                                                                         scale: 0.7], 
                                                                    [CCScaleTo actionWithDuration: 2.5 
                                                                                         scale: 1],
                                                     nil]
                         ]
         ];
        
        [highLight1 runAction: 
                        [CCRepeatForever actionWithAction: 
                                                    [CCSequence actions: 
                                                                    [CCFadeTo actionWithDuration: 1.5 
                                                                                         opacity: 0], 
                                                                    [CCFadeTo actionWithDuration: 1.5 
                                                                                         opacity: 255],
                                                     nil]
                         ]
         ];
        
        [highLight2 runAction: 
                        [CCRepeatForever actionWithAction: 
                                                    [CCSequence actions: 
                                                                    [CCFadeTo actionWithDuration: 1.75 
                                                                                         opacity: 0], 
                                                                    [CCFadeTo actionWithDuration: 1.75 
                                                                                         opacity: 255],
                                                     nil]
                         ]
         ];
        
        [highLight3 runAction: 
                        [CCRepeatForever actionWithAction: 
                                                    [CCSequence actions: 
                                                                    [CCFadeTo actionWithDuration: 2.0 
                                                                                         opacity: 0], 
                                                                    [CCFadeTo actionWithDuration: 2.0 
                                                                                         opacity: 255],
                                                     nil]
                         ]
         ];
        
//        bubblesSprite = [CCSprite spriteWithFile: @"bubbles.png"];
//        bubblesSprite.position = ccp(GameCenterX, GameCenterY - 100);
//        [self addChild: bubblesSprite];
//        
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"bubbles.plist"];
//        
//        [Common loadAnimationWithPlist: @"bubblesAnimation" andName: @"bubbles"];
//        
//        [bubblesSprite runAction:[CCAnimate actionWithAnimation: [[CCAnimationCache sharedAnimationCache] animationByName: @"bubbles"] restoreOriginalFrame: YES]];
        
        /////////
		
        fishesArray = [[NSMutableArray alloc] init];
        sharksArray = [[NSMutableArray alloc] init];
        curFishesArray = [[NSMutableArray alloc] init];
        AninatedFishesArray = [[NSMutableArray alloc] init];
        AnimatedFishesForRemoveArray = [[NSMutableArray alloc] init];
        
        self.isTouchEnabled = YES;
        
        
        b2Vec2 gravity;
        gravity.Set(0, -3);
        
        //bool doSleep = true;
        
        world = new b2World(gravity);
        
        world->SetContinuousPhysics(true);
        
        m_debugDraw = new GLESDebugDraw();
        world->SetDebugDraw(m_debugDraw);
        
        uint32 flags = 0;
//        flags += GLESDebugDraw::e_shapeBit;
//		flags += GLESDebugDraw::e_jointBit;
//		flags += b2Draw::e_aabbBit;
//		flags += b2Draw::e_pairBit;
//		flags += b2Draw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);
        
        
        //        b2BodyDef groundBodyDef;
        //        groundBodyDef.position = b2Vec2(0, 0);
        //        
        //        groundBody = world->CreateBody(&groundBodyDef);
        
        
        
        DNIWEDef.type = b2_staticBody;
        DNIWEDef.position.Set(7.5, -0.2); 
        
        DNIWE = world->CreateBody(&DNIWEDef);
        
        DNIWEShape.SetAsBox(7.5, 0.5);
        DNIWEFixture.density = 1.0;
        
        DNIWEFixture.shape = &DNIWEShape;
        
        DNIWE->CreateFixture(&DNIWEFixture); 
        
        
        ceilingDef.type = b2_staticBody;
        ceilingDef.position.Set(7.5, 10.4); 
        
        ceiling = world->CreateBody(&ceilingDef);
        
        ceilingShape.SetAsBox(7.5, 0.5);
        ceilingFixture.density = 1.0;
        
        ceilingFixture.shape = &ceilingShape;
        
        ceiling->CreateFixture(&ceilingFixture);
        
        
        leftWallDef.type = b2_staticBody;
        leftWallDef.position.Set(-0.4, 7.5); 
        
        leftWall = world->CreateBody(&leftWallDef);
        
        leftWallShape.SetAsBox(0.5, 7.5);
        leftWallFixture.density = 1.0;
        
        leftWallFixture.shape = &leftWallShape;
        
        leftWall->CreateFixture(&leftWallFixture);
        
        
        rightWallDef.type = b2_staticBody;
        rightWallDef.position.Set(15.4, 7.5); 
        
        rightWall = world->CreateBody(&rightWallDef);
        
        rightWallShape.SetAsBox(0.5, 7.5);
        rightWallFixture.density = 1.0;
        
        rightWallFixture.shape = &rightWallShape;
        
        rightWall->CreateFixture(&rightWallFixture);
        
        
        
        
        coco = [Coco createWithWorld: world];
        
        [self addChild: coco z:10];
        
        
        [self schedule: @selector(tick:)];
        
        [self startGame];
        [self scheduleUpdate];


	}
	return self;
}

- (void) spawnShark
{
    Shark *shark = [Shark createShark];
    [self addChild: shark z: 60];
    
    [sharksArray addObject: shark];
    
    shark.gameLayer = self;
    
    [shark swim];
}

- (void) spawnFish
{
    if(fishCount < 3)
    {
        Fish *fish = [Fish createFish];
        
        [self addChild: fish z: 50];
        
        [fishesArray addObject: fish];
        
        fishCount++;
        
        fish.gameLayer = self;
        
        [fish swim];
    }
}

- (void) update: (ccTime) dt
{
    if(IsGameActive == YES)
    {
        waveBackOffSetX += dt * waveBackSpeed;
        waveBackOffSetX = waveBackOffSetX > 512 ? waveBackOffSetX - 512 : waveBackOffSetX;
        CGRect rect = CGRectMake(waveBackOffSetX * 4, 0, waveBack.contentSize.width, waveBack.contentSize.height);
        [waveBack setTextureRect: rect];
        
        waveFrontOffSetX += dt * waveFrontSpeed;
        waveFrontOffSetX = waveFrontOffSetX > 512 ? waveFrontOffSetX - 512 : waveFrontOffSetX;
        CGRect rectF = CGRectMake(waveFrontOffSetX * 4, 0, waveFront.contentSize.width, waveFront.contentSize.height);
        [waveFront setTextureRect: rectF];
    }
}

- (void) updateIntervalForFishSpawn
{
    if(IsCanSpawnFish == YES)
    {
        NSInteger intInterval = arc4random() % 20 + 15;
        float flInterval = intInterval * 0.1;
        
        [self runAction: 
                    [CCSequence actions: 
                                    [CCDelayTime actionWithDuration: flInterval],
                                    [CCCallFunc actionWithTarget: self 
                                                        selector: @selector(spawnFish)], 
                                    [CCCallFunc actionWithTarget: self 
                                                        selector: @selector(updateIntervalForFishSpawn)],
                     nil]
         ];
    }
    else 
    {
        [self runAction: 
                    [CCSequence actions: 
                                [CCDelayTime actionWithDuration: 0.0], 
                                [CCCallFunc actionWithTarget: self 
                                                    selector: @selector(updateIntervalForFishSpawn)],
                     nil]
         ];
    }
    
    
    //[self schedule: @selector(spawnFish) interval: 3.0];
}

- (void) startGame
{
    score = 0;
    time = 90;
    IsGameActive = YES;
    IsHookActive = YES;
    IsFishCauth = NO;
    
    [self schedule: @selector(timeIterator) interval: 1.0];
    
    CCLOG(@"STARTFISHCOUNT: %i", fishCount);

    if(IsRestartGame == NO)
    {
        [self updateIntervalForFishSpawn];
    }
    else 
    {
        IsRestartGame = NO;
        [self runAction: 
                    [CCSequence actions: 
                                    [CCCallFunc actionWithTarget: self 
                                                        selector: @selector(spawnFish)], 
                                    [CCDelayTime actionWithDuration: 1.0], 
                                    [CCCallFunc actionWithTarget: self 
                                                        selector: @selector(spawnFish)], 
                                    [CCDelayTime actionWithDuration: 1.0], 
                                    [CCCallFunc actionWithTarget: self 
                                                        selector: @selector(spawnFish)], 
                                    [CCDelayTime actionWithDuration: 1.0], 
                     nil]
         ];
    }
    
    if (_revolJoint) 
    {
        world->DestroyJoint(_revolJoint);
        _revolJoint = NULL;
    } 
    
    if(fishBody)
    {
        world->DestroyBody(fishBody);
        fishBody = NULL;
    }

    for(Fish *currentFish in fishesArray)
    {
        [self removeFish: currentFish];
    }
    
    for(Shark *currentShark in sharksArray)
    {
        [self removeShark: currentShark];
    }
    
    [self removeChild: curFish cleanup: YES];
    [fishesArray removeAllObjects];
    
    
    fishCount = 0;
}

- (void) doPauseGame
{
    for(Fish * currentFish in fishesArray)
    {
        [currentFish pauseSchedulerAndActions];
    }
    
    for(Shark *currentShark in sharksArray)
    {
        [currentShark pauseSchedulerAndActions];
    }
    
    //[self stopAllActions];
    IsCanSpawnFish = NO;
    [self unschedule: @selector(timeIterator)];
}

- (void) unPauseGame
{
    for(Fish * currentFish in fishesArray)
    {
        [currentFish resumeSchedulerAndActions];
    }
    
    for(Shark *currentShark in sharksArray)
    {
        [currentShark resumeSchedulerAndActions];
    }
    
    [self schedule: @selector(timeIterator) interval: 1.0];
}

- (void) timeIterator
{
    time--;
    
    if(CurrentDifficulty == 2 || CurrentDifficulty == 1)
    {
        if(time != 90 && time != 0 && time % 15 == 0)
        {
            [self spawnShark];
        }
    }
    
    //if(CurrentDifficulty == 1 || CurrentDifficulty == 2)
    //{
        if(time <= 0)
        {
            time = 0;
            
            NSInteger bestResultEver = [Settings sharedSettings].maxScore;
            if(score > bestResultEver)
            {
                //check for a new record and save if any
                [Settings sharedSettings].maxScore = score;
                [[Settings sharedSettings] save];
            }
            NSInteger b_Score = [Settings sharedSettings].maxScore;
            
            [guiLayer showGameOverMenu: b_Score];
        }
        
        [guiLayer formatCurrentTime: time];
    //}
}


-(void) draw
{
    
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    glLineWidth(3.0f);
    //glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    
}

- (void) removeFish: (Fish *) currentFish
{
    [self removeChild: currentFish cleanup: YES];
    fishCount--;
}

- (void) removeShark: (Shark *) currentShark
{
    [sharksArray removeAllObjects]; 
    [self removeChild: currentShark cleanup: YES];
}

-(void) tick: (ccTime) dt
{
    
    if(IsGameActive == NO)
    {
        return;
    }
    
    //CCLOG(@"Fish count: %i", fishCount);
    
    if(fishCount >= 3)
    {
        //fishCount = 3;
        IsCanSpawnFish = NO;
    }
    else 
    {
        IsCanSpawnFish = YES;
    }
    
    NSMutableArray *fishToRemove = [[NSMutableArray alloc] init];

    
    for (Shark *currentShark in sharksArray)
    {
        for (Fish *currentFish in fishesArray)
        {
            if ( ((abs(currentShark.position.x - currentFish.position.x)) < 70) && ((abs(currentShark.position.y - currentFish.position.y)) < 30) )
            {
                CCLOG(@"NYAM NYAM!");
                
                [currentShark eatingFish];
                
                [currentFish runAction: [CCScaleTo actionWithDuration: 0.5 scale: 0]];
                
                [fishToRemove addObject: currentFish];
                
                [self removeChild: currentFish cleanup: YES];
                
                fishCount--;
            }
        }
    }
    
    if(IsHookActive == YES && IsFishCauth == NO)
    {
    for(Fish *currentFish in fishesArray)
    {
        //CCLOG(@"CurrentFishPosition: %f, %f and hookPosition: %f, %f", currentFish.position.x, currentFish.position.y, coco.hookSprite.position.x, coco.hookSprite.position.y);
        
            b2Vec2 hookPos = coco.hook->GetPosition();
        
        //CCLOG(@"position %f", hookPos.x);
        
            if( (abs(currentFish.position.x - (hookPos.x * 32)) < 20) && (abs(currentFish.position.y - (hookPos.y * 32)) < 20))
            {
                CCLOG(@"Contact!");
                
                IsFishCauth = YES;
                IsHookActive = NO;
                
                if(currentFish.type == 0)
                {
                    curFish = [CCSprite spriteWithFile: [NSString stringWithFormat: @"%i%ifish.png", currentFish.type, currentFish.randFish]];
                }
                else
                {
                    curFish = [CCSprite spriteWithFile: [NSString stringWithFormat: @"%ifish.png", currentFish.type]];
                }
                
                //[curFishesArray addObject: curFish];
                
                //curFish.scaleX = -1;
                [self addChild: curFish z: 30];
                
                float widthOfBody = 1.0;
                float HeightOfBody = 0.5;
                float anchorOfFish = 0.5;
                float anchorY = 0.0;
                
                if(currentFish.type == 0)
                {
                    widthOfBody = 0.7;
                    HeightOfBody = 0.5;
                    anchorOfFish = -0.6;
                }
                else if(currentFish.type == 2)
                {
                    widthOfBody = 0.4;
                    HeightOfBody = 0.6;
                    anchorOfFish = 0.0;
                    anchorY = 0.5;
                }
                else if(currentFish.type == 3)
                {
                    widthOfBody = 0.6;
                    HeightOfBody = 0.4;
                    anchorOfFish = 0.1;
                }
                else if(currentFish.type == 1 || currentFish.type == 4)
                {
                    widthOfBody = HeightOfBody = 0.6;
                    anchorOfFish = 0.0;
                }
                
                fishDef.type = b2_dynamicBody;
                fishDef.position.Set(currentFish.position.x / PTM_RATIO, currentFish.position.y / PTM_RATIO); 
                
                fishDef.userData = curFish;
                
                fishBody = world->CreateBody(&fishDef);
                
                fishShape.SetAsBox(widthOfBody, HeightOfBody);
                fishFixture.density = 3.0;
                
                fishFixture.shape = &fishShape;
                
                fishBody->CreateFixture(&fishFixture);
                
                
                b2RevoluteJointDef revolJointDef;
                revolJointDef.Initialize(coco.hook, fishBody, coco.hook->GetWorldCenter());
                
                revolJointDef.localAnchorA = b2Vec2(0.0, 0.0);
                revolJointDef.localAnchorB = b2Vec2(anchorOfFish, anchorY);
                revolJointDef.lowerAngle = -0.8;
                revolJointDef.upperAngle = 0.8;
                revolJointDef.enableLimit = false;
                //revolJointDef.maxMotorTorque = 10.0f;
                revolJointDef.motorSpeed = 0.0f;
                revolJointDef.enableMotor = true;
                
                _revolJoint = (b2RevoluteJoint *)world->CreateJoint(&revolJointDef);
                
                
                
                [self removeChild: currentFish cleanup: YES];
                [fishToRemove addObject: currentFish];
                
            }
        
                }   
        
    }
    
    if(curFish && IsFishCauth == YES)
    {
        //for(CCSprite *curFishSprite in curFishesArray)
        //{
        if(CurrentDifficulty == 2)
        {
            if(curFish.position.y > 250)
            {
                IsFishCauth = NO;
                IsHookActive = YES;
                
                if (_revolJoint) 
                {
                    world->DestroyJoint(_revolJoint);
                    _revolJoint = NULL;
                } 
                
                if(fishBody)
                {
                    world->DestroyBody(fishBody);
                    fishBody = NULL;
                }
                
                //curFish.scale = 0;
                curFishAnimated = [CCSprite spriteWithTexture: [curFish texture]];
                curFishAnimated.position = curFish.position;
                [self addChild: curFishAnimated];
                
                [AninatedFishesArray addObject: curFishAnimated];
                
                [self removeChild: curFish cleanup: YES];
                
                for (CCSprite *currentAnimatedSprite in AninatedFishesArray)
                {
                    [self fishAnimation: currentAnimatedSprite];
                }
                
                fishCount--;
                score++;
                
                [guiLayer updateScoreLabel: score];
            }
        }
        else
        {
            IsFishCauth = NO;
            IsHookActive = YES;
            
            if (_revolJoint) 
            {
                world->DestroyJoint(_revolJoint);
                _revolJoint = NULL;
            } 
            
            if(fishBody)
            {
                world->DestroyBody(fishBody);
                fishBody = NULL;
            }
            
            curFishAnimated = [CCSprite spriteWithTexture: [curFish texture]];
            
            b2Vec2 hookPos = coco.hook -> GetPosition();
            CGPoint picPosition = ccp(hookPos.x * 32, hookPos.y * 32);
            //CCLOG(@"PositionX; %f PositionY: %f", picPosition.x, picPosition.y);
            
            curFishAnimated.position = picPosition;
            [self addChild: curFishAnimated];
            
            [AninatedFishesArray addObject: curFishAnimated];
            
            [self removeChild: curFish cleanup: YES];
            
            for (CCSprite *currentAnimatedSprite in AninatedFishesArray)
            {
                [self fishAnimation: currentAnimatedSprite];
            }
            
            fishCount--;
            score++;
            
            [guiLayer updateScoreLabel: score];
            
            
        }
        //}
    }
    
    for(Fish* currentFishToRemove in fishToRemove)
    {
        [fishesArray removeObject: currentFishToRemove];
    }
    
    [fishToRemove release];

    
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}

}

- (void) fishAnimation: (CCSprite *) fishSprite
{
    //CCAction *moveFishAction = 
    
    [fishSprite runAction: 
                    [CCSequence actions: 
                                    [CCScaleTo actionWithDuration: 0.4 scale: 1.5], 
                                    [CCSpawn actions: 
                                                [CCScaleTo actionWithDuration: 0.4 
                                                                        scale: 0.0], 
                                                [CCMoveTo actionWithDuration: 0.4 
                                                                    position: ccp(50, GameHeight - 20)],
                                     nil], 
                     
                     //[CCCallFunc actionWithTarget: self selector: @selector(removeFishSprite)],
                     [CCCallFuncO actionWithTarget: self selector: @selector(removeFishSprite:) object: fishSprite],
                     nil]
     ];
    
    
}

- (void) removeFishSprite: (CCSprite *) fishSprite
{
    //[self removeChild: curFishAnimated cleanup: YES];
    [self removeChild: fishSprite cleanup: YES];
    [AninatedFishesArray removeObject: fishSprite];
}


// on "dealloc" you need to release all your retained objects

@end
