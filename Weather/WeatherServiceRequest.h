//
//  WeatherServiceRequest.h
//  Weather
//
//  Created by Shabarinath Pabba on 4/22/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherServiceRequest : NSObject

+ (instancetype)sharedInstance;// Single ton for Weather Service Request

-(void)requestWeatherForCity:(NSString *)cityString success:(void (^)(id payload))completionBlock failure:(void (^)(NSError *error))failureBlock;

@end
