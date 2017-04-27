//
//  WeatherDetailsObject.h
//  Weather
//
//  Created by Shabarinath Pabba on 4/22/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDetailsObject : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)dict;

/// a weather description:
/// light rain, heavy snow, etc...
@property (nonatomic, strong) NSString* desc;

/// min/max temp in Kelvin
@property (nonatomic) int temperatureMin;
@property (nonatomic) int temperatureMax;
@property (nonatomic) int currentTemperature;

/// current humidity level (perecent)
@property (nonatomic) int humidity;

//Time for sunset and sunrise
@property (nonatomic) double unixSunset;
@property (nonatomic) double unixSunrise;
@property (nonatomic, strong) NSString* sunset;
@property (nonatomic, strong) NSString* sunrise;

//icon url
@property (nonatomic, strong) NSString *iconURL;

@property (nonatomic, strong) NSString *cityName;

@end
