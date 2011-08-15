//
//  LeagueDocument.m
//  Mac Passer Rating
//
//  Created by Xcode User on 8/1/11.
//  Copyright 2011 Fritz Anderson. All rights reserved.
//

#import "LeagueDocument.h"
#import "rating.h"
#import "Game.h"
#import "GameViewController.h"

@interface LeagueDocument ()
@property(strong) NSPopover *   gamePopover;
@end

@implementation LeagueDocument
@synthesize teamArrayController;
@synthesize passerArrayController;
@synthesize gameArrayController;
@synthesize gameTable;
@synthesize gamePopover;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, return nil.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"LeagueDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    self.teamArrayController.sortDescriptors =
        [NSArray arrayWithObject:
             [NSSortDescriptor sortDescriptorWithKey: @"teamName"
                                           ascending: YES]];
#if 0
    self.passerArrayController.sortDescriptors =
        [NSArray arrayWithObjects:
             [NSSortDescriptor sortDescriptorWithKey: @"lastName" 
                                           ascending: YES],
             [NSSortDescriptor sortDescriptorWithKey: @"firstName" 
                                           ascending: YES],
             nil];
#endif
    
    self.gameArrayController.sortDescriptors =
        [NSArray arrayWithObject:
             [NSSortDescriptor sortDescriptorWithKey: @"whenPlayed" 
                                           ascending: YES]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

#pragma mark - IBAction

- (IBAction) fillWithData: (id) sender
{
    NSString *  dataPath = [[NSBundle mainBundle] pathForResource: @"sample-data"
                                                           ofType: @"csv"];
    [Game loadFromCSVFile: dataPath
              intoContext: self.managedObjectContext
                    error: NULL];
}

- (IBAction) changeName: (id) sender
{
    id          selection = [self.teamArrayController selection];
    NSString *  oldName = [selection valueForKey: @"teamName"];
    if (oldName != NSNoSelectionMarker) {
        NSString *      newName = [oldName stringByAppendingString: @" CHANGED"];
        [selection setValue: newName forKey: @"teamName"];
    }
}

#pragma mark - NSTableViewDelegate

- (void) showPopoverForRow: (NSInteger) aRow
{
    if (aRow < 0)
        return;
    
    [self.gamePopover performClose: nil];
    GameViewController *    gvc = [[GameViewController alloc] initWithNibName: nil
                                                                       bundle: nil];
    id      aGame = [self.gameArrayController.arrangedObjects objectAtIndex: aRow];
    gvc.representedObject = aGame;
    self.gamePopover = [[NSPopover alloc] init];
    self.gamePopover.contentViewController = gvc;
    self.gamePopover.behavior = NSPopoverBehaviorTransient;
    NSRect                  rowRect = [self.gameTable rectOfRow: aRow];
    [self.gamePopover showRelativeToRect: rowRect ofView: self.gameTable preferredEdge: NSMaxXEdge];
}

- (IBAction) gameTableClicked: (id) sender
{
    [self showPopoverForRow: self.gameTable.clickedRow];
}
@end
