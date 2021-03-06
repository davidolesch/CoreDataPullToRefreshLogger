//
//  DOViewController.m
//  CoreDataPullToRefreshLogger
//
//  Created by David Olesch on 11/6/13.
//  Copyright (c) 2013 David Olesch. All rights reserved.
//

#import "DOViewController.h"
#import "DOLogStore.h"

@interface DOViewController ()

@end

@implementation DOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView setDataSource:self];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Log"];
    [refresh addTarget:self
                action:@selector(createLogNow)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DOLogStore sharedStore] numberOfLogs];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LogCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogCell"];
    }
    
    DOLog *log = [[DOLogStore sharedStore] logAtIndexPath:indexPath];
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:log.date];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",date]];
    
    [cell setBackgroundColor:[UIColor colorWithRed:log.red green:log.green blue:log.blue alpha:1.0]];
    
    return cell;
}

- (void)createLogNow
{
    [[DOLogStore sharedStore] createLog];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
