//
//  TemperatureTableViewCell.h
//  Weather
//
//  Created by Shabarinath Pabba on 4/22/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherDetailsObject;

@interface TemperatureTableViewCell : UITableViewCell

-(void)populateCellWithDetailsObject:(WeatherDetailsObject *)detailsObject;

@end
