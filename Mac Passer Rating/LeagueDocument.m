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
#import "PasserGraphController.h"

@interface LeagueDocument ()
@property(strong) NSPopover *   gamePopover;
@property(strong) NSPopover *   passerPopover;
@end

@implementation LeagueDocument
@synthesize teamArrayController;
@synthesize passerArrayController;
@synthesize gameArrayController;
@synthesize gameTable, passerTable;
@synthesize gamePopover, passerPopover;

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
    self.passerArrayController.sortDescriptors =
        [NSArray arrayWithObjects:
             [NSSortDescriptor sortDescriptorWithKey: @"lastName" 
                                           ascending: YES],
             [NSSortDescriptor sortDescriptorWithKey: @"firstName" 
                                           ascending: YES],
             nil];
    
    self.gameArrayController.sortDescriptors =
        [NSArray arrayWithObject:
             [NSSortDescriptor sortDescriptorWithKey: @"whenPlayed" 
                                           ascending: YES]];
    
    self.passerTable.doubleAction = @selector(passerTableClicked:);
    self.passerTable.target = self;
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

- (IBAction) gameTableClicked: (id) sender
{
    NSInteger       row = self.gameTable.clickedRow;
    if (row >= 0) {
        [self.gamePopover performClose: nil];
        [self.passerPopover performClose: nil];
        
        NSViewController *    gvc = 
                [[NSViewController alloc] initWithNibName: @"GameViewController" 
                                                   bundle: nil];
        id      aGame = [self.gameArrayController.arrangedObjects
                         objectAtIndex: row];
        
        gvc.representedObject = aGame;
        self.gamePopover = [[NSPopover alloc] init];
        self.gamePopover.contentViewController = gvc;
        self.gamePopover.behavior = NSPopoverBehaviorTransient;
        
        NSRect  rowRect = [self.gameTable rectOfRow: row];
        [self.gamePopover showRelativeToRect: rowRect 
                                      ofView: self.gameTable
                               preferredEdge: NSMaxXEdge];
    }
}

- (IBAction) passerTableClicked: (id) sender
{
    NSInteger       row = self.passerTable.clickedRow;
    if (row >= 0) {
        [self.gamePopover performClose: nil];
        [self.passerPopover performClose: nil];
        
        PasserGraphController *     pgc = [[PasserGraphController alloc] initWithNibName: @"PasserGraphController" bundle: nil];
        id      passer = [self.passerArrayController.arrangedObjects objectAtIndex: row];
        pgc.representedObject = passer;
        self.passerPopover = [[NSPopover alloc] init];
        self.passerPopover.contentViewController = pgc;
        self.passerPopover.behavior = NSPopoverBehaviorTransient;
        NSRect                  rowRect = [self.passerTable rectOfRow: row];
        [self.passerPopover showRelativeToRect: rowRect ofView: self.passerTable preferredEdge: NSMaxXEdge];
    }
}


@end
