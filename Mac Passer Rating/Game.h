//
//  Game.h
//  Passer Rating
//
//  Created by Xcode User on 6/20/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SimpleCSVFile.h"

@class Passer;
@class Team;

@interface Game : NSManagedObject
{
@private
}
@property (nonatomic, retain) NSDate * whenPlayed;
@property (nonatomic, retain) NSNumber * touchdowns;
@property (nonatomic, retain) NSNumber * theirScore;
@property (nonatomic, retain) NSNumber * completions;
@property (nonatomic, retain) NSNumber * attempts;
@property (nonatomic, retain) NSNumber * interceptions;
@property (nonatomic, retain) NSNumber * ourScore;
@property (nonatomic, retain) NSNumber * yards;
@property (nonatomic, retain) NSString * theirTeam;
@property (nonatomic, retain) Passer *passer;
@property(nonatomic, retain) Team *     team;

@property (nonatomic, readonly, retain) NSNumber *	passerRating;
@property (nonatomic, readonly) NSMutableDictionary * mutableDictionaryRepresentation;

+ (BOOL) loadFromCSVFile: (NSString *) path
             intoContext: (NSManagedObjectContext *) moc
                   error: (NSError **) error;
+ (NSUInteger) countInContext: (NSManagedObjectContext *) context;

+ (NSDictionary *) defaultDictionary;
+ (NSArray *) allAttributes;
+ (NSArray *) numericAttributes;
- (void) setValuesFromDictionary: (NSDictionary *) aDict;

@end
