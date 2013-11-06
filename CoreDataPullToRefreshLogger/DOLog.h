//
//  DOLog.h
//  CoreDataPullToRefreshLogger
//
//  Created by David Olesch on 11/6/13.
//  Copyright (c) 2013 David Olesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DOLog : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic) double red;
@property (nonatomic) double green;
@property (nonatomic) double blue;

@end
