//
//  Passer.h
//  Passer Rating
//
//  Created by Xcode User on 6/20/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SimpleCSVFile.h"

@class Game;

@interface Passer : NSManagedObject
{
@private
}
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * currentTeam;
@property (nonatomic, retain) NSSet *games;

@property(nonatomic, readonly, retain) NSString *   fullName;
@property (nonatomic, readonly, retain) NSNumber *	passerRating;
@property (nonatomic, readonly, retain) NSNumber *	attempts;
@property (nonatomic, readonly, retain) NSNumber *	completions;
@property (nonatomic, readonly, retain) NSNumber *	touchdowns;
@property (nonatomic, readonly, retain) NSNumber *	interceptions;
@property (nonatomic, readonly, retain) NSNumber *	yardsPerGame;
@property (nonatomic, readonly, retain) NSNumber *	yards;
@property (nonatomic, readonly, retain) NSDate *	firstPlayed;
@property (nonatomic, readonly, retain) NSDate *	lastPlayed;
@property (nonatomic, readonly, retain) NSArray *	teams;

@property (nonatomic, readonly) NSMutableDictionary * mutableDictionaryRepresentation;

+ (Passer *) passerWithLastName: (NSString *) last firstName: (NSString *) first inContext: (NSManagedObjectContext *) moc;

+ (NSArray *) passersSortedBy: (NSArray *) descriptors
                    inContext: (NSManagedObjectContext *) moc;

+ (NSArray *) allAttributes;
+ (NSDictionary *) defaultDictionary;
- (void) setValuesFromDictionary: (NSDictionary *) aDict;

+ (BOOL) removePassersInCSVFile: (NSString *) path 
                     forContext: (NSManagedObjectContext *) moc
                          error: (NSError **) error;

@end

@interface Passer (CoreDataGeneratedAccessors)
- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet *)value;
- (void)removeGames:(NSSet *)value;

@end
