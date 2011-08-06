//
//  Passer.m
//  Passer Rating
//
//  Created by Xcode User on 6/20/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import "Passer.h"
#import "Game.h"
#import "rating.h"

#define TWO_LEVEL_FETCH     0
#define COMPOUND_FETCH      0
#define ALL_IN_MEMORY       0
#define NO_CORE_DATA        1

#define LEAK_PASSER_KEY     0

@implementation Passer
@dynamic firstName;
@dynamic lastName;
@dynamic currentTeam;
@dynamic games;

static NSMutableDictionary *   sAllPassers;

+ (void) initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sAllPassers = [[NSMutableDictionary alloc] init];
    });
}

+ (NSArray *) existingPassersWithLastName: (NSString *) last
								firstName: (NSString *) first
{
	NSParameterAssert(last && last.length > 0);
	NSParameterAssert(first && first.length > 0);
    
    NSString *      key = [NSString stringWithFormat: @"%@|%@", last, first];
    Passer *        passer = [sAllPassers objectForKey: key];
    NSArray *       result;
    if (passer)
        result = [NSArray arrayWithObject: passer];
    else
        result = [NSArray array];

	return result;
}

+ (Passer *) passerWithLastName: (NSString *) last 
                      firstName: (NSString *) first
                      inContext: (NSManagedObjectContext *) moc
{
	NSArray *			result = [self existingPassersWithLastName: last
                                                 firstName: first];
	if (result.count > 0)
		return result.lastObject;
	else {
		Passer *		retval;
		retval = [NSEntityDescription
				  insertNewObjectForEntityForName: @"Passer"
                  inManagedObjectContext: moc];
        assert(retval);
		retval.firstName = first;
		retval.lastName = last;
        
        NSString *      key = [NSString stringWithFormat: @"%@|%@", last, first];
        [sAllPassers setObject: retval forKey: key];
		
		return retval;
	}
}

+ (NSArray *) passersSortedBy: (NSArray *) descriptors
                    inContext: (NSManagedObjectContext *) moc
{
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	req.entity = [NSEntityDescription entityForName: @"Passer"
							 inManagedObjectContext: moc];
	NSError *		error;
	NSArray *		passers = [moc executeFetchRequest: req
                                             error: &error];
	if (! passers) {
		NSLog(@"%s: Error = %@", __PRETTY_FUNCTION__, error);
		NSLog(@"%s: userDict = %@", __PRETTY_FUNCTION__, [error userInfo]);
		return nil;
	}
    
    if (descriptors)
        return [passers sortedArrayUsingDescriptors: descriptors];
    else
        return passers;
}

- (NSString *) fullName
{
    return [NSString stringWithFormat: @"%@ %@",
            self.firstName, self.lastName];
}

- (NSNumber *) passerRating
{
	int	attempts = [[self.games valueForKeyPath: @"@sum.attempts"] intValue];
	int	comps = [[self.games valueForKeyPath: @"@sum.completions"] intValue];
	int	yards = [[self.games valueForKeyPath: @"@sum.yards"] intValue];
	int	tds = [[self.games valueForKeyPath: @"@sum.touchdowns"] intValue];
	int	ints = [[self.games valueForKeyPath: @"@sum.interceptions"] intValue];
	
	double rating = passer_rating(attempts, comps, yards, tds, ints);
	return [NSNumber numberWithDouble: rating];
}

- (NSDate *) firstPlayed
{
	return [self.games valueForKeyPath: @"@min.whenPlayed"];
}

- (NSDate *) lastPlayed
{
	return [self.games valueForKeyPath: @"@max.whenPlayed"];
}

- (NSNumber *) attempts
{
	return [self.games valueForKeyPath: @"@sum.attempts"];
}

- (NSNumber *) completions
{
	return [self.games valueForKeyPath: @"@sum.completions"];
}

- (NSNumber *) touchdowns
{
	return [self.games valueForKeyPath: @"@sum.touchdowns"];
}

- (NSNumber *) interceptions
{
	return [self.games valueForKeyPath: @"@sum.interceptions"];
}

- (NSNumber *) yards
{
	return [self.games valueForKeyPath: @"@sum.yards"];
}

- (NSNumber *) yardsPerGame
{
	int         yards = [[self.games valueForKeyPath: @"@sum.yards"] intValue];
	NSUInteger  games = self.games.count;
	return [NSNumber numberWithDouble: (double)yards / games];
}

- (NSArray *) teams
{
	return [[self.games valueForKeyPath: @"@distinctUnionOfObjects.ourTeam"] allObjects];
}

#pragma mark -
#pragma mark Editing Support

+ (NSArray *) allAttributes
{
	static NSArray *			sAllAttributes = nil;
    static dispatch_once_t      onceToken;
    dispatch_once(&onceToken, ^{
        sAllAttributes = [[NSArray alloc] initWithObjects:
						  @"firstName", @"lastName",  @"currentTeam", nil];
    });
	return sAllAttributes;
}

+ (NSDictionary *) defaultDictionary
{
	static NSDictionary *		sDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sDict = [[NSDictionary alloc] initWithObjectsAndKeys:
				 @"First Name", @"firstName",
				 @"Last Name", @"lastName",
				 @"Team Name", @"currentTeam",
				 nil];
    });
	return sDict;
}

- (NSMutableDictionary *) mutableDictionaryRepresentation
{
	NSMutableDictionary *	retval = [NSMutableDictionary dictionary];
	for (NSString * key in [Passer allAttributes]) {
		NSString *				value = [self valueForKey: key];
		[retval setObject: value forKey: key];		
	}
	
	return retval;
}

- (void) setValuesFromDictionary: (NSDictionary *) aDict
{
	for (NSString * key in [Passer allAttributes]) {
		[self setValue: [aDict valueForKey: key]
				forKey: key];
	}
}

#pragma mark -
#pragma mark Deleting Demo Passers

+ (BOOL) csvFile: (SimpleCSVFile *) file
	  readValues: (NSDictionary *) values
		   error: (NSError **) error
{
	NSArray *		passers = 
    [Passer existingPassersWithLastName: [values objectForKey: @"lastName"]
                              firstName: [values objectForKey: @"firstName"]];
	for (Passer * passer in passers) {
		if ([passer.currentTeam isEqualToString: [values objectForKey: @"ourTeam"]])
			[file.moc deleteObject: passer];
	}
    
	return YES;
}

+ (BOOL) removePassersInCSVFile: (NSString *) path
                     forContext: (NSManagedObjectContext *) moc
                          error: (NSError **) error
{
	SimpleCSVFile *	csv = [[SimpleCSVFile alloc] initWithPath: path];
    csv.moc = moc;
	csv.delegate = (id<SimpleCSVDelegate>) self;
	return [csv run: error];
}

@end
