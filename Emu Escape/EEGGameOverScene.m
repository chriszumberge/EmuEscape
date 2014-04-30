//
//  EEGGameOverScene.m
//  Emu Escape
//
//  Created by Christopher Zumberge on 4/29/14.
//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#import "EEGGameOverScene.h"
#import "EEGMyScene.h"

@implementation EEGGameOverScene

-(instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    NSLog(@"Inits");
    if (self) {
        SKLabelNode *node = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Regular"];
        node.text = @"Game Over";
        node.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        node.fontSize = 35;
        node.color = [UIColor whiteColor];
        [self addChild:node];
        
        SKLabelNode *subNode = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Regular"];
        subNode.text = @"Tap to try again.";
        subNode.position = CGPointMake(self.size.width / 2, self.size.height / 4);
        subNode.fontSize = 20;
        subNode.color = [UIColor whiteColor];
        [self addChild:subNode];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) didMoveToView:(SKView *)view
{
    NSLog(@"Moves to view");
    [super didMoveToView:view];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newGame)];
    [view addGestureRecognizer:tapper];
}

- (void) newGame
{
    NSLog(@"Tapped");
    EEGMyScene *newScene = [[EEGMyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:0.5];
    [self.view presentScene:newScene transition:transition];
}


@end
