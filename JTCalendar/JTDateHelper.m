//
//  JTDateHelper.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTDateHelper.h"

@interface JTDateHelper (){
    NSCalendar *_calendar;
}

@end

@implementation JTDateHelper

- (NSCalendar *)calendar
{
    if(!_calendar){
#ifdef __IPHONE_8_0
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
        _calendar.timeZone = [NSTimeZone localTimeZone];
        _calendar.locale = [NSLocale currentLocale];
    }
    
    return _calendar;
}

- (NSDateFormatter *)createDateFormatter
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.timeZone = self.calendar.timeZone;
    dateFormatter.locale = self.calendar.locale;
    
    return dateFormatter;
}

#pragma mark - Operations

- (NSDate *)addToDate:(NSDate *)date months:(NSInteger)months
{
    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)addToDate:(NSDate *)date weeks:(NSInteger)weeks
{
    NSDateComponents *components = [NSDateComponents new];
    components.day = 7 * weeks;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)addToDate:(NSDate *)date days:(NSInteger)days
{
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

#pragma mark - Helpers

- (NSUInteger)numberOfWeeks:(NSDate *)date
{
    NSDate *firstDay = [self firstDayOfMonth:date];
    NSDate *lastDay = [self lastDayOfMonth:date];
    
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:firstDay];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:lastDay];
    
    // weekOfYear may return 53 for the first week of the year
    return (componentsB.weekOfYear - componentsA.weekOfYear + 52 + 1) % 52;
}

- (NSDate *)firstDayOfMonth:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.day = 1;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

- (NSDate *)lastDayOfMonth:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month + 1;
    componentsNewDate.day = 0;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

- (NSDate *)firstWeekDayOfMonth:(NSDate *)date
{
    NSDate *firstDayOfMonth = [self firstDayOfMonth:date];
    return [self firstWeekDayOfWeek:firstDayOfMonth];
}

- (NSDate *)firstWeekDayOfWeek:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = componentsCurrentDate.weekOfMonth;
    componentsNewDate.weekday = self.calendar.firstWeekday;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

- (NSDate *)firstWeekDayOfWeekInSameMonth:(NSDate *)date
{
	NSDate *firstWeekDay = [self firstWeekDayOfWeek:date];
	
	BOOL isSameWeek = [self date:date isTheSameWeekThan:firstWeekDay];
	BOOL isSameMonth = [self date:date isTheSameMonthThan:firstWeekDay];
	
	if (!isSameMonth)
	{
		return firstWeekDay;
	}
	return firstWeekDay;
	
	
	
	BOOL isFirstWeekBefore = [self date:date isEqualOrAfter:firstWeekDay];
	
	NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
	BOOL firstWeekday = componentsCurrentDate.day < 8; // 第一个星期
	BOOL lastWeekday = componentsCurrentDate.day > 24; // 最后一个星期
	
	if (!isSameMonth && firstWeekDay)
	{
		return date;
	}
	else if (!isSameMonth && lastWeekday)
	{
		return firstWeekDay;
	}
	
	while (![self date:firstWeekDay isTheSameMonthThan:date] && [self date:firstWeekDay isEqualOrBefore:date])
	{
		firstWeekDay = [self addToDate:firstWeekDay days:1];
		if ([self date:firstWeekDay isEqualOrAfter:[self lastDayOfMonth:date]])
		{
			return date;
		}
	}
	return firstWeekDay;
}

#pragma mark - Comparaison

- (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];

    return componentsA.year == componentsB.year && componentsA.month == componentsB.month;
}

- (BOOL)date:(NSDate *)dateA isTheSameWeekThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.weekOfYear == componentsB.weekOfYear;
}

- (BOOL)date:(NSDate *)dateA isTheSameDayThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
}

- (BOOL)date:(NSDate *)dateA isEqualOrBefore:(NSDate *)dateB
{
    if([dateA compare:dateB] == NSOrderedAscending || [self date:dateA isTheSameDayThan:dateB]){
        return YES;
    }
    
    return NO;
}

- (BOOL)date:(NSDate *)dateA isEqualOrAfter:(NSDate *)dateB
{
    if([dateA compare:dateB] == NSOrderedDescending || [self date:dateA isTheSameDayThan:dateB]){
        return YES;
    }
    
    return NO;
}

- (BOOL)date:(NSDate *)date isEqualOrAfter:(NSDate *)startDate andEqualOrBefore:(NSDate *)endDate
{
    if([self date:date isEqualOrAfter:startDate] && [self date:date isEqualOrBefore:endDate]){
        return YES;
    }
    
    return NO;
}

@end

