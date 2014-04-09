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

@implementation EEGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.currentBackground = [EEGBackground generateNewBackground];
        [self addChild:self.currentBackground];
        
        EEGPlayer *player = [[EEGPlayer alloc] init];
        player.position = CGPointMake(100, 60);
        [self addChild:player];
        
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

-(void)willMoveFromView:(SKView *)view
{
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
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
    if (self.currentBackground.position.x < -500) {
        // we create new background node and set it as current node
        EEGBackground *temp = [EEGBackground generateNewBackground];
        temp.position = CGPointMake(self.currentBackground.position.x + self.currentBackground.frame.size.width, 0);
        [self addChild:temp];
        self.currentBackground = temp;
    }
    
    self.score = self.score + (backgroundMoveSpeed * timeSinceLast / 100);
    
    [self enumerateChildNodesWithName:@"player" usingBlock:^(SKNode *node, BOOL *stop) {
        EEGPlayer *player = (EEGPlayer *)node;
        if (player.accelerating) {
            [player.physicsBody applyForce:CGVectorMake(0, playerJumpForce * timeSinceLast)];
        }
    }];
}

@end
