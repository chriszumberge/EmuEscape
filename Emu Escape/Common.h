//
//  Common.h
//  Emu Escape
//
//  Created by Christopher Zumberge on 4/8/14.
//  Copyright (c) 2014 Christopher Zumberge. All rights reserved.
//

#ifndef Emu_Escape_Common_h
#define Emu_Escape_Common_h

static NSString *backgroundName = @"background";
static NSString *parallaxName = @"parallax";
static NSInteger parallaxMoveSpeed = 10;
static NSInteger backgroundMoveSpeed = 300;
static NSString *playerName = @"player";
static NSInteger accelerometerMultiplier = 15;
static NSInteger playerMass = 80;
static NSInteger playerCollisionBitmask = 1;
static NSInteger playerJumpForce = 8000000;
static NSInteger globalGravity = -4.8;

static int playerBitmask = 1;
static int fatalBitmask = 2;
static int speedUpBitmask = 4;
static int groundBitmask = 8;

static NSInteger maxFatals = 2;
static NSInteger maxSlows = 2;
static NSInteger maxSpeedUps = 1;

#endif
