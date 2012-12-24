//
//  TKCalendarGridView.h
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/21/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKEvent+Helper.h"

@class TKCalendarHeaderView;
@interface TKCalendarGridView : UIView

@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) TKCalendarHeaderView *header;



-(void)addEventWithDate:(NSDate *)date title:(NSString *)title info:(NSString *)info duration:(NSInteger)durationInMinutes;

@end
