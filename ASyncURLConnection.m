//
//  AsyncURLConnection.m
//  
//  Created by Vladimir Boychentsov on 4/20/10.
//  Copyright www.injoit.com 2010. All rights reserved.
//



#import "AsyncURLConnection.h"

@implementation AsyncURLConnection

@synthesize stringURLRequest = _stringURLRequest;
@synthesize pauseOperation = _pauseOperation;

- (id)initWithResume:(AsyncURLConnection*)r{
    self = r;
    return self;
}
+ (id)request:(NSString *)requestUrl 
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock {
    
	return [[self alloc] initWithRequest:requestUrl
                            modifyRequest:^(NSMutableURLRequest *r) {}
                            completeBlock:completeBlock 
                               errorBlock:errorBlock
                                 progress:^(float progress) {}] ;
}

+ (id)request:(NSString *)requestUrl 
modifyRequest:(modifyRequestBlock)modifyRequestBlock
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock {
    
	return [[self alloc] initWithRequest:requestUrl
                            modifyRequest:modifyRequestBlock
                            completeBlock:completeBlock 
                               errorBlock:errorBlock
                                 progress:^(float progress) {}];
}

+ (id)request:(NSString *)requestUrl 
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
     progress:(progressBlock)progressBlock {
    
	return [[self alloc] initWithRequest:requestUrl
                            modifyRequest:^(NSMutableURLRequest *r) {}
                            completeBlock:completeBlock 
                               errorBlock:errorBlock
                                 progress:progressBlock];
}

+ (id)request:(NSString *)requestUrl 
modifyRequest:(modifyRequestBlock)modifyRequestBlock
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
     progress:(progressBlock)progressBlock {
    
	return [[self alloc] initWithRequest:requestUrl
                            modifyRequest:modifyRequestBlock
                            completeBlock:completeBlock 
                               errorBlock:errorBlock
                            progress:progressBlock];
}

- (id)initWithRequest:(NSString *)requestUrl 
        modifyRequest:(modifyRequestBlock)modifyRequestBlock
        completeBlock:(completeBlock)completeBlock 
           errorBlock:(errorBlock)errorBlock 
             progress:(progressBlock)progressBlock {
    
    _stringURLRequest = [[NSString stringWithString:requestUrl] copy];
    
	NSURL *url = [NSURL URLWithString:requestUrl];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    modifyRequestBlock(request);
    
	if ((self = [super initWithRequest:request delegate:self startImmediately:NO])) {
		dataReceived = [[NSMutableData alloc] init];
        _pauseOperation = NO;
		_completeBlock = [completeBlock copy];
		_errorBlock = [errorBlock copy];
        _progressBlock = [progressBlock copy];
        
        bytesReceived = progressValue = 0;
        
        [self start];
        
	}

	return self;
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
	NSHTTPURLResponse *r = (NSHTTPURLResponse*)response;
	NSDictionary *headers = [r allHeaderFields];
	if (headers){
		if ([headers objectForKey: @"Content-Range"]) {
			NSString *contentRange = [headers objectForKey: @"Content-Range"];
			NSRange range = [contentRange rangeOfString: @"/"];
			NSString *totalBytesCount = [contentRange substringFromIndex: range.location + 1];
			expectedBytes = [totalBytesCount floatValue];
		} else if ([headers objectForKey: @"Content-Length"]) {
			expectedBytes = [[headers objectForKey: @"Content-Length"] floatValue];
		} else expectedBytes = -1;
        
		if ([@"Identity" isEqualToString: [headers objectForKey: @"Transfer-Encoding"]]) {
			expectedBytes = bytesReceived;
		}
	}
    [dataReceived setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (!_pauseOperation) {
        [dataReceived appendData:data];
        
        float receivedLen = [data length];
        bytesReceived = (bytesReceived + receivedLen);    
        if(expectedBytes != NSURLResponseUnknownLength) {
            progressValue = ((bytesReceived/(float)expectedBytes)*100.0)/100.0;
            _progressBlock(progressValue);
        }
    } else {
        [self cancel];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	_completeBlock(dataReceived, _stringURLRequest);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	_errorBlock(error);
}


- (void) pause {
	_pauseOperation = YES;
}

- (void) resume {
	_pauseOperation = NO;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.stringURLRequest]];    
	[request addValue: [NSString stringWithFormat: @"bytes=%.0f-", bytesReceived ] forHTTPHeaderField: @"Range"];	
    id obj;
    obj = [self initWithResume:(AsyncURLConnection*)[AsyncURLConnection connectionWithRequest:request delegate:self]];
    obj = nil;
	
}
/*
- (void) dealloc {
    
    [dataReceived release];
    
    [_stringURLRequest release];
    
    [_progressBlock release];
	[_completeBlock release];
	[_errorBlock release];
    
	[super dealloc];
}
*/

@end