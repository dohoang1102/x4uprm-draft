//
//  PasserGraphController.h
//  Mac Passer Rating
//
//  Created by Xcode User on 8/15/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PassCompletionView.h"

@class Game;

@interface PasserGraphController : NSViewController
<PassCompletionDelegate>

@property(nonatomic, strong) IBOutlet PassCompletionView *  completionView;

@end
