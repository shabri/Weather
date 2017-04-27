//
//  ServiceRequest.h
//  Weather
//
//  Created by Shabarinath Pabba on 4/22/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRequest : NSObject

-(void)getResponseForUrlString:(NSURL *)url success:(void (^)(id payload))completionBlock failure:(void (^)(NSError *error))failureBlock;

@end
