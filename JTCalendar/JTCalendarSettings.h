//
//  JTCalendarSettings.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JTCalendarWeekDayFormat) {
	JTCalendarWeekDayFormatNone,
    JTCalendarWeekDayFormatSingle,
    JTCalendarWeekDayFormatShort,
    JTCalendarWeekDayFormatFull
};

typedef NS_ENUM(NSInteger, JTCalendarDayShowMode)
{
	// Default not show
	JTCalendarDayShowModeNone = 0,
	JTCalendarDayShowModeDefault = 1 << 0,
};

@interface JTCalendarSettings : NSObject


// Content view

@property (nonatomic) BOOL pageViewHideWhenPossible;
@property (nonatomic) BOOL weekModeEnabled;


// Page view

// Must be less or equalt to 6, 0 for automatic
@property (nonatomic) NSUInteger pageViewNumberOfWeeks;
@property (nonatomic) BOOL pageViewHaveWeekDaysView;
@property (nonatomic) NSUInteger pageViewWeekModeNumberOfWeeks;

// WeekDay view

@property (nonatomic) JTCalendarWeekDayFormat weekDayFormat;
@property (assign, nonatomic) JTCalendarDayShowMode dayShowMode;

// Day view

@property (nonatomic) BOOL zeroPaddedDayFormat;

// Use for override
- (void)commonInit;

@end
