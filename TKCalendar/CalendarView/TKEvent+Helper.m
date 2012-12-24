//
//  TKEvent+Helper.m
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/23/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import "TKEvent+Helper.h"

@implementation TKEvent (Helper)

+(TKEvent *)eventWithStartDate:(NSDate *)start duration:(NSInteger)durationInMinutes
{
    TKEvent *event = [[TKEvent alloc] init];
    event.startDate = start;
    event.durationInMinutes = durationInMinutes;
    event.durationInSeconds = durationInMinutes * 60;
    event.durationInHours = durationInMinutes / 60.0;
    event.endDate = [start dateByAddingTimeInterval:event.durationInSeconds];
    
    return event;
}

@end
