//
//  NSString+JustSpaces.m
//  Weather
//
//  Created by Shabarinath Pabba on 4/22/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import "NSString+JustSpaces.h"

@implementation NSString (JustSpaces)

-(BOOL)isJustSpaces{
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:charSet];
    if ([trimmedString isEqualToString:@""]) {
        // it's empty or contains only white spaces
        return true;
    }
    
    return false;
    
}

@end
