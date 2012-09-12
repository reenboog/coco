//
//  Fish.m
//  openGLExample
//
//  Created by Mac on 29.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Fish.h"
#import "Common.h"

@implementation Fish

@synthesize gameLayer;
@synthesize sprite;
@synthesize type;
@synthesize randFish;


- (id) init 
{
    self = [super init];
    if(self)
    {
        type = arc4random() % 5;
        height = arc4random() % 190 + 30;
        
        if(type == 1)
        {
            sprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"%ifish.png", type]];
            height = 30;
            speed = 14.0;
        }
        
        else if(type == 0)
        {
            randFish = arc4random() % 2;
            sprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"%i%ifish.png", type, randFish]];
            speed = 5.0;
        }
        else if(type == 4)
        {
            sprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"%ifish.png", type]];
            speed = 7.0;
            height = arc4random() % 50 + 30;
        }
        else
        {
            sprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"%ifish.png", type]];
            speed = 9.0;
        }
        
        
        
        sprite.anchorPoint = ccp(1.0, 0.5);
        
        
        
        self.position = ccp(550, height);
        //self.scale = 0.5;
        
        
        [self addChild: sprite];
    }
    
    return self;
}

+ (Fish *) createFish 
{
    Fish *fish = [[[Fish alloc] init] autorelease];
    
    return fish;
}

- (void) swim
{
    [self runAction: 
                [CCCallFunc actionWithTarget: self 
                                    selector: @selector(swimAnimation)]];
    [self runAction: 
                [CCSequence actions: 
                            [CCMoveTo actionWithDuration: speed 
                                                position: ccp(-60, self.position.y)], 
                            [CCCallFuncO actionWithTarget: gameLayer 
                                                 selector: @selector(removeFish:) 
                                                   object: self], 
                 nil]
     ];
}

- (void) swimAnimation
{
    if(type == 0)
    {
        CCLOG(@"RandFish: %i Type: %i", randFish, type);
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"%i%ifChase.plist", type, randFish]];
        
        [Common loadAnimationWithPlist: @"walkAnimation" andName: [NSString stringWithFormat: @"%i%ifChase", type, randFish]];
        
        [sprite runAction:
         [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: [[CCAnimationCache sharedAnimationCache] animationByName: [NSString stringWithFormat: @"%i%ifChase", type, randFish]]
                                                      restoreOriginalFrame: YES]]];
    }
    else
    {
        CCLOG(@"RandFish: %i Type: %i", randFish, type);
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"%ifChase.plist", type]];
        
        [Common loadAnimationWithPlist: @"walkAnimation" andName: [NSString stringWithFormat: @"%ifChase", type]];
        
        [sprite runAction:
         [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: [[CCAnimationCache sharedAnimationCache] animationByName: [NSString stringWithFormat: @"%ifChase", type]]
                                                      restoreOriginalFrame: YES]]];
    }
    
    
}

@end
