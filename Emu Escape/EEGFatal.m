//
//  EEGFatal.m
//  Emu Escape
//
//  Created by Christopher Zumberge on 4/29/14.
//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import "EEGFatal.h"

@implementation EEGFatal

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"]];
    self.emitter.name = @"fireEmitter";
    self.emitter.zPosition = 50;
    [self addChild:self.emitter];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    self.physicsBody.contactTestBitMask = playerBitmask;
    self.physicsBody.categoryBitMask = fatalBitmask;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.affectedByGravity = NO;
}

@end
