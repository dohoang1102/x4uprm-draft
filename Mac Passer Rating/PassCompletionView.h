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

@property(nonatomic, assign) CGFloat        cellWidth;
@property(nonatomic, assign) NSUInteger     attRed;
@property(nonatomic, assign) NSUInteger     attGreen;
@property(nonatomic, assign) NSUInteger     attBlue;
@property(strong) NSColor *                 attColor;
@property(nonatomic, assign) NSUInteger     compGreen;
@property(nonatomic, assign) NSUInteger     compRed;
@property(nonatomic, assign) NSUInteger     compBlue;
@property(strong) NSColor *                 compColor;

@property(nonatomic, assign) NSUInteger     gameCount;

@end
