//
//  TKCalendarGridView.m
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/21/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import "TKCalendarGridView.h"
#import "TKCalendarConstants.h"
#import "TKCalendarHeaderView.h"
#import "TKEventView.h"

@interface TKCalendarGridView ()


-(void)reloadDate;
@end

@implementation TKCalendarGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeRedraw;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
	CGContextSetStrokeColorWithColor(c, [UIColor lightGrayColor].CGColor);
	
    CGFloat width = rect.size.width / (self.numberOfColumns + 1);
    CGFloat height = rect.size.height / (self.numberOfRows + 1);
    self.cellWidth = width;
    self.cellHeight = height;
    
	CGContextBeginPath(c);
    {
		float x1 = CGRectGetMinX(rect);
		float y1 = CGRectGetMinY(rect);
        float x2 = CGRectGetMaxX(rect);
        float y2 = CGRectGetMaxY(rect);
        int i = 0;
//        x1 += 30;
        for (float dy = 0; dy <= y2 ; dy += self.cellHeight)
        {
            CGContextMoveToPoint(c, x1, y1+dy);
            CGContextAddLineToPoint(c, x2, y1+dy);
            
            NSString *hr = [NSString stringWithFormat:@"%i:00", i];
            [hr drawAtPoint:CGPointMake(x1+10, y1+dy) withFont:[UIFont systemFontOfSize:14]];
                i++;
        }
        CGContextMoveToPoint(c, x1, y2);
        CGContextAddLineToPoint(c, x2, y2);
        
        for (float dx = 0; dx <= x2 ; dx += self.cellWidth)
        {
            CGContextMoveToPoint(c, x1+dx, y1);
            CGContextAddLineToPoint(c, x1+dx, y2);
        }
	}
	
	CGContextSaveGState(c);
	CGContextDrawPath(c, kCGPathStroke);
	CGContextRestoreGState(c);
    [self reloadDate];
}

-(void)addEventWithDate:(NSDate *)date title:(NSString *)title info:(NSString *)info duration:(NSInteger)durationInMinutes
{
    TKEvent *event = [TKEvent eventWithStartDate:date duration:durationInMinutes];
    event.title = title;
    event.info = info;
    [self.events addObject:event];
}

-(void)reloadDate
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addEvent:obj];
    }];
}

-(void)addEvent:(TKEvent *)event
{
    // get offset
    NSDateComponents *comp = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.startDate];
    
    int day = comp.weekday;// day is the column number
    int hr = comp.hour; // hour is the row number
    CGRect frame = CGRectZero;
    frame.origin = CGPointMake(day * self.cellWidth, hr * self.cellHeight);
    frame.size = CGSizeMake(self.cellWidth, self.cellHeight * event.durationInHours);
    
    TKEventView *eventView = [[TKEventView alloc] initWithFrame:frame];
    eventView.event = event;
    eventView.backgroundColor = [UIColor redColor];
    [self addSubview:eventView];
}

-(NSMutableArray *)events
{
    if (!_events)
    {
        _events = [NSMutableArray array];
    }
    return _events;
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint tapPoint = [recognizer locationInView:recognizer.view];

    // check if this point is an event
    TKEventView *eventView = [self eventViewAtLocation:tapPoint];
    if (eventView) {
        TKEvent *event = [self eventForEventView:eventView];
        [[[UIAlertView alloc] initWithTitle:event.title message:[NSString stringWithFormat:@"%@",event.startDate] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    }
}

-(TKEventView *)eventViewAtLocation:(CGPoint)location
{
    __block TKEventView *event;
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[TKEventView class]]) {
            TKEventView *view = obj;
            BOOL found = CGRectContainsPoint(view.frame, location);
            if (found) {
                *stop = YES;
                event = view;
            }
        }
    }];
    
    return event;
}

-(TKEvent *)eventForEventView:(TKEventView *)eventView
{
    return eventView.event;
}

@end

