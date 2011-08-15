//
//  PassCompletionView.m
//  Mac Passer Rating
//
//  Created by Xcode User on 8/15/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import "PassCompletionView.h"
#import "Game.h"

#define CELL_PADDING    2.0
#define GRAPH_PADDING   6.0
#define MAX_ATTEMPTS    75

@interface PassCompletionView ()
@property(strong) NSColor *     compColor;
@property(strong) NSColor *     attColor;
@end

@implementation PassCompletionView

@synthesize delegate;
@synthesize cellWidth, gameCount;
@synthesize attColor, attRed, attGreen, attBlue;
@synthesize compColor, compRed, compGreen, compBlue;

- (id) initWithFrame: (NSRect) frame
{
    self = [super initWithFrame: frame];
    if (self) {
        // Default colors:
        self.compColor = [NSColor blueColor];
        self.attColor = [NSColor redColor];
    }
    
    return self;
}

- (void) awakeFromNib
{
    self.compColor = [NSColor colorWithDeviceRed: (self.compRed / 255.0)
                                           green: (self.compGreen / 255.0)
                                            blue: (self.compBlue / 255.0)
                                           alpha: 1.0];
    self.attColor = [NSColor colorWithDeviceRed: (self.attRed / 255.0)
                                          green: (self.attGreen / 255.0)
                                           blue: (self.attBlue / 255.0)
                                          alpha: 1.0];
}

- (void) recalculateFrame
{
    NSUInteger  cellCount = self.gameCount;
    if (cellCount < 10)
        cellCount = 10;
    
    NSRect      oldFrame = self.frame;
    oldFrame.size.width = 2 * GRAPH_PADDING + cellCount * (2 * CELL_PADDING + self.cellWidth);
    [self setFrame: oldFrame];
    [self setNeedsDisplay: YES];
}

- (void) setCellWidth: (CGFloat) newCellWidth
{
    if (cellWidth != newCellWidth) {
        cellWidth = newCellWidth;
        [self recalculateFrame];
    }
}

- (void) setGameCount: (NSUInteger) newGameCount
{
    if (gameCount != newGameCount) {
        gameCount = newGameCount;
        [self recalculateFrame];
    }
}

- (NSRange) cellsInRect: (NSRect) aRect
{
    CGFloat     width = self.cellWidth + 2 * CELL_PADDING;
    NSRange     retval;
    retval.location = floor(aRect.origin.x / width);
    retval.length = ceil(aRect.size.width / width);
    return retval;
}

- (void) drawRect: (NSRect) dirtyRect
{
    CGFloat     maxBarHeight = self.bounds.size.height - 2 * GRAPH_PADDING;
    NSRect      backgroundRect = self.bounds;
    [[NSColor lightGrayColor] setFill];
    [NSBezierPath fillRect: backgroundRect];
    
    backgroundRect = NSInsetRect(backgroundRect, GRAPH_PADDING, GRAPH_PADDING);
    [[NSColor whiteColor] setFill];
    [NSBezierPath fillRect: backgroundRect];
    
    CGFloat     pixPerAttempt = maxBarHeight / MAX_ATTEMPTS;
    for (NSUInteger index = 0; index < self.gameCount; index++) {
        Game *      game = [self.delegate passCompletion: self gameAtIndex: index];
        NSUInteger  stat;

        NSRect  barRect;
        barRect.origin.x = GRAPH_PADDING + index * (CELL_PADDING + self.cellWidth);
        barRect.origin.y = GRAPH_PADDING;
        barRect.size.width = self.cellWidth;
        stat = MIN(game.attempts.unsignedIntegerValue, MAX_ATTEMPTS);
        barRect.size.height = stat * pixPerAttempt;
        [self.attColor setFill];
        [NSBezierPath fillRect: barRect];
        
        stat = MIN(game.completions.unsignedIntegerValue, MAX_ATTEMPTS);
        barRect.size.height = stat * pixPerAttempt;
        [self.compColor setFill];
        [NSBezierPath fillRect: barRect];
    }
}

@end
