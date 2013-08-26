/** AstronomicalCalculator.m
 *  KosherCocoa 2
 *
 *  Created by Moshe Berman on 7/22/11.
 *  Modified by Moshe Berman on 8/25/13.
 *
 *  Use of KosherCocoa 2 is governed by the LGPL 2.1 License
 */

#import "AstronomicalCalculator.h"

/** An abstract class whose subclasses calculate sunrise and sunset.
 *
 */

@implementation AstronomicalCalculator

/**-----
 * @name Calculating Sunrise
 * -----
 */

/**
 *  A method that calculates UTC sunrise as well as any time based on an angle above or below sunrise. This abstract
 *  method is implemented by the classes that extend this class.
 *
 *  @param calendar Used to calculate day of year.
 *  @param geoLocation The location information used for astronomical calculating sun times.
 *  @param zenith the azimuth below the vertical zenith of 90 degrees. for sunrise typically the zenith used for
 *  the calculation uses geometric zenith of 90 degrees and adjusts this slightly to account for solar refraction 
 *  and the sun's radius. Another example would be beginNauticalTwilight that passes NAUTICAL_ZENITH to this method.
 *  @return The UTC time of sunrise in 24 hour format. 5:45:00 AM will return 5.75.0. If an error was encountered in 
 *  the calculation (expected behavior for some locations such as near the poles, NaN will be returned.
 *  @see #getElevationAdjustment(double)
 */

- (double) UTCSunriseForDate:(NSDate*)date andZenith:(double)zenith adjustForElevation:(BOOL)adjustForElevation{
    [super doesNotRecognizeSelector:_cmd];
    return 0;
}

/**-----
 * @name Calculating Sunset
 * -----
 */


/** 
 *  A method that calculates UTC sunrise as well as any time based on an angle above or below sunset. This abstract
 *  method is implemented by the classes that extend this class.
 *
 *  @param calendar Used to calculate day of year.
 *  @param geoLocation The location information used for astronomical calculating sun times.
 *  @param zenith the azimuth below the vertical zenith of 90 degrees. for sunrise typically the zenith used for
 *  the calculation uses geometric zenith of 90 degrees and adjusts this slightly to account for solar refraction
 *  and the sun's radius. Another example would be beginNauticalTwilight that passes NAUTICAL_ZENITH to this method.
 *  @return The UTC time of sunrise in 24 hour format. 5:45:00 AM will return 5.75.0. If an error was encountered in
 *  the calculation (expected behavior for some locations such as near the poles, NaN will be returned.
 *  @see #getElevationAdjustment(double)
 */

- (double) UTCSunsetForDate:(NSDate*)date andZenith:(double)zenith adjustForElevation:(BOOL)adjustForElevation{
    [super doesNotRecognizeSelector:_cmd];
    return 0;
}

@end

