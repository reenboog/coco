//
//  SettingsLayer.m
//  catchCoco
//
//  Created by Mac on 14.04.12.
//  Copyright 2012 spotGames. All rights reserved.
//

#import "SettingsLayer.h"
#import "GameConfig.h"
#import "MainMenuLayer.h"
#import "SelectGameLayer.h"
#import "SimpleAudioEngine.h"


@implementation SettingsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingsLayer *layer = [SettingsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"settingsBg.jpg"];
        background.position = ccp(GameCenterX, GameCenterY);
        [self addChild:background];
        
        CCMenuItemImage *BackToMainMenu = [CCMenuItemImage itemFromNormalImage: @"backBtn.png" 
                                                                 selectedImage: @"backBtnOn.png"
                                                                        target: self 
                                                                      selector: @selector(goToMainMenu:)];
        
        BackToMainMenu.position = ccp(GameWidth * 0.075, GameHeight * 0.065);
        
        CCMenu *backMenu = [CCMenu menuWithItems: BackToMainMenu, nil];
        backMenu.position = ccp(0,0);
        backMenu.scale = 0.8;
        [self addChild: backMenu];
        
        //////////////// difficulty
        
        CCSprite *selectDifficulty = [CCSprite spriteWithFile:@"selectDif.png"];
        selectDifficulty.position = ccp(GameCenterX, GameHeight * 0.30);
        
        selectDifficulty.scale = 0.9;
        
        [selectDifficulty setOpacity:200];
        
        [self addChild:selectDifficulty];
        
        CCMenuItemImage *easy = [CCMenuItemImage itemFromNormalImage:@"easy.png" selectedImage:@"easy.png"];
        
        easy.tag = kEasyDif;
        easy.scale = 0.7;
        
        easy.position = ccp(GameCenterX, GameHeight * 0.12);
        
        CCMenuItemImage *medium = [CCMenuItemImage itemFromNormalImage:@"medium.png" selectedImage:@"medium.png"];
        
        medium.tag = kMediumDif;
        medium.scale = 0.7;
        
        medium.position = ccp(GameCenterX, GameHeight * 0.12);
        
        
        CCMenuItemImage *hard = [CCMenuItemImage itemFromNormalImage:@"hard.png" selectedImage:@"hard.png"];
        
        hard.tag = kHardDif;
        hard.scale = 0.7;
        
        hard.position = ccp(GameCenterX, GameHeight * 0.12);
        
        
        CCMenu *difficultyMenu = [CCMenu menuWithItems: nil];
        difficultyMenu.position = ccp(0, 0);
        [self addChild:difficultyMenu];
        
        
        if (CurrentDifficulty == 0)
        {
            CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(selectDif:) items: easy, medium, hard, nil];
            difficulty.position = ccp(GameCenterX, GameHeight * 0.15);
            [difficultyMenu addChild:difficulty];
        }
        else if (CurrentDifficulty == 1)
        {
            CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(selectDif:) items: medium, hard, easy, nil];
            difficulty.position = ccp(GameCenterX, GameHeight * 0.15);
            [difficultyMenu addChild:difficulty];
        }
        else if (CurrentDifficulty == 2)
        {
            CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(selectDif:) items: hard, easy, medium, nil];
            difficulty.position = ccp(GameCenterX, GameHeight * 0.15);
            [difficultyMenu addChild:difficulty];
        }
        
        
        ////////////////
        
        CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"playMenuBtn.png" 
                                                       selectedImage:@"playMenuBtnOn.png"
                                                              target:self 
                                                            selector:@selector(showMainMenu:)
                                 ];
        
        
        
        CCMenuItemImage *eng = [CCMenuItemImage itemFromNormalImage: @"engLangNormal.png"
                                                      selectedImage: @"engLangOn.png"
                                                             target: self 
                                                           selector: @selector(selectLang:)
                                ];
        eng.tag = kLangEng;
        
        CCMenuItemImage *fr = [CCMenuItemImage itemFromNormalImage:@"frLangNormal.png" 
                                                     selectedImage:@"frLangOn.png"
                                                            target:self 
                                                          selector:@selector(selectLang:)
                               ];
        fr.tag = kLangFr;
        
        CCMenuItemImage *ger = [CCMenuItemImage itemFromNormalImage:@"gerLangNormal.png" 
                                                      selectedImage:@"gerLangOn.png"
                                                             target:self 
                                                           selector:@selector(selectLang:)
                                ];
        ger.tag = kLangGer;
        
        CCMenuItemImage *man = [CCMenuItemImage itemFromNormalImage:@"manLangNormal.png" 
                                                      selectedImage:@"manLangOn.png"
                                                             target:self 
                                                           selector:@selector(selectLang:)
                                ];
        man.tag = kLangMan;
        
        CCMenuItemImage * span = [CCMenuItemImage itemFromNormalImage:@"spanLangNormal.png" 
                                                        selectedImage:@"spanLangOn.png"
                                                               target:self 
                                                             selector:@selector(selectLang:)
                                  ];
        span.tag = kLangSpan;
        
        back.scale = 0.9;
        back.position = ccp(GameWidth * 0.85, GameHeight * 0.205f);
        eng.position  = ccp(GameCenterX, GameHeight * 0.7);
        fr.position   = ccp(GameWidth * 0.20, GameHeight * 0.80);
        ger.position  = ccp(GameWidth * 0.80, GameHeight * 0.80);
        man.position  = ccp(GameWidth * 0.20, GameHeight * 0.50);
        span.position = ccp(GameWidth * 0.80, GameHeight * 0.50);

        CCMenu *menu = [CCMenu menuWithItems:back, eng, fr, ger, man, span, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
        
        
        selection = [CCMenuItemImage itemFromNormalImage: @"selection.png" 
                                           selectedImage: @"selection.png"
                     ];
        
        selection.scaleY = 0.95;
        [menu addChild: selection z: kZSelection];
        
        
        //apply current language to selection
        
        for(CCMenuItem *item in menu.children)
        {
            if(CurrentLanguage == item.tag)
            {
                selection.position = item.position;
                
                break;
            }
        }
        
        
    }
	return self;
}

- (void) goToMainMenu: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [MainMenuLayer scene]]];
}

-(void)showMainMenu:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"tap.mp3"];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f 
                                                                                  scene: [SelectGameLayer scene] 
                                               ]
    ];
}

- (void) selectLang: (CCMenuItem *) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"tap.mp3"];
    
    [selection stopAllActions];
    
    [selection runAction: 
     [CCEaseBackOut actionWithAction:
      [CCMoveTo actionWithDuration: 0.5f position: sender.position]
      ]
     ];
    
    CurrentLanguage = sender.tag;
}

- (void) selectDif: (CCMenuItem *) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"tap.mp3"];
    
    CurrentDifficulty++;
    
    if(CurrentDifficulty > 2)
    {
        CurrentDifficulty = 0;
    }
    
}

- (void) dealloc
{
	[super dealloc];
}

@end
