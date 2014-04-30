//
//  EEGSpeedUp.m
//  Emu Escape
//
//  Created by Christopher Zumberge on 4/29/14.
//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import "EEGSpeedUp.h"

@implementation EEGSpeedUp

- (void) setup
{
    self.emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                    [[NSBundle mainBundle] pathForResource:@"speedup" ofType:@"sks"]];
    self.emitter.name = @"speedupEmitter";
    self.emitter.zPosition = 50;
    [self addChild:self.emitter];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    self.physicsBody.contactTestBitMask = playerBitmask;
    self.physicsBody.categoryBitMask = speedUpBitmask;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.affectedByGravity = NO;
}

@end
