//
//  EEGMyScene.h
//  Emu Escape
//

//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import CoreMotion;

@class EEGBackground, EEGPlayer;
@interface EEGMyScene : SKScene <SKPhysicsContactDelegate>

@property (strong, nonatomic) EEGPlayer *player;
@property (strong, nonatomic) EEGBackground *currentBackground;
@property (assign) CFTimeInterval lastUpdateTimeInterval;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (assign) double score;
@property (strong, nonatomic) CMMotionManager *manager;
@property (assign) float baseline;
@property (strong, nonatomic) EEGBackground *currentParallax;

@property (nonatomic) NSInteger prevBackgroundSpeed;

@property (assign) CFTimeInterval boostTimer;

@end
