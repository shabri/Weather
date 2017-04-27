//
//  WeatherDetailsObject.m
//  Weather
//
//  Created by Shabarinath Pabba on 4/22/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import "WeatherDetailsObject.h"

@implementation WeatherDetailsObject

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:[NSNumber numberWithInt: self.temperatureMax] forKey:@"temperatureMax"];
    [encoder encodeObject:[NSNumber numberWithInt:self.temperatureMin] forKey:@"temperatureMin"];
    [encoder encodeObject:[NSNumber numberWithInt:self.currentTemperature] forKey:@"currentTemperature"];
    [encoder encodeObject:[NSNumber numberWithInt:self.humidity] forKey:@"humidity"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.unixSunset] forKey:@"unixSunset"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.unixSunrise] forKey:@"unixSunrise"];
    [encoder encodeObject:self.sunset forKey:@"sunset"];
    [encoder encodeObject:self.sunrise forKey:@"sunrise"];
    [encoder encodeObject:self.iconURL forKey:@"iconURL"];
    [encoder encodeObject:self.cityName forKey:@"cityName"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.temperatureMax = [[decoder decodeObjectForKey:@"temperatureMax"] intValue];
        self.temperatureMin = [[decoder decodeObjectForKey:@"temperatureMin"] intValue];
        self.currentTemperature = [[decoder decodeObjectForKey:@"currentTemperature"] intValue];
        self.humidity = [[decoder decodeObjectForKey:@"humidity"] intValue];
        self.unixSunset = [[decoder decodeObjectForKey:@"unixSunset"] doubleValue];
        self.unixSunrise = [[decoder decodeObjectForKey:@"unixSunrise"] doubleValue];
        self.sunset = [decoder decodeObjectForKey:@"sunset"];
        self.sunrise = [decoder decodeObjectForKey:@"sunrise"];
        self.iconURL = [decoder decodeObjectForKey:@"iconURL"];
        self.cityName = [decoder decodeObjectForKey:@"cityName"];
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super init]) {
        NSArray *weatherArray = dict[@"weather"];//Because this returns an array of weathers for when you make a request for a forecast
        NSDictionary *todayWeather = [weatherArray objectAtIndex:0];//This will return the weather dictionary for today
        self.desc = todayWeather[@"description"];
        
        double maxTempK = [dict[@"main"][@"temp_max"] floatValue];
        self.temperatureMax = [self convertKelvinToFahrenheit:maxTempK];
        
        double minTempK = [dict[@"main"][@"temp_min"] floatValue];
        self.temperatureMin = [self convertKelvinToFahrenheit:minTempK];
        
        double currentTemp = [dict[@"main"][@"temp"] floatValue];
        self.currentTemperature = [self convertKelvinToFahrenheit:currentTemp];
        
        self.humidity = [dict[@"main"][@"humidity"] intValue];
        
        self.unixSunset = [dict[@"sys"][@"sunset"] doubleValue];
        self.unixSunrise = [dict[@"sys"][@"sunrise"] doubleValue];
        
        self.sunset = [self convertUnixToStringDateFrom:self.unixSunset];
        self.sunrise = [self convertUnixToStringDateFrom:self.unixSunrise];
        
        self.iconURL = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", todayWeather[@"icon"]];
        
        self.cityName = dict[@"name"];
    }
    
    return self;
}

-(int)convertKelvinToFahrenheit:(double) temp{
    
    double tempF = (temp *(9.0/5.0)) - 459.67;
    return (int)tempF;
    
}

-(NSString *)convertUnixToStringDateFrom:(double)unixDate{
    NSTimeInterval _interval=unixDate;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
