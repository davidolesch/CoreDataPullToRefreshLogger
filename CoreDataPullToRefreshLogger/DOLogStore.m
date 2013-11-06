//
//  DOLogStore.m
//  CoreDataPullToRefreshLogger
//
//  Created by David Olesch on 11/6/13.
//  Copyright (c) 2013 David Olesch. All rights reserved.
//

#import "DOLogStore.h"

@implementation DOLogStore

- (id)init
{
    self = [super init];
    
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSString *path = [self logArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open Failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
        
        [self loadAllLogs];
    }
    
    return self;
}

+ (DOLogStore *)sharedStore
{
    static DOLogStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

- (NSString *)logArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

#pragma mark loading and saving

- (void)loadAllLogs
{
    if (!allLogs) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *ed = [[model entitiesByName] objectForKey:@"DOLog"];
        [request setEntity:ed];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        allLogs = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (BOOL)saveChanges
{
    NSError *error = nil;
    BOOL successful = [context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@",[error localizedDescription]);
    }
    else {
        NSLog(@"Saving succeeded");
    }
    return successful;
}

#pragma mark logs

- (DOLog *)createLog
{
    DOLog *log = [NSEntityDescription insertNewObjectForEntityForName:@"DOLog" inManagedObjectContext:context];
    [allLogs insertObject:log atIndex:0];
    
    return log;
}

- (void)removeLog:(DOLog *)log
{
    [context deleteObject:log];
    [allLogs removeObjectIdenticalTo:log];
}

- (NSUInteger)numberOfLogs
{
    return allLogs.count;
}

- (DOLog *)logAtIndexPath:(NSIndexPath *)indexPath
{
    return [allLogs objectAtIndex:indexPath.row];
}

@end
