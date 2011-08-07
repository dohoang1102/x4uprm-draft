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
}


@property(strong) Game *        game;
@property (strong) IBOutlet NSObjectController *objectController;

@end
