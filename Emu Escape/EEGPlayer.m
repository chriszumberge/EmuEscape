//
//  EEGPlayer.m
//  Emu Escape
//
//  Created by Christopher Zumberge on 4/8/14.
//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import "EEGPlayer.h"

@implementation EEGPlayer

- (instancetype)init
{
    self = [super initWithImageNamed:@"character.png"];
    {
        self.name = playerName;
        self.zPosition = 10;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.mass = playerMass;
        self.physicsBody.collisionBitMask = playerCollisionBitmask;
        self.physicsBody.contactTestBitMask = speedUpBitmask | fatalBitmask;
        self.physicsBody.collisionBitMask = groundBitmask;
        self.physicsBody.categoryBitMask = playerBitmask;
        self.physicsBody.allowsRotation = NO;
        [self setupAnimations];
        [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.runFrames timePerFrame:0.05 resize:YES restore:NO]] withKey:@"running"];
        self.engineEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile: [[NSBundle mainBundle]
                                                                        pathForResource:@"dustkick" ofType:@"sks"]];
        self.engineEmitter.position = CGPointMake(-4, -14);
        self.engineEmitter.name = @"dustEmitter";
        [self addChild:self.engineEmitter];
        self.engineEmitter.hidden = NO;
        
    }
    return self;
}

- (void) setupAnimations
{
    self.runFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *runAtlas = [SKTextureAtlas atlasNamed:@"run"];
    
    for (int i = 0; i < [runAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString stringWithFormat:@"run%.3d", i];
        SKTexture *tempTexture = [runAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.runFrames addObject:tempTexture];
        }
    }
    
    self.jumpFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *jumpAtlas = [SKTextureAtlas atlasNamed:@"jump"];
    
    for (int i = 0; i < [jumpAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString stringWithFormat:@"jump%.3d", i];
        SKTexture *tempTexture = [jumpAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.jumpFrames addObject:tempTexture];
        }
    }
}

- (void) takeDamage
{
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playerDied" object:nil];
}

/*
- (void) setAccelerating:(BOOL)accelerating
{
    if (accelerating) {
        if (self.engineEmitter.hidden) {
            self.engineEmitter.hidden = NO;
        }
        else {
            self.engineEmitter.hidden = YES;
        }
        _accelerating = accelerating;
        NSLog(accelerating ? @"YES" : @"NO");
    }
}
*/
/*
- (void) setAccelerating:(BOOL)accelerating
{
    if (accelerating) {
        if (!self.engineEmitter.hidden) {
            self.engineEmitter.hidden = NO;
        }
    } else {
        self.engineEmitter.hidden = YES;
    }
    _accelerating = accelerating;
    NSLog(accelerating ? @"YES" : @"NO");
}
*/
- (void) setAnimationState:(playerState)animationState
{
    switch (animationState) {
        case playerStateJumping:
            if (_animationState == playerStateRunning) {
                [self stopRuningAnimation];
                [self startJumpingAnimation];
            }
            break;
        case playerStateInAir:
            [self stopRuningAnimation];
            break;
        case playerStateRunning:
            [self startRunningAnimation];
            break;
        default:
            break;
    }
    _animationState = animationState;
}

- (void) startRunningAnimation
{
    if (![self actionForKey:@"running"]){
        [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.runFrames timePerFrame:0.075 resize:YES restore:NO]] withKey:@"running"];
    }
    self.engineEmitter.hidden = NO;
}

- (void) stopRuningAnimation
{
    [self removeActionForKey:@"running"];
    self.engineEmitter.hidden = YES;
}

- (void) startJumpingAnimation
{
    if (![self actionForKey:@"jumping"]) {
        [self runAction:[SKAction sequence:@[[SKAction animateWithTextures:self.jumpFrames timePerFrame:0.05 resize:YES restore:NO], [SKAction runBlock:^{self.animationState = playerStateInAir;}]]] withKey:@"jumping"];
    }
}

@end
