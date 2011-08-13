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
}



- (IBAction) fillWithData: (id) sender;
@property (strong) IBOutlet NSArrayController *teamArrayController;
@property (strong) IBOutlet NSArrayController *passerArrayController;
@property (strong) IBOutlet NSArrayController *gameArrayController;
@property (strong) IBOutlet NSTableView *gameTable;

- (IBAction) gameTableClicked: (id) sender;
@end
