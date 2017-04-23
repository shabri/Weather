//
//  TemperatureTableViewCell.m
//  Weather
//
//  Created by Shabarinath Pabba on 4/2/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import "TemperatureTableViewCell.h"
#import "WeatherDetailsObject.h"

@interface TemperatureTableViewCell(){
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *minTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTemperatureLabel;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@end

@implementation TemperatureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self shouldHideLabelsAndImage:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark
-(void)shouldHideLabelsAndImage:(BOOL)hide{
    self.temperatureLabel.hidden = hide;
    self.unitsLabel.hidden = hide;
    
    self.cityNameLabel.hidden = hide;
    
    self.minTemperatureLabel.hidden = hide;
    self.maxTemperatureLabel.hidden = hide;
    
    self.weatherImageView.hidden = hide;
}

-(void)populateCellWithDetailsObject:(WeatherDetailsObject *)detailsObject{
    
    [self shouldHideLabelsAndImage:NO];
    
    self.temperatureLabel.text = [NSString stringWithFormat:@"%i", detailsObject.currentTemperature];
    self.cityNameLabel.text = detailsObject.cityName;
    
    self.minTemperatureLabel.text = [NSString stringWithFormat:@"Min: %i˚F", detailsObject.temperatureMin];
    self.maxTemperatureLabel.text = [NSString stringWithFormat:@"Max: %i˚F", detailsObject.temperatureMax];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^(void) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:detailsObject.iconURL]];
                             
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.weatherImageView.image = image;
                [self setNeedsLayout];
            });
        }
    });
    
}

@end
