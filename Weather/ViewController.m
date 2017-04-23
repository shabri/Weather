//
//  ViewController.m
//  Weather
//
//  Created by Shabarinath Pabba on 3/29/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import "ViewController.h"
#import "WeatherServiceRequest.h"
#import "WeatherDetailsObject.h"
#import "TemperatureTableViewCell.h"
#import "NSString+JustSpaces.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *contentsTableView;
@property (nonatomic, strong) WeatherDetailsObject *weatherObject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"The weather";
    self.contentsTableView.separatorColor = [UIColor clearColor];
    self.contentsTableView.estimatedRowHeight = 44.0;
    
    self.weatherObject = [self loadCustomObjectWithKey:@"lastLoadedWeatherObject"];
    if (self.weatherObject) {
        [self.contentsTableView reloadData];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark class methods
-(void)searchWeatherForCity:(NSString *)city{
    
    if ([city isJustSpaces]) {
        [self showNotValidCityError];
        return;
    }
    //Its not an empty city string
    WeatherServiceRequest *request = [WeatherServiceRequest sharedInstance];
    [request requestWeatherForCity:city success:^(id payload) {
        
        self.weatherObject = (WeatherDetailsObject *)payload;
        [self saveCustomObject:self.weatherObject key:@"lastLoadedWeatherObject"];
    
        [self.contentsTableView reloadData];
        
    } failure:^(NSError *error) {
        
        if (error.code == 10005 || error.code == 10006) {
            [self showAlertWithMessage:error.description];
        }else{
            NSString *errorMessage = @"Your search did not return any results, try looking for a different city or type another city or your connection might be down";
            [self showAlertWithMessage:errorMessage];
        }
        
    }];
    
}

-(void)showAlertWithMessage:(NSString *)errorMessage{
    
    //Show an alert message for when the search was successful but nothing was shown
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:okAction];
    
    [self.navigationController presentViewController:ac animated:YES completion:nil];
    
}

-(void)showNotValidCityError{
    //Show an alert message for when its just empty spaces
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"C'mon thats not even a city its only empty spaces try a better city :D" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:okAction];
    
    [self.navigationController presentViewController:ac animated:YES completion:nil];
}

- (void)showInternetNotconnected{
    
    //Show an alert message for when the internet is out
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"You currently do not seem to be connected to internet or LAN" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:okAction];
    
    [self.navigationController presentViewController:ac animated:YES completion:nil];
    
}

- (void)saveCustomObject:(WeatherDetailsObject *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (WeatherDetailsObject *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    WeatherDetailsObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

#pragma mark UITableView DataSource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.weatherObject) {
        return 2;//Returns one section that shows the current temperature in big font and the other section to show other details that we may decide
    }
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;// This row will have the temperatue
    }else{
        //This section will show humidity sunrise and sunset
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TemperatureCellIdentifier = @"TemperatureCell";
    static NSString *OtherDescriptionCellIdentifier = @"DescriptionCell";
    
    if (indexPath.section == 0) {
        
        TemperatureTableViewCell *cell = [tableView
                                          dequeueReusableCellWithIdentifier:TemperatureCellIdentifier];
        if (cell == nil) {
            cell = [[TemperatureTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:TemperatureCellIdentifier];
        }
        
        [cell populateCellWithDetailsObject:self.weatherObject];
        
        return cell;
        
    }else{
        
        //Section 1 because there are only 2 sections this will show cells with humidity sunrise and sunset
        
        UITableViewCell *cell = [tableView
                                          dequeueReusableCellWithIdentifier:OtherDescriptionCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:OtherDescriptionCellIdentifier];
        }
        
        if (indexPath.row == 0) {
            //Show humidity
            cell.textLabel.text = [NSString stringWithFormat:@"Humidity: %i%%", self.weatherObject.humidity];
        }else if (indexPath.row == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"Sunrise: %@", self.weatherObject.sunrise];
        }else{
            //The only row left, we will show the sunset
            cell.textLabel.text = [NSString stringWithFormat:@"Sunset: %@", self.weatherObject.sunset];
        }
        
        return cell;
        
    }
    
}

#pragma mark UISearchBar delegates
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self searchWeatherForCity:searchBar.text];
}

@end
