//
//  EEGMyScene.m
//  Emu Escape
//
//  Created by Christopher Zumberge on 4/8/14.
//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import "EEGMyScene.h"
#import "EEGBackground.h"
#import "EEGPlayer.h"
#import "EEGFatal.h"
#import "EEGSpeedUp.h"
#import "EEGGameOverScene.h"

@implementation EEGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.currentBackground = [EEGBackground generateNewBackground];
        [self addChild:self.currentBackground];
        self.currentParallax = [EEGBackground generateNewParallax];
        [self addChild:self.currentParallax];
        
        EEGPlayer *player = [[EEGPlayer alloc] init];
        player.position = CGPointMake(100, 60);
        [self addChild:player];
        self.player = player;
        
        self.score = 0;
        self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Regular"];
        self.scoreLabel.fontSize = 15;
        self.scoreLabel.color = [UIColor whiteColor];
        self.scoreLabel.position = CGPointMake(20, 260);
        self.scoreLabel.zPosition = 100;
        [self addChild:self.scoreLabel];
        
        SKAction *tempAction = [SKAction runBlock:^{
            self.scoreLabel.text = [NSString
                                    stringWithFormat:@"%3.0f", self.score];
        }];
        
        SKAction *waitAction = [SKAction waitForDuration:0.2];
        [self.scoreLabel runAction:[SKAction
                                    repeatActionForever:[SKAction sequence:@[tempAction, waitAction]]]];
        
        self.physicsWorld.gravity = CGVectorMake(0, globalGravity);
        self.physicsWorld.contactDelegate = self;
        
        for (int i = 0; i < maxFatals; i++) {
            [self addChild:[self spawnFatal]];
        }
        for (int i = 0; i < maxSpeedUps; i++) {
            [self addChild:[self spawnSpeedUp]];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver) name:@"playerDied" object:nil];
        
        self.boostTimer = 0;
        
    }
    return self;
}

-(void)adjustBaseline
{
    self.baseline = self.manager.accelerometerData.acceleration.x;
}

-(void)didMoveToView:(SKView *)view
{
    UILongPressGestureRecognizer *tapper =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScreen:)];
    tapper.minimumPressDuration = 0.1;
    [view addGestureRecognizer:tapper];
}

-(void)tappedScreen: (UITapGestureRecognizer *)recognizer
{
    EEGPlayer *player = (EEGPlayer *)[self childNodeWithName:@"player"];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        player.accelerating = YES;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        player.accelerating = NO;
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    EEGPlayer *player = nil;
    
    if (contact.bodyA.categoryBitMask == playerBitmask) {
        player = (EEGPlayer *) contact.bodyA.node;
        if (contact.bodyB.categoryBitMask == speedUpBitmask) {
            player.boost = YES;
            self.boostTimer = self.lastUpdateTimeInterval;
            self.prevBackgroundSpeed = backgroundMoveSpeed;
            backgroundMoveSpeed = 450;
            contact.bodyB.node.hidden = YES;
        }
        if (contact.bodyB.categoryBitMask == fatalBitmask) {
            [player takeDamage];
            contact.bodyB.node.hidden = YES;
        }
    }
    else {
        player = (EEGPlayer *) contact.bodyB.node;
        if (contact.bodyA.categoryBitMask == speedUpBitmask) {
            player.boost = YES;
            self.boostTimer = self.lastUpdateTimeInterval;
            self.prevBackgroundSpeed = backgroundMoveSpeed;
            backgroundMoveSpeed = 450;
            contact.bodyA.node.hidden = YES;
        }
        if (contact.bodyA.categoryBitMask == fatalBitmask) {
            [player takeDamage];
            contact.bodyA.node.hidden = YES;
        }
    }
}

-(void)willMoveFromView:(SKView *)view
{
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}

- (EEGFatal *) spawnFatal
{
    EEGFatal *temp = [[EEGFatal alloc] init];
    temp.name = @"fatal";
    temp.position = CGPointMake(self.size.width + arc4random() % 800, 50);
    //temp.position = CGPointMake(0, 0);
    return temp;
}

- (EEGSpeedUp *) spawnSpeedUp
{
    EEGSpeedUp * temp = [[EEGSpeedUp alloc] init];
    temp.name = @"speedup";
    temp.position = CGPointMake(self.size.width + arc4random() % 800, 60);
    return temp;
}

-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    CFTimeInterval timeSinceBoost = 0;
    if (_player.boost) {
        timeSinceBoost = currentTime - self.boostTimer;
    }
    self.lastUpdateTimeInterval = currentTime;
    
    if (timeSinceBoost > 5) {
        timeSinceBoost = 0;
        backgroundMoveSpeed = self.prevBackgroundSpeed;
        _player.boost = NO;
    }
    
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self enumerateChildNodesWithName:backgroundName usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(node.position.x - backgroundMoveSpeed * timeSinceLast, node.position.y);
        if (node.position.x < - (node.frame.size.width + 100)) {
            // if the node went completely off screen (with some extra pixels)
            // remove it
            [node removeFromParent];
        }}];
    if (self.currentBackground.position.x < 500) {
    //if (self.currentBackground.position.x < -500) {
        // we create new background node and set it as current node
        EEGBackground *temp = [EEGBackground generateNewBackground];
        temp.position = CGPointMake(self.currentBackground.position.x + self.currentBackground.frame.size.width, 0);
        [self addChild:temp];
        self.currentBackground = temp;
    }
    
    [self enumerateChildNodesWithName:parallaxName usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(node.position.x - parallaxMoveSpeed * timeSinceLast, node.position.y);
        if (node.position.x < - (node.frame.size.width + 100)) {
            // if the node went completely off screen (with some extra pixels)
            // remove it
            [node removeFromParent];
        }}];
    if (self.currentParallax.position.x < 500) {
        // we create new background node and set it as current node
        EEGBackground *temp = [EEGBackground generateNewParallax];
        temp.position = CGPointMake(self.currentParallax.position.x + self.currentParallax.frame.size.width, 0);
        [self addChild:temp];
        self.currentParallax = temp;
    }

    
    self.score = self.score + (backgroundMoveSpeed * timeSinceLast / 100);
    
    [self enumerateChildNodesWithName:@"player" usingBlock:^(SKNode *node, BOOL *stop) {
        EEGPlayer *player = (EEGPlayer *)node;
        if (player.accelerating) {
            [player.physicsBody applyForce:CGVectorMake(0, playerJumpForce * timeSinceLast)];
            player.animationState = playerStateJumping;
        }
        else if (player.position.y < 75) {
            player.animationState = playerStateRunning;
        }
    }];
    
    [self enumerateChildNodesWithName:@"fatal" usingBlock:^(SKNode *node, BOOL *stop) {
        EEGFatal *obstacle = (EEGFatal *)node;
        obstacle.position = CGPointMake(obstacle.position.x - backgroundMoveSpeed * timeSinceLast, obstacle.position.y);
        
        NSUInteger num = arc4random_uniform(2) + 1;
        
        if (obstacle.position.x < -200) {
            if (num == 1) {
                obstacle.position = CGPointMake(self.size.width + arc4random() % 800, 50);
                obstacle.hidden = NO;
            }
            else {
                obstacle.position = CGPointMake(self.size.width + arc4random() % 800, 50);
                obstacle.hidden =YES;
            }
        }
    }];
    
    [self enumerateChildNodesWithName:@"speedup" usingBlock:^(SKNode *node, BOOL *stop) {
        EEGSpeedUp *powerup = (EEGSpeedUp *)node;
        powerup.position = CGPointMake(powerup.position.x - backgroundMoveSpeed * timeSinceLast, powerup.position.y);
        
        NSUInteger num = arc4random_uniform(3) + 1;
        
        if (powerup.position.x < -200) {
            if (num == 1) {
                powerup.position = CGPointMake(self.size.width + arc4random() % 100, 60);
                powerup.hidden = NO;
            }
            else {
                powerup.position = CGPointMake(self.size.width + arc4random() % 100, 60);
                powerup.hidden = YES;
            }
        }
    }];

}

- (void) gameOver
{
    EEGGameOverScene *newScene = [[EEGGameOverScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:0.5];
    [self.view presentScene:newScene transition:transition];
}

@end
