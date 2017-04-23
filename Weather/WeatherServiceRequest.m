//
//  WeatherServiceRequest.m
//  Weather
//
//  Created by Shabarinath Pabba on 4/22/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import "WeatherServiceRequest.h"
#import "WeatherDetailsObject.h"
#import "ServiceRequest.h"

#define kWeatherURL @"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=546d2aa35992e39813e04797865fd20e"

@interface WeatherServiceRequest(){
}

@property(nonatomic, strong)ServiceRequest *frameWorkServiceRequest;

@end

@implementation WeatherServiceRequest

+ (instancetype)sharedInstance
{
    static WeatherServiceRequest *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WeatherServiceRequest alloc] init];
        sharedInstance.frameWorkServiceRequest = [[ServiceRequest alloc] init];
    });
    return sharedInstance;
}

-(void)requestWeatherForCity:(NSString *)cityString success:(void (^)(id payload))completionBlock failure:(void (^)(NSError *error))failureBlock{
    //Takes the NSString for city name and then makes it a non Space word and then uses AFNetworking to get back a payload and passes to the completion block from where it will be easy to catch the payload from
    
    NSString *nonSpaceCityString = [cityString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *urlString = [NSString stringWithFormat:kWeatherURL, nonSpaceCityString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.frameWorkServiceRequest getResponseForUrlString:url success:^(id payload) {
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:payload options:0 error:&error];
        NSLog(@"%@", json);
        
        if(error == nil){
            WeatherDetailsObject *weatherObject = [[WeatherDetailsObject alloc] initWithDictionary:json];
            completionBlock(weatherObject);
        }
        else{
            NSError *serializingError = [NSError errorWithDomain:@"" code:10005 userInfo:@{ NSLocalizedDescriptionKey : @"Failed serializing data"}];
            failureBlock(serializingError);
        }
        
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
    
}

@end
