//
//  Team.m
//  Mac Passer Rating
//
//  Created by Xcode User on 8/1/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import "Team.h"
#import "Game.h"

@interface Team ()
- (void) setPrimitiveTeamName: (NSString *) newTeamName;
@end

@implementation Team

@dynamic teamName;
@dynamic games;

+ (Team *) teamWithName: (NSString *) aName 
              inContext: (NSManagedObjectContext *) moc
                 create: (BOOL) doCreate
{
    NSFetchRequest *    fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName: @"Team"
                               inManagedObjectContext: moc];
    fetch.predicate = [NSPredicate predicateWithFormat: @"teamName = %@",
                       aName];
    NSError *           error;
    NSArray *           result;
    result = [moc executeFetchRequest: fetch error: &error];
    if (! result) {
        //  FIXME: This would be a candidate for localization,
        //  but it is never user-visible.
         NSLog(@"%s: Bad query for Team %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
        return nil;
    }
    
    if (result.count > 0)
        return [result lastObject];
    
    if (! doCreate)
        return nil;
    
    Team *              retval =
        [NSEntityDescription insertNewObjectForEntityForName: @"Team"
                                      inManagedObjectContext: moc];
    assert(retval);
    retval.teamName = aName;
    return retval;
}

- (void) setTeamName: (NSString *) teamName
{
    NSArray *       words = [teamName componentsSeparatedByString: @" "];
    NSString *      firstOfTeam = [[words lastObject] substringToIndex: 1];
    NSString *      firstOfCity = [teamName substringToIndex: 1];
    if (! [firstOfCity isEqualToString: firstOfTeam]) {
        NSAlert *   alert =
            [NSAlert alertWithMessageText: @"Illegal team name"
                            defaultButton: nil  //  Autolocalized
                          alternateButton: nil otherButton: nil
                informativeTextWithFormat: 
             @"\"%@\" must be the first letter of the team name, not \"%@\"",
             firstOfCity, firstOfTeam];
        alert.alertStyle = NSCriticalAlertStyle;
        [alert runModal];
        return;
    }
    
    [self willChangeValueForKey: @"teamName"];
    [self setPrimitiveTeamName: teamName];
    [self didChangeValueForKey: @"teamName"];
}

- (NSUInteger) ownTotalScore
{
    NSNumber *      total = [self.games valueForKeyPath: @"@sum.ourScore"];
    return total.unsignedIntegerValue;
}

- (NSUInteger) oppTotalScore
{
    NSNumber *      total = [self.games valueForKeyPath: @"@sum.theirScore"];
    return total.unsignedIntegerValue;
}

- (NSSet *) passers
{
    return [self.games valueForKeyPath: @"@distinctUnionOfObjects.passer"];
}

- (NSArray *) orderedPassers
{
    NSArray *               sortByDate = 
            [NSArray arrayWithObject:
                [NSSortDescriptor sortDescriptorWithKey: @"whenPlayed"
                                              ascending: YES]];
    NSArray *               orderedGames =
            [self.games sortedArrayUsingDescriptors: sortByDate];
    NSMutableOrderedSet *   set = [NSMutableOrderedSet orderedSet];
    
    for (Game * game in orderedGames) {
        [set addObject: game.passer];
    }
    
    return set.array;
}

@end
