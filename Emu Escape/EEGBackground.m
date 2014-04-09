//
//  EEGBackground.m
//  Emu Escape
//
//  Created by Christopher Zumberge on 4/8/14.
//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import "EEGBackground.h"

@implementation EEGBackground

+ (EEGBackground *)generateNewBackground
{
    EEGBackground *background = [[EEGBackground alloc] initWithImageNamed:@"background.png"];
    background.anchorPoint = CGPointMake(0, 0);
    background.name = backgroundName;
    background.position = CGPointMake(0, 0);
    background.zPosition = 1;
    background.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 30) toPoint:CGPointMake(background.size.width, 30)];
    background.physicsBody.collisionBitMask = playerCollisionBitmask;
    SKNode *topCollider = [SKNode node];
    topCollider.position = CGPointMake(0, 0);
    topCollider.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, background.size.height - 30) toPoint:CGPointMake(background.size.width, background.size.height - 20)];
    topCollider.physicsBody.collisionBitMask = 1;
    [background addChild:topCollider];
    return background;
}

@end
