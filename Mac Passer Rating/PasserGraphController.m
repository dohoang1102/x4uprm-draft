//
//  PasserGraphController.m
//  Mac Passer Rating
//
//  Created by Xcode User on 8/15/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import "PasserGraphController.h"
#import "Game.h"
#import "Passer.h"

@interface PasserGraphController ()
@property(nonatomic, strong) NSArray *  gameArray;
@end

@implementation PasserGraphController

@synthesize gameArray, completionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) awakeFromNib
{
    NSSet *     games = ((Passer *) self.representedObject).games;
    self.gameArray = [games sortedArrayUsingDescriptors:
                      [NSArray arrayWithObject:
                       [NSSortDescriptor sortDescriptorWithKey: @"whenPlayed"
                                                     ascending: YES]]];
    self.completionView.gameCount = self.gameArray.count;
}

#pragma mark - PassCompletionDelegate

- (Game *) passCompletion: (PassCompletionView *) view
              gameAtIndex: (NSUInteger) index
{
    return [self.gameArray objectAtIndex: index];
}

@end
