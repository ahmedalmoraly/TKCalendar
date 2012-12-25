//
//  TKCalendar.h
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/23/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarGridView.h"
#import "TKEvent+Helper.h"
#import "TKCalendarHeaderView.h"

@interface TKCalendar : UIView

@property (nonatomic, strong) NSMutableArray *weekdays;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) TKCalendarGridView *gridView;
@property (nonatomic, strong) TKCalendarHeaderView *header;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) NSInteger numberOfRows;

@property (nonatomic, strong) NSArray *eventsDataSource;

-(id)initWithFrame:(CGRect)frame numberOfColumns:(NSInteger)columns numberOfRows:(NSInteger)rows;

-(void)addEventWithDate:(NSDate *)date title:(NSString *)title info:(NSString *)info duration:(NSInteger)durationInMinutes;

@end
