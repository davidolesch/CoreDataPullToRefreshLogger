//
//  DOLog.m
//  CoreDataPullToRefreshLogger
//
//  Created by David Olesch on 11/6/13.
//  Copyright (c) 2013 David Olesch. All rights reserved.
//

#import "DOLog.h"


@implementation DOLog

@dynamic date;
@dynamic red;
@dynamic green;
@dynamic blue;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    //save creation date
    NSTimeInterval t = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setDate:t];
    
    //choose colors
    [self setRed:drand48()];
    [self setGreen:drand48()];
    [self setBlue:drand48()];
}

@end
