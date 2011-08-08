//
//  GameViewController.h
//  Mac Passer Rating
//
//  Created by Xcode User on 8/7/11.
//  Copyright 2011 Fritz Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Game;

@interface GameViewController : NSViewController {
    NSObjectController *objectController;
    NSTextField *ourTeamLabel;
    NSTextField *theirTeamLabel;
    NSTextField *ourScoreLabel;
    NSTextField *theirScoreLabel;
    NSTextField *attemptsLabel;
    NSTextField *completionsLabel;
    NSTextField *yardsLabel;
    NSTextField *touchdownsLabel;
    NSTextField *interceptionsLabel;
}


@property (strong) IBOutlet NSObjectController *objectController;
@property (strong) IBOutlet NSTextField *ourTeamLabel;
@property (strong) IBOutlet NSTextField *theirTeamLabel;
@property (strong) IBOutlet NSTextField *ourScoreLabel;
@property (strong) IBOutlet NSTextField *theirScoreLabel;
@property (strong) IBOutlet NSTextField *attemptsLabel;
@property (strong) IBOutlet NSTextField *completionsLabel;
@property (strong) IBOutlet NSTextField *yardsLabel;
@property (strong) IBOutlet NSTextField *touchdownsLabel;
@property (strong) IBOutlet NSTextField *interceptionsLabel;

@end
