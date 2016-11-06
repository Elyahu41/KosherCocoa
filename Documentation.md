KosherCocoa Documentation:
===

Table of Contents
---

1. [Introduction](https://github.com/MosheBerman/KosherCocoa/blob/master/Documentation.md#1-introduction)
2. [Sunrise, Sunset: Calculating Sunrise](https://github.com/MosheBerman/KosherCocoa/blob/master/Documentation.md#2-sunrise-sunset-calculating-sunrise)
3. [Zmanim](https://github.com/MosheBerman/KosherCocoa/blob/master/Documentation.md#3-zmanim)
4. [Parashat Hashavua](https://github.com/MosheBerman/KosherCocoa/blob/master/Documentation.md#4-parashat-hashavua)
5. [Chagim](https://github.com/MosheBerman/KosherCocoa/blob/master/Documentation.md#5-chagim)
6. [Sefira](https://github.com/MosheBerman/KosherCocoa/blob/master/Documentation.md#6-sefira)
7. [Daf Yomi](https://github.com/MosheBerman/KosherCocoa/blob/master/Documentation.md#7-daf-yomi)
8. [Conclusion](https://github.com/MosheBerman/KosherCocoa/blob/master/Documentation.md#8-conclusion)

--- 

1. Introduction
---

KosherCocoa is the product of over two years spent porting Eliyahu Hershfeld's wonderful KosherJava library to Objective-C. Much of this time has been spent maturing the library and making it feel like some of the Cocoa APIs. Eliyahu's own work has taken a significant amount of time and effort. 

This document attempts to be a complete reference for how to use Objective-C version. Please be mindful of the possibility that people will attempt to use whatever products you may build with this library to enhance their religious observance. If my own experience basing products on various iterations of this code has taught me one thing it is to be careful. 

With that in mind, let's get started.

2. Sunrise, Sunset: Calculating Sunrise
---
Sunrise and sunset are defined by where you are on Earth. For example, sunrise in California is long after sunrise in New York. While we use time zones to handle this when discussing time, we need to pinpoint where our user is in order to show them times that they can relate to. To do so, we use the `KCGeoLocation` class. The simplest use case is presented here:
 
    KCGeoLocation *location = [KCGeoLocation alloc] initWithLatitude:latitude andLongitude:longitude andTimeZone:timeZone];
    
---
**Note: When an initializer that doesn't expose altitude is called, the default altitude is 0.**

---
Now that we have a `KCGeoLocation` instance, we can pass it to the `KCAstronomicalCalendar` class to get sunrise and sunset times. 

    KCAstronomicalCalendar *calendar = [[KCAstronomicalCalendar alloc] initWithLocation:location];
    
Now we've got a calendar, we need to tell it which date we want to calculate for. The `KCAstronomicalCalendar` class has a `workingDate` property that defaults to `[NSDate date]`, but you can change it, like so.

    [calendar setWorkingDate:[NSDate date]];
    
Ok, we're ready to go. Let's get sunrise:
    
    NSDate *sunrise = [calendar sunrise];
    
This is sunrise at whatever the altitude of the `geoLocation` object has at a 90 degree zenith. That's it. Just four lines of code, three if you don't need to change the date:

    KCGeoLocation *location = [KCGeoLocation alloc] initWithLatitude:latitude andLongitude:longitude andTimeZone:timeZone];
    KCAstronomicalCalendar *calendar = [[KCAstronomicalCalendar alloc] initWithLocation:location];
    NSDate *sunrise = [calendar sunrise];
    
Sunrise, sunset. That's how it's done.

3. Zmanim
---
Zmanim are calculated by `KCZmanimCalendar` and its subclass `KCComplexZmanimCalendar`. Similar to sunrise, you can pass a location to a `KCZmanimCalendar` and then ask it for a zman.

    KCGeoLocation *location = [KCGeoLocation alloc] initWithLatitude:latitude andLongitude:longitude andTimeZone:timeZone];	
    KCZmanimCalendar *calendar = [[KCZmanimCalendar alloc] initWithLocation:geoLocation];
    NSDate *zofZmanShma = [calendar sofZmanShmaMogenAvraham];
    
That's it. There are over 100 different zmanim API. Have a look at the applicable headers.

4. Parashat Hashavua
---
There are two classes when working with Parshiot. `KCParashatHashavuaCalculator` returns a `KCParasha` object representing the parasha for a given date. For example:

    KCParashatHashavuaCalculator *parashaCalculator = [[KCParashatHashavuaCalculator alloc] init];
    KCParasha *parasha = [parashaCalculator parashaInDiasporaForDate:[NSDate date]];
    
Now we have the parasha for the supplied date. Whoo!

Parashat Hashavua follows one scheudule in Israel and different schedule everywhere else. This is because Jews in Israel don't celebrate the an extra day of sukkot or pesach. Depending on the year the parshiot diverge at different points in the calendar. To get the schedule in Israel, simply call `parashaInIsraelForDate:` instead of `parashaInDiasporaForDate:`.

	KCParasha *parasha = [parashaCalculator parashaInIsraelForDate:[NSDate date]];

Now that we have a `KCParasha`, we can use the `name` method to get the Hebrew name of parasha. We can also call `transliteratedName` to get the same Hebrew name spelled out in English.

	NSString *hebrewName = [parasha name];
	NSString *transliteratedName = [parasha nameTransliterated];

5. Chagim
---
To calculate the holidays, use `KCJewishCalendar`. Using the value of the `workingDate` property inherited from its superclass, `KCJewishCalendar` can determing if the supplied date is a holiday.  

Here's an example using `KCJewishCalendar`:

    KCJewishCalendar *calendar = [[KCJewishCalendar alloc] init];
    
    BOOL isPesach = [calendar isPesach];	// check for passover
    BOOL isHoliday = [calendar isYomTov];	// etc...

As alluded to in the Parashat Hashavua documentation, the holidays are observed for fewer days in Israel. If you want to check for holidays in Israel, change the `inIsrael` property to `YES`.

    [calendar setInIsrael:YES]; // default is NO
    
You can also choose to respect or ignore the various holidays involving the modern state of Israel, such as Yom Ha'atzmaut:

    [calendar setReturnsModernHolidays:YES] // default is NO, YES will enable the modern holidays
    
6. Sefira
---
Calculating Sefira is super easy with `KCSefiratHaomerCalculator`. It's a one liner:

    NSInteger dayOfSefira = [KCSefiratHaomerCalculator dayOfSefiraForDate:someDate];

The public methods of this class all have two flavors: ones that accept a date argument and ones that dont. The ones that don't take an argument will default to `[NSDate date]`, like so:

    NSInteger dayOfSefira = [KCSefiratHaomerCalculator dayOfSefira];
    
Both of these methods will return 0 if it's not during the sefira count, otherwise, will return an NSInteger representing tonights count.

---
**It's important to note that this class does not adjust for the Jewish day beginning at sundown the night before. Test your code before deployment.**

---

There is also a pair of methods that will tell you if a date falls during the omer count without telling you the day. Here's how that works:

	BOOL todayIsSefira = [KCSefiratHaomerCalculator fallsToday];
	BOOL someDayIsSefira = [KCSefiratHaomerCalculator fallsOnDate:someDate];
	
To get a string from the count, you use `KCSefiraFormatter`. First, get the day with `KCSefiratHaomerCalculator`, as we did above:

    NSInteger dayOfSefira = [KCSefiratHaomerCalculator dayOfSefira];
    
Then, you initialize the sefira formatter, and configure it with a custom and a language:
    
    KCSefiraFormatter *sefiraFormatter = [[KCSefiraFormatter alloc] init];
    sefiraFormatter.custom = KCSefiraCustomAshkenaz;
    sefiraFormatter.language = KCSefiraLanguageHebrew;
    
    
The `custom` property supports Ashkenaz, Sefard, and Sephardic customs as defined in the `KCSefiraCustom` enumerated type in `KCSefiraFormatter.h`. 

The `language` property supports Hebrew, English, and Transliterated Hebrew, as defined in the `KCSefiraLanguage` enumerated type in `KCSefiraFormatter.h`.

Now that we have a formatter set up, we have two options for getting the count. We can get just the count itself, like so:

    NSString *string = [sefiraFormatter countStringFromInteger:dayOfSefira];
    
Or, we can get a block of text which contains the count as well as medidations and prayers said before and after it, like so:

    KCSefiraPrayerAddition prayers = KCSefiraPrayerAdditionBeracha | KCSefiraPrayerAdditionHarachaman;
    NSString *string = [sefiraFormatter countStringFromInteger:dayOfSefira withPrayers:prayers];
    
This will return a string containing the blessing before the count, the count itself, and the harachaman right after it. Like the other related types, `KCSefiraPrayerAddition` is defined in `KCSefiraFormatter.h`

---
**As of this writing, there are a few limitations to the `KCSefiraFormatter` class. Transliterated Hebrew isn't implemented at all, and blessings are not supported when the language is set to English. In that case, you'll get just the count itself: "Today is the first day which is...".**

---





7. Daf Yomi
---
The Daf Yomi calculation classes work similarly to the Parasha calculation classes. You create a `KCDafYomiCalculator`, optionally assign a `workingDate`, and then ask it for a `KCDaf` for a given date. 
	
	KCDafYomiCalculator *calculator = [[KCDafYomiCalculator alloc] init];
	
	KCDaf *daf = [calculator dafYomiBavli];
	//	or, if we want to get a specific date
	daf = [calculator dafYomiBavliForDate:someDate];

To get the name of the daf, call the `name` method or the `transliteratedName` method:

	NSString *hebrewName = [daf name];
	NSString *transliteratedName = [daf nameTransliterated];
	
8. Conclusion
---
While there are couple of missing parts, this library is a mature piece of code. I've used bits and pieces of it in various apps for several years with close to no problems. 

Remember to provide your users with an adequate way to configuare a way for you to obtain their location. The primary cause of complaints in three years was nearly always a user who didn't know how to tell my apps where they were. 

If you've got any enhancements to offer, bugs to fix, or general contributions, feel free to contact me with a pull request or an email.

Moshe Berman, April 2014.