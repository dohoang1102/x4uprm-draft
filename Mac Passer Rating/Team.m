//
//  Team.m
//  Mac Passer Rating
//
//  Created by Xcode User on 8/1/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import "Team.h"
#import "Game.h"
#import "Passer.h"

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
         NSLog(@"%s: Bad query for Team %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
        return nil;
    }
    
    if (result.count > 0)
        return [result lastObject];
    
    if (! doCreate)
        return nil;
    
    Team *              retval =
        [NSEntityDescription insertNewObjectForEntityForName: @"Team"
                                      inManagedObjectContext:moc];
    assert(retval);
    retval.teamName = aName;
    return retval;
}

- (NSArray *) orderedGames
{
    NSSet *     set = self.games;
    NSArray *   descs = [NSArray arrayWithObject:
                         [NSSortDescriptor sortDescriptorWithKey: @"whenPlayed"
                                                       ascending: YES]];
    NSArray *   retval = [set sortedArrayUsingDescriptors: descs];
    return retval;
}

- (NSArray *) orderedPassers
{
    NSMutableOrderedSet *   set = [[NSMutableOrderedSet alloc] init];
    for (Game * game in self.orderedGames) {
        [set addObject: game.passer];
    }
    return set.array;
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

@end
