//
//  TKEvent.h
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/23/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKEvent : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger durationInSeconds;
@property (nonatomic, assign) NSInteger durationInMinutes;
@property (nonatomic, assign) double durationInHours;

@property (nonatomic, getter = isAllDay) BOOL allDay;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *info;



@end
