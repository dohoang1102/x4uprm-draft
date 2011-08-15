//
//  LeagueDocument.h
//  Mac Passer Rating
//
//  Created by Xcode User on 8/1/11.
//  Copyright 2011 Fritz Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LeagueDocument : NSPersistentDocument
<NSTabViewDelegate>
{
    NSArrayController *teamArrayController;
    NSArrayController *passerArrayController;
    NSArrayController *gameArrayController;
    NSTableView *gameTable;
    NSTableView *passerTable;
}



- (IBAction) fillWithData: (id) sender;
@property (strong) IBOutlet NSArrayController *teamArrayController;
@property (strong) IBOutlet NSArrayController *passerArrayController;
@property (strong) IBOutlet NSArrayController *gameArrayController;
@property (strong) IBOutlet NSTableView *gameTable;
@property (strong) IBOutlet NSTableView *passerTable;

- (IBAction) gameTableClicked: (id) sender;
- (IBAction)passerTableClicked:(id)sender;
@end
