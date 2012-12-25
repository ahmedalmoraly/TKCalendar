//
//  TKViewController.m
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/21/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import "TKViewController.h"

#import "TKCalendar.h"

@interface TKViewController ()

@end

@implementation TKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect frame = CGRectMake(0, 0, 200, 300);
    frame.origin = self.view.center;
    TKCalendar *calendar = [[TKCalendar alloc] initWithFrame:self.view.bounds numberOfColumns:7 numberOfRows:24];
    [self.view addSubview:calendar];
    
    [calendar addEventWithDate:[NSDate date] title:@"TK Meating" info:nil duration:30];
    [calendar addEventWithDate:[(NSDate *)[NSDate date] dateByAddingTimeInterval:7200] title:@"Biology Class" info:nil duration:130];
    [calendar addEventWithDate:[(NSDate *)[NSDate date] dateByAddingTimeInterval:7200*3] title:@"Math Class" info:nil duration:730];
    
//    calendar.eventsDataSource = @[
//    [(NSDate *)[NSDate date] dateByAddingTimeInterval:-7200],
//    [(NSDate *)[NSDate date] dateByAddingTimeInterval:14400],
//    [(NSDate *)[NSDate date] dateByAddingTimeInterval:-14400],
//    [(NSDate *)[NSDate date] dateByAddingTimeInterval:7200],
//    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
