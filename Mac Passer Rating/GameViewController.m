//
//  GameViewController.m
//  Mac Passer Rating
//
//  Created by Xcode User on 8/7/11.
//  Copyright 2011 Fritz Anderson. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

@synthesize objectController;
@synthesize ourTeamLabel;
@synthesize theirTeamLabel;
@synthesize ourScoreLabel;
@synthesize theirScoreLabel;
@synthesize attemptsLabel;
@synthesize completionsLabel;
@synthesize yardsLabel;
@synthesize touchdownsLabel;
@synthesize interceptionsLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
