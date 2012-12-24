//
//  TKEvent+Helper.h
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/23/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import "TKEvent.h"

@interface TKEvent (Helper)

+(TKEvent *)eventWithStartDate:(NSDate *)start duration:(NSInteger)durationInMinutes;

@end
