//
//  TKCalendar.m
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/23/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import "TKCalendar.h"
#import "TKCalendarConstants.h"

@interface TKCalendar ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray *weekdays;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) NSDate *currentDate;
@end

@implementation TKCalendar

-(id)initWithFrame:(CGRect)frame numberOfColumns:(NSInteger)columns numberOfRows:(NSInteger)rows
{
    self = [self initWithFrame:frame];
    
    self.numberOfRows = rows;
    self.numberOfColumns = columns;
    [self setup];
    
    return self;
}

-(NSDate *)currentDate
{
    if (!_currentDate)
    {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

-(void)addEventWithDate:(NSDate *)date title:(NSString *)title info:(NSString *)info duration:(NSInteger)durationInMinutes
{
    [self.gridView addEventWithDate:date title:title info:info duration:durationInMinutes];
}

-(void)setup
{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.backgroundColor = [UIColor whiteColor];
    self.contentMode = UIViewContentModeRedraw;
    
    CGRect gridFrame, headerFrame;
    
    headerFrame = CGRectMake(0, 0, self.frame.size.width, 40);
    gridFrame = CGRectMake(0, headerFrame.size.height, self.frame.size.width, self.frame.size.height - headerFrame.size.height);
    
    if ((self.numberOfColumns + 1) * MIN_CELL_WIDTH > self.frame.size.width || self.numberOfRows * MIN_CELL_HEIGTH > self.frame.size.height)
    {
        // alloc scroll
        self.scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scroll.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
      
        headerFrame.size.height = 40;
        gridFrame.origin.y = headerFrame.size.height;
        
        if ((self.numberOfColumns + 1) * MIN_CELL_WIDTH > self.frame.size.width)
        {
            headerFrame.size.width = (self.numberOfColumns + 1) * MIN_CELL_WIDTH;
            
            gridFrame.size.width = (self.numberOfColumns + 1) * MIN_CELL_WIDTH;
        }
        
        if (self.numberOfRows * MIN_CELL_HEIGTH > self.frame.size.height)
        {
            gridFrame.size.height = (self.numberOfRows + 1) * MIN_CELL_HEIGTH;
        }
        
        self.scroll.contentSize = CGSizeMake(gridFrame.size.width, gridFrame.size.height + headerFrame.size.height);
        self.scroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.scroll.bounces = YES;
        [self addSubview:self.scroll];
    }
    
    self.gridView = [[TKCalendarGridView alloc] initWithFrame:gridFrame];
    self.gridView.numberOfColumns = self.numberOfColumns;
    self.gridView.numberOfRows = self.numberOfRows;
    self.gridView.cellWidth = self.gridView.frame.size.width / (self.numberOfColumns + 1);
    self.gridView.cellHeight = self.gridView.frame.size.height / (self.numberOfRows + 1);
    self.scroll ? [self.scroll addSubview:self.gridView] : [self addSubview:self.gridView];
    
    self.header = [[TKCalendarHeaderView alloc] initWithFrame:headerFrame];
    self.header.backgroundColor = [UIColor grayColor];
    self.header.dateFormatter = self.dateFormatter;
    self.header.weekdays = self.weekdays;
    self.header.grid = self.gridView;
    self.header.displayDate = self.currentDate;
    self.scroll ? [self.scroll addSubview:self.header] : [self addSubview:self.header];
    
    [self.gridView addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.gridView])
    {
        if ([keyPath isEqualToString:@"frame"]) {
            self.scroll.contentSize = CGSizeMake(self.gridView.frame.size.width, self.gridView.frame.size.height + self.header.frame.size.height);
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


-(NSMutableArray *)weekdays
{
    if (!_weekdays) {
        NSDate *date = self.currentDate;
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:1];
        
        _weekdays = [[NSMutableArray alloc] init];
        
        for (register unsigned int i=0; i < 7; i++) {
            [_weekdays addObject:date];
            date = [CURRENT_CALENDAR dateByAddingComponents:components toDate:date options:0];
        }
    }
    return _weekdays;
}

-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
- (NSDate *)firstDayOfWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
	[components setDay:([components day] - ([components weekday] - CFCalendarGetFirstWeekday(currentCalendar)))];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)nextWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
	[components setDay:([components day] - ([components weekday] - CFCalendarGetFirstWeekday(currentCalendar) - 7))];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)previousWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
	[components setDay:([components day] - ([components weekday] - CFCalendarGetFirstWeekday(currentCalendar) + 7))];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [CURRENT_CALENDAR dateFromComponents:components];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        // go to next week
        self.header.displayDate = [self nextWeekFromDate:self.header.displayDate];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        self.header.displayDate = [self previousWeekFromDate:self.header.displayDate];
    }
    
    [self.header setNeedsDisplay];
}

@end
