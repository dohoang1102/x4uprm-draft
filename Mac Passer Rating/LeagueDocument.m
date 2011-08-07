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

@implementation LeagueDocument
@synthesize teamArrayController;

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
    //  TODO: Do I have to refresh? I probably do, unless the object controllers watch the MOC.
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

@end
