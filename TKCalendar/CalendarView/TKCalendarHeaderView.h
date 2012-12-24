//
//  TKCalendarHeaderView.h
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/23/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKCalendarGridView;

@interface TKCalendarHeaderView : UIView

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray *weekdays;
@property (nonatomic, strong) TKCalendarGridView *grid;


@property (nonatomic, strong) NSDate *displayDate;

@end
