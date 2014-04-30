//
//  EEGPlayer.h
//  Emu Escape
//
//  Created by Christopher Zumberge on 4/8/14.
//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EEGPlayer : SKSpriteNode

typedef enum playerState {
    playerStateRunning = 0,
    playerStateJumping,
    playerStateInAir
} playerState;

@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) BOOL accelerating;
@property (strong, nonatomic) NSMutableArray *runFrames;
@property (strong, nonatomic) NSMutableArray *jumpFrames;
@property (assign, nonatomic) playerState animationState;
@property (assign, nonatomic) BOOL boost;

@property (strong, nonatomic) SKEmitterNode *engineEmitter;

- (void) takeDamage;

@end
