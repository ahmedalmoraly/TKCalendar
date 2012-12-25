//
//  TKCalendarHeaderView.m
//  TKCalendar
//
//  Created by Ahmad al-Moraly on 12/23/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import "TKCalendarHeaderView.h"
#import "TKCalendarConstants.h"
#import "TKCalendarGridView.h"
#import "TKCalendar.h"

@interface TKCalendarHeaderView ()


@end

@implementation TKCalendarHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

-(void)setGrid:(TKCalendarGridView *)grid
{
    _grid = grid;
    
    [_grid addObserver:self forKeyPath:@"cellWidth" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"cellWidth"] && [object isEqual:self.grid]) {
        [self setNeedsDisplay];
    }
}

-(NSMutableArray *)weekdays
{
    return [(TKCalendar *)self.superview weekdays];
}
-(NSDate *)displayDate
{
    return [(TKCalendar *)self.superview currentDate];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // drawing Header
    register unsigned int i = 1;
    NSDateComponents *todayComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
    
    NSArray *weekdaySymbols =(self.grid.cellWidth <= MIN_CELL_WIDTH) ? [self.dateFormatter veryShortWeekdaySymbols] : [self.dateFormatter shortWeekdaySymbols];
    CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
    int d = CFCalendarGetFirstWeekday(currentCalendar) - 1;
    CFRelease(currentCalendar);
    
    NSDateComponents *currentYear = [CURRENT_CALENDAR components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self.displayDate];
    
    NSString *header = [NSString stringWithFormat:@"%@ %i", [self.dateFormatter monthSymbols][currentYear.month -1], currentYear.year];
#ifdef __IPHONE_6_0
    [header drawInRect:rect withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:0 alignment:NSTextAlignmentCenter];
#else
    [header drawInRect:rect withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:0 alignment:UITextAlignmentCenter];
#endif
    
    for (NSDate *date in self.weekdays)
    {
        NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
        NSString *displayText = [NSString stringWithFormat:@"%@ %i", [weekdaySymbols objectAtIndex:d], [components day]];
        
        CGSize sizeNecessary = [displayText sizeWithFont:[UIFont systemFontOfSize:12]];
        CGRect rect = CGRectMake(self.grid.cellWidth * i + ((self.grid.cellWidth - sizeNecessary.width) / 2.f),
                                 CGRectGetMaxY(self.bounds) - sizeNecessary.height,
                                 sizeNecessary.width,
                                 sizeNecessary.height);
        
        if ([todayComponents day] == [components day] &&
            [todayComponents month] == [components month] &&
            [todayComponents year] == [components year])
        {
            [[UIColor greenColor] set];
        }
        else if ([components weekday] == 1)
        {
            [[UIColor redColor] set];
        }
        else
        {
            [[UIColor blueColor] set];
        }
        
        [displayText drawInRect: rect
                       withFont:[UIFont systemFontOfSize:12]];
        
        d = (d+1) % 7;
        i++;
    }
    
}


@end
