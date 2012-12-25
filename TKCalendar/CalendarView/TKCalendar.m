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
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation TKCalendar

-(id)initWithFrame:(CGRect)frame numberOfColumns:(NSInteger)columns numberOfRows:(NSInteger)rows
{
    self = [self initWithFrame:frame];
    
    self.numberOfRows = rows;
    self.numberOfColumns = columns;
    [self setup];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self addGestureRecognizer:swipe];
    return self;
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
    
    headerFrame = CGRectMake(10, 0, self.frame.size.width-20, 50);
    gridFrame = CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height - headerFrame.size.height);
    
    if ((self.numberOfColumns + 1) * MIN_CELL_WIDTH > self.bounds.size.width-20 || self.numberOfRows * MIN_CELL_HEIGTH > self.frame.size.height)
    {
        // alloc scroll
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, headerFrame.size.height + 5, self.bounds.size.width-20, self.bounds.size.height - headerFrame.size.height - 15)];
      
        gridFrame.origin.x = 0;
//        gridFrame.origin.y = headerFrame.size.height + 5;
        
//        if ((self.numberOfColumns + 1) * MIN_CELL_WIDTH > self.frame.size.width)
//        {
//            headerFrame.size.width = (self.numberOfColumns + 1) * MIN_CELL_WIDTH;
//            
//            gridFrame.size.width = (self.numberOfColumns + 1) * MIN_CELL_WIDTH;
//        }
        
        if (self.numberOfRows * MIN_CELL_HEIGTH > self.frame.size.height)
        {
            gridFrame.size.height = (self.numberOfRows + 1) * MIN_CELL_HEIGTH;
        }
        
        self.scroll.contentSize = gridFrame.size;//
        CGSizeMake(gridFrame.size.width, gridFrame.size.height);
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
    self.header.backgroundColor = [UIColor whiteColor];
    self.header.dateFormatter = self.dateFormatter;
    self.header.weekdays = self.weekdays;
    self.header.grid = self.gridView;
    self.header.displayDate = self.currentDate;
    //self.scroll ? [self.scroll addSubview:self.header] :
    [self addSubview:self.header];
    
    [self.gridView addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.gridView])
    {
        if ([keyPath isEqualToString:@"frame"]) {
            self.scroll.contentSize = self.gridView.frame.size;
        }
    }
}

-(void)setEventsDataSource:(NSArray *)eventsDataSource
{
    _eventsDataSource = eventsDataSource;
    self.gridView.events = [eventsDataSource mutableCopy];
    [self.gridView setNeedsDisplay];
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
        _weekdays = [self calculateWeekdaysForDate:self.currentDate];
    }
    return _weekdays;
}

-(NSMutableArray *)calculateWeekdaysForDate:(NSDate *)date
{
    NSDate *dateOrigin = [self firstDayOfWeekFromDate:date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (register unsigned int i=0; i < 7; i++) {
        [arr addObject:dateOrigin];
        dateOrigin = [CURRENT_CALENDAR dateByAddingComponents:components toDate:dateOrigin options:0];
    }
    return arr;
}

-(NSDate *)currentDate
{
    if (!_currentDate)
    {
        _currentDate = [NSDate date];
    }
    return _currentDate;
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
        self.currentDate = [self nextWeekFromDate:self.currentDate];
        _weekdays = [self calculateWeekdaysForDate:self.currentDate];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        self.currentDate= [self previousWeekFromDate:self.currentDate];
        _weekdays = [self calculateWeekdaysForDate:self.currentDate];
    }
    
    [self.header setNeedsDisplay];
}

@end
