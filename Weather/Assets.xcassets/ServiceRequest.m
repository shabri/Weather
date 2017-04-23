//
//  ServiceRequest.m
//  Weather
//
//  Created by Shabarinath Pabba on 4/22/17.
//  Copyright © 2017 shabri. All rights reserved.
//

#import "ServiceRequest.h"

@implementation ServiceRequest

-(void)getResponseForUrlString:(NSURL *)url success:(void (^)(id payload))completionBlock failure:(void (^)(NSError *error))failureBlock{
    
    if (url && url.scheme && url.host) {//check validity or url
        NSURLSession *urlSession = [NSURLSession sharedSession];
        NSURLSessionDataTask *urlDataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
              
                if (error) {
                    failureBlock(error);
                }else{
                    if (((NSHTTPURLResponse *)response).statusCode == 200) {
                        completionBlock(data);
                    }
                }
                
            });
            
        }];
        [urlDataTask resume];
    }else{
        //Not a valid url
        NSError *error = [NSError errorWithDomain:@"" code:10006 userInfo:@{ NSLocalizedDescriptionKey : @"Not a valid url"}];
        failureBlock(error);
    }
    
}

@end
