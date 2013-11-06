//
//  DOLogStore.h
//  CoreDataPullToRefreshLogger
//
//  Created by David Olesch on 11/6/13.
//  Copyright (c) 2013 David Olesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DOLog.h"

@interface DOLogStore : NSObject
{
    NSMutableArray *allLogs;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (DOLogStore *)sharedStore;

- (NSString *)logArchivePath;
- (DOLog *)createLog;
- (BOOL)saveChanges;
- (NSUInteger)numberOfLogs;
- (DOLog *)logAtIndexPath:(NSIndexPath *)indexPath;

@end
