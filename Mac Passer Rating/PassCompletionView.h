//
//  PassCompletionView.h
//  Mac Passer Rating
//
//  Created by Xcode User on 8/15/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Game;
@class PassCompletionView;

@protocol PassCompletionDelegate <NSObject>

- (Game *) passCompletion: (PassCompletionView *) view
              gameAtIndex: (NSUInteger) index;

@end

@interface PassCompletionView : NSView

@property(nonatomic, assign) IBOutlet id<PassCompletionDelegate>  delegate;

@property(nonatomic, assign) IBOutlet CGFloat        cellWidth;
@property(nonatomic, assign) IBOutlet NSUInteger     attRed;
@property(nonatomic, assign) IBOutlet NSUInteger     attGreen;
@property(nonatomic, assign) IBOutlet NSUInteger     attBlue;
@property(nonatomic, assign) IBOutlet NSUInteger     compGreen;
@property(nonatomic, assign) IBOutlet NSUInteger     compRed;
@property(nonatomic, assign) IBOutlet NSUInteger     compBlue;

@property(nonatomic, assign) NSUInteger              gameCount;

@end
