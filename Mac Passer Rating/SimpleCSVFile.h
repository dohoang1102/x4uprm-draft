//
//  SimpleCSVFile.h
//  Passer Rating
//
//  Created by Xcode User on 4/22/10.
//  Copyright 2010 Frederic F. Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class	SimpleCSVFile;

extern NSString * const		WT9TErrorDomain;

enum _CSVErrors {
	errCSVBadFormatLine = -1,
	errEmptyCSVFile = -2
};

extern NSString * const		kCSVErrorLineKey;
extern NSString * const		kCSVExpectedFieldsKey;
extern NSString * const		kCSVActualFieldsKey;

@protocol SimpleCSVDelegate <NSObject>

- (BOOL) csvFile: (SimpleCSVFile *) file
	  readValues: (NSDictionary *) values
		   error: (NSError **) error;

@end

@interface SimpleCSVFile : NSObject {
}

- (id) initWithPath: (NSString *) aPath;
- (BOOL) run: (NSError **) error;

@property(nonatomic, copy)		NSString *              path;
@property(nonatomic, readonly, retain)	NSArray *		headers;
@property(nonatomic, assign)	id <SimpleCSVDelegate>  delegate;
@property(strong) NSManagedObjectContext *              moc;

@end
