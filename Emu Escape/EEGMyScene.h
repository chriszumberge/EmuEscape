//
//  EEGMyScene.h
//  Emu Escape
//

//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import CoreMotion;

@class EEGBackground;
@interface EEGMyScene : SKScene

@property (strong, nonatomic) EEGBackground *currentBackground;
@property (assign) CFTimeInterval lastUpdateTimeInterval;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (assign) double score;
@property (strong, nonatomic) CMMotionManager *manager;
@property (assign) float baseline;

@end
