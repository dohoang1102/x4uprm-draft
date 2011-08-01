//
//  Game.m
//  Passer Rating
//
//  Created by Xcode User on 6/20/11.
//  Copyright (c) 2011 Fritz Anderson. All rights reserved.
//

#import "Game.h"
#import "Passer.h"
#import "Team.h"
#import "rating.h"

static NSDateFormatter *	sShortDate = nil;

@implementation Game 

@dynamic whenPlayed;
@dynamic theirTeam;
@dynamic theirScore;
@dynamic touchdowns;
@dynamic completions;
@dynamic ourTeam;
@dynamic ourScore;
@dynamic yards;
@dynamic attempts;
@dynamic interceptions;
@dynamic passer, team;

+ (void) initialize
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sShortDate = [[NSDateFormatter alloc] init];
		sShortDate.dateStyle = NSDateFormatterShortStyle;

    });
}

+ (BOOL) csvFile: (SimpleCSVFile *) file
	  readValues: (NSDictionary *) values
		   error: (NSError **) error;
{
	static NSDateFormatter *	sDateFormat = nil;
    static dispatch_once_t      onceToken;
    dispatch_once(&onceToken, ^{
        sDateFormat = [[NSDateFormatter alloc] init];
		sDateFormat.dateFormat = @"yyyy-MM-dd";	
    });
    
	Game *			retval;
	retval = [NSEntityDescription insertNewObjectForEntityForName: @"Game"
										   inManagedObjectContext: file.moc];
	
	NSString *		firstName = [values objectForKey: @"firstName"];
	NSString *		lastName = [values objectForKey: @"lastName"];
	Passer *		passer = [Passer passerWithLastName: lastName
                                        firstName: firstName
                                        inContext: file.moc];
	NSAssert3(passer, @"%s Can't create passer %@, %@",
			  __PRETTY_FUNCTION__, firstName, lastName);
	
	retval.passer = passer;
	passer.currentTeam = [values objectForKey: @"ourTeam"];
	
	for (NSString * key in [self numericAttributes]) {
		NSString *		datum = [values objectForKey: key];
		NSAssert2(datum, @"Could not get %@ from CSV %@", key, values);
		[retval setValue: [NSNumber numberWithInt: datum.intValue]
				  forKey: key];
	}
	retval.ourTeam = [values objectForKey: @"ourTeam"];
	retval.theirTeam = [values objectForKey: @"theirTeam"];
	retval.whenPlayed = [sDateFormat dateFromString:
						 [values objectForKey: @"whenPlayed"]];
    retval.team = [Team teamWithName: retval.ourTeam
                           inContext: file.moc
                              create: YES];
	return YES;
}

+ (BOOL) loadFromCSVFile: (NSString *) path
             intoContext: (NSManagedObjectContext *) moc
                   error: (NSError **) error
{
	SimpleCSVFile *		csv = [[SimpleCSVFile alloc] initWithPath: path];
    csv.moc = moc;
	csv.delegate = (id<SimpleCSVDelegate>) self;
	//	Let the caller save the MOC.
	return [csv run: error];
}

+ (NSUInteger) countInContext: (NSManagedObjectContext *) moc
{
	NSFetchRequest *	request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName: @"Game"
                                 inManagedObjectContext: moc];
	NSUInteger			retval = [moc countForFetchRequest: request
                                               error: NULL];
	return retval;
}

- (NSNumber *) passerRating
{
	double	rating = passer_rating(self.attempts.intValue, 
                                   self.completions.intValue, 
                                   self.yards.intValue, 
                                   self.touchdowns.intValue, 
                                   self.interceptions.intValue);
	return [NSNumber numberWithDouble: rating];
}

#pragma mark -
#pragma mark Editing Support

+ (NSArray *) allAttributes
{
	static NSArray *			sAllAttributes = nil;
    static dispatch_once_t      onceToken;
    dispatch_once(&onceToken, ^{
        sAllAttributes = [[NSArray alloc] initWithObjects:
						  @"whenPlayed", @"theirTeam",  @"theirScore",
						  @"touchdowns", @"completions", @"ourTeam",
						  @"ourScore", @"yards", @"attempts",
						  @"interceptions", nil];
    });
	return sAllAttributes;
}

+ (NSArray *) numericAttributes
{
	static NSArray *			sNumericAttributes = nil;
    static dispatch_once_t      onceToken;
    dispatch_once(&onceToken, ^{
        sNumericAttributes = [[NSArray alloc] initWithObjects:
							  @"theirScore", @"touchdowns",
							  @"completions", @"ourScore",
							  @"yards", @"attempts",
							  @"interceptions", nil];
    });
	return sNumericAttributes;
}

+ (NSDictionary *) defaultDictionary
{
	static NSDictionary *		sDict = nil;
    static dispatch_once_t      onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *	temp = [NSMutableDictionary	dictionary];
		for (NSString * key in [self numericAttributes])
			[temp setObject: @"0" forKey: key];
		[temp setObject: @"Opponents" forKey: @"theirTeam"];
		[temp setObject: @"Our Team" forKey: @"ourTeam"];
		[temp setObject: [sShortDate stringFromDate: [NSDate date]]
				 forKey: @"whenPlayed"];
		sDict = [temp copy];
    });
	return sDict;
}

- (NSMutableDictionary *) mutableDictionaryRepresentation
{
	NSMutableDictionary *		retval = [NSMutableDictionary dictionary];
	for (NSString * key in [Game numericAttributes]) {
		int				value = [[self valueForKey: key] intValue];
		NSString *		str = [NSString stringWithFormat: @"%d", value];
		[retval setObject: str forKey: key];		
	}
	[retval setObject: self.theirTeam forKey: @"theirTeam"];
	[retval setObject: self.ourTeam forKey: @"ourTeam"];
	[retval setObject: [sShortDate stringFromDate: self.whenPlayed]
			   forKey: @"whenPlayed"];
	
	return retval;
}

- (void) setValuesFromDictionary: (NSDictionary *) aDict
{
	for (NSString * key in [Game numericAttributes]) {
		[self setValue: [NSNumber numberWithInt: [[aDict objectForKey: key] intValue]]
				forKey: key];
	}
	self.theirTeam = [aDict objectForKey: @"theirTeam"];
	self.ourTeam = [aDict objectForKey: @"ourTeam"];
	self.whenPlayed = [sShortDate dateFromString: [aDict objectForKey: @"whenPlayed"]];
}

@end
