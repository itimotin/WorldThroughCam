//
//  AsyncURLConnection.m
//  
//  Created by Vladimir Boychentsov on 4/20/10.
//  Copyright www.injoit.com 2010. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void (^completeBlock) (NSData *data, NSString *url);
typedef void (^errorBlock) (NSError *error);
typedef void (^progressBlock) (float progress);
typedef void (^modifyRequestBlock) (NSMutableURLRequest *request);

@interface AsyncURLConnection : NSURLConnection {

@private
	NSMutableData *dataReceived;
	
	errorBlock _errorBlock;
    completeBlock _completeBlock;
    progressBlock _progressBlock;
    
    float				bytesReceived;
    float               progressValue;
	long long			expectedBytes;
}

@property (readonly, strong) NSString *stringURLRequest;
@property (readonly, getter = isPaused) BOOL pauseOperation;


+ (id)request:(NSString *)requestUrl 
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock;

+ (id)request:(NSString *)requestUrl
modifyRequest:(modifyRequestBlock)modifyRequestBlock
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock;

+ (id)request:(NSString *)requestUrl 
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
     progress:(progressBlock)progressBlock;

+ (id)request:(NSString *)requestUrl 
modifyRequest:(modifyRequestBlock)modifyRequestBlock
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
     progress:(progressBlock)progressBlock;




- (id)initWithRequest:(NSString *)requestUrl 
        modifyRequest:(modifyRequestBlock)modifyRequestBlock
        completeBlock:(completeBlock)completeBlock 
           errorBlock:(errorBlock)errorBlock
             progress:(progressBlock)progressBlock;

- (void) pause;
- (void) resume;


@end