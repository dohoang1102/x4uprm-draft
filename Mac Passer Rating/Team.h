//
//  Team.h
//  Mac Passer Rating
//
//  Created by Xcode User on 8/1/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Team : NSManagedObject

@property(nonatomic, retain) NSString *     name;
@property(nonatomic, retain) NSSet *        games;
@property(nonatomic, readonly) NSArray *    orderedGames;
@property(nonatomic, readonly) NSArray *    orderedPassers;

+ (Team *) teamWithName: (NSString *) aName 
              inContext: (NSManagedObjectContext *) moc
                 create: (BOOL) doCreate;

@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;

@end
