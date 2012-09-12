//
//  GUILayer.m
//  openGLExample
//
//  Created by Mac on 25.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GUILayer.h"
#import "GameLayer.h"
#import "GameConfig.h"
#import "MainMenuLayer.h"


@implementation GUILayer

@synthesize gameLayer;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if((self = [super init]))
    {
        scoreLabel = [CCLabelBMFont labelWithString: @"Score: 0" fntFile: @"font20.fnt"];
        scoreLabel.anchorPoint = ccp(0, 0.5);
        scoreLabel.position = ccp(20, GameHeight - 20);
        [self addChild: scoreLabel];
        
        timeLabel = [CCLabelBMFont labelWithString: @"Time: 01:30" fntFile: @"font20.fnt"];
        timeLabel.anchorPoint = ccp(0, 0.5);
        timeLabel.position = ccp(120, GameHeight - 20);
        //if(CurrentDifficulty == 1 || CurrentDifficulty == 2)
        //{
            [self addChild: timeLabel];
        //}
        
        CCMenuItemImage *pauseBtn = [CCMenuItemImage itemFromNormalImage: @"pauseBtn.png" selectedImage: @"pauseBtn.png"
                                                             target: self 
                                                           selector: @selector(showPauseMenu)
                                      ];
        
        pauseBtn.scale = 0.65;
        pauseBtn.position = ccp(GameWidth - 25, GameHeight - 20);
        
        CCMenu *settingsMenu = [CCMenu menuWithItems: pauseBtn, nil];
        settingsMenu.position = ccp(0,0);
        [self addChild: settingsMenu];
    }
    
    return self;
}

- (void) continuePlay
{
    IsGameActive = YES;
    
    [self removeChild: pauseLayer cleanup: YES];
    [self removeChild: pauseMenu cleanup: YES];
    [self removeChild: yourScore cleanup: YES];
    [self removeChild: yourBestScoreLabel cleanup: YES];
    [self removeChild: pauseLabel cleanup: YES];
    
    [gameLayer unPauseGame];
}

- (void) replayGame
{
    timeLabel.string = @"Time: 01:30";
    scoreLabel.string = @"Score: 0";
    
    IsGameActive = YES;
    IsRestartGame = YES;
    
    [self removeChild: pauseLayer cleanup: YES];
    [self removeChild: pauseMenu cleanup: YES];
    [self removeChild: yourScore cleanup: YES];
    [self removeChild: yourBestScoreLabel cleanup: YES];
    [self removeChild: pauseLabel cleanup: YES];

    [gameLayer startGame];
}

- (void) showPauseMenu
{
    if(IsGameActive == YES)
    {
        IsGameActive = NO;
        [gameLayer doPauseGame];
        
        pauseLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 225)];
        pauseLayer.position = ccp(0,0);
        [self addChild: pauseLayer];
        
        pauseLabel = [CCLabelBMFont labelWithString: @"PAUSE" fntFile: @"font35.fnt"];
        pauseLabel.color = ccc3(255, 0, 0);
        pauseLabel.position = ccp(GameCenterX, GameHeight + 100);
        [self addChild: pauseLabel];
        
        yourScore = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"%@", scoreLabel.string] 
                                           fntFile: @"font20.fnt"
                                    ];
        
        yourScore.position = ccp(GameCenterX, GameHeight + 100);
        [self addChild: yourScore];
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage: @"playBtn.png" 
                                                       selectedImage: @"playBtnTap.png"
                                                              target: self 
                                                            selector: @selector(continuePlay)];
        
        CCMenuItemImage *replay = [CCMenuItemImage itemFromNormalImage: @"replayBtn.png" 
                                                         selectedImage: @"replayBtnTap.png"
                                                                target: self 
                                                              selector: @selector(replayGame)];
        
        CCMenuItemImage *exit = [CCMenuItemImage itemFromNormalImage: @"exitBtn.png" 
                                                       selectedImage: @"exitBtnTap.png"
                                                              target: self
                                                            selector: @selector(backInMenu:)];
        
        exit.position = ccp(GameCenterX - 110, GameCenterY - 50);
        replay.position = ccp(GameCenterX, GameCenterY - 50);
        play.position = ccp(GameCenterX + 110, GameCenterY - 50);
        
        exit.scale = 0;
        replay.scale = 0;
        play.scale = 0;
        
        [pauseLabel runAction: 
                    [CCEaseBackOut actionWithAction: 
                                                [CCMoveTo actionWithDuration: 0.5 
                                                                    position: ccp(GameCenterX, GameCenterY + 50)]
                     ]
         ];

        [yourScore runAction: 
                    [CCEaseBackOut actionWithAction: 
                                                [CCMoveTo actionWithDuration: 0.5 
                                                                    position: ccp(GameCenterX, GameCenterY + 5)]
                     ]
         ];
        
        [exit runAction: 
                    [CCScaleTo actionWithDuration: 0.1 
                                            scale: 1.0]
         ];
        
        [replay runAction: 
                    [CCSequence actions: 
                                    [CCDelayTime actionWithDuration: 0.05], 
                                    [CCScaleTo actionWithDuration: 0.1 
                                                            scale: 1.0],
                     nil]
         ];
        
        [play runAction: 
                    [CCSequence actions: 
                                    [CCDelayTime actionWithDuration: 0.1], 
                                    [CCScaleTo actionWithDuration: 0.1 
                                                            scale: 1.0], 
                     nil]
         ];
        
        pauseMenu = [CCMenu menuWithItems: exit, replay, play, nil];
        pauseMenu.position = ccp(0,0);
        [self addChild: pauseMenu];
    }
}

- (void) showGameOverMenu: (NSInteger) bestScore
{
    if(IsGameActive == YES)
    {
        IsGameActive = NO;
        [gameLayer doPauseGame];
        
        pauseLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 225)];
        pauseLayer.position = ccp(0,0);
        [self addChild: pauseLayer];
        
        pauseLabel = [CCLabelBMFont labelWithString: @"GAME OVER" fntFile: @"font35.fnt"];
        pauseLabel.color = ccc3(255, 0, 0);
        pauseLabel.position = ccp(GameCenterX, GameHeight + 100);
        [self addChild: pauseLabel];
        
        yourScore = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"%@", scoreLabel.string] 
                                           fntFile: @"font25.fnt"
                     ];
        
        yourScore.position = ccp(GameCenterX, GameHeight + 100);
        [self addChild: yourScore];
        
        yourBestScoreLabel = [CCLabelBMFont labelWithString: @"" fntFile: @"font20.fnt"];
        yourBestScoreLabel.string = [NSString stringWithFormat: @"Best score: %i", bestScore];
        yourBestScoreLabel.position = ccp(GameCenterX, GameHeight + 100);
        [self addChild: yourBestScoreLabel];

        
        CCMenuItemImage *replay = [CCMenuItemImage itemFromNormalImage: @"replayBtn.png" 
                                                         selectedImage: @"replayBtnTap.png"
                                                                target: self 
                                                              selector: @selector(replayGame)];
        
        CCMenuItemImage *exit = [CCMenuItemImage itemFromNormalImage: @"exitBtn.png" 
                                                       selectedImage: @"exitBtnTap.png"
                                                              target: self
                                                            selector: @selector(backInMenu:)];
        
        exit.position = ccp(GameCenterX - 55, GameCenterY - 60);
        replay.position = ccp(GameCenterX + 55, GameCenterY - 60);
        
        exit.scale = 0;
        replay.scale = 0;
        
        [pauseLabel runAction: 
         [CCEaseBackOut actionWithAction: 
          [CCMoveTo actionWithDuration: 0.5 
                              position: ccp(GameCenterX, GameCenterY + 70)]
          ]
         ];
        
        [yourBestScoreLabel runAction: 
         [CCEaseBackOut actionWithAction: 
          [CCMoveTo actionWithDuration: 0.5 
                              position: ccp(GameCenterX, GameCenterY - 5)]
          ]
         ];
        
        [yourScore runAction: 
         [CCEaseBackOut actionWithAction: 
          [CCMoveTo actionWithDuration: 0.5 
                              position: ccp(GameCenterX, GameCenterY + 25)]
          ]
         ];
        
        [exit runAction: 
         [CCScaleTo actionWithDuration: 0.1 
                                 scale: 1.0]
         ];
        
        [replay runAction: 
         [CCSequence actions: 
          [CCDelayTime actionWithDuration: 0.05], 
          [CCScaleTo actionWithDuration: 0.1 
                                  scale: 1.0],
          nil]
         ];
        
        pauseMenu = [CCMenu menuWithItems: exit, replay, nil];
        pauseMenu.position = ccp(0,0);
        [self addChild: pauseMenu];
    }
}

- (void) updateScoreLabel: (NSInteger) score
{
    scoreLabel.string = [NSString stringWithFormat: @"Score: %i", score];
    CCLOG(@"Score: %i", score);
}

-(void) formatCurrentTime:(NSInteger) seconds
{
    if(seconds< 10)
    {
        timeLabel.string = [NSString stringWithFormat: @"Time 00:0%i", seconds];
    }
    else if(seconds < 60)
    {
        timeLabel.string = [NSString stringWithFormat: @"Time 00:%i", seconds];
    }
    else if(seconds < 600)
    {
        NSInteger n = seconds%60;
        if(n < 10)
        {
            timeLabel.string = [NSString stringWithFormat: @"Time 0%i:0%i", seconds/60, n];
        }
        else
        {
            timeLabel.string = [NSString stringWithFormat: @"Time 0%i:%i", seconds/60, n]; 
        }
    }
    else
    {
        NSInteger n = seconds%60;
        if(n < 10)
        {
            timeLabel.string = [NSString stringWithFormat: @"Time %i:0%i", seconds/60, n];
        }
        else
        {
            timeLabel.string = [NSString stringWithFormat: @"Time %i:%i", seconds/60, n]; 
        }
    }
}


- (void) backInMenu: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [MainMenuLayer scene]]];
}

@end
