//
//  DecryptManager.m
//  Wallpapers
//
//  Created by Alejando M on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//#import "NSString+addons.h"
#import "NSData+Base64.h"
#import "DecryptManager.h"

static DecryptManager  *sharedMyManager = nil;
@implementation DecryptManager



+ (id)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}

- (NSString*)decryptData:(NSData*)stringData key:(NSString*)key{

    NSMutableString *result = [[NSMutableString alloc]init];

    NSString *tmp = [[NSString alloc]initWithData:stringData encoding:NSUTF8StringEncoding];

    NSData *decriptedData = [NSData dataFromBase64String:tmp];
    NSString *string = [[NSString alloc]initWithData:decriptedData encoding:NSASCIIStringEncoding];

    for(int i = 0; i<[string length]; i++){
        NSRange r = NSMakeRange(i, 1);
        char charr = (char)[[string substringWithRange:r] characterAtIndex:0];
        int nr = ((i%[key length])-1);
        if( nr< 0){
            nr = (int)[key length]-abs(nr);
        }
        
        
        char keyChar = [[key substringWithRange:NSMakeRange(nr, 1)] characterAtIndex:0];
        char mychar = (char)((int)charr-(int)keyChar);

        [result appendFormat:@"%c",mychar];
        
    }

    return result ;
}

- (NSString*)decryptString:(NSString*)stringToDecript key:(NSString*)key{
    
    NSMutableString *result = [[NSMutableString alloc]init];
    
   
    
    NSData *decriptedData = [NSData dataFromBase64String:stringToDecript];
    NSString *string = [[NSString alloc]initWithData:decriptedData encoding:NSASCIIStringEncoding];
    
    for(int i = 0; i<[string length]; i++){
        NSRange r = NSMakeRange(i, 1);
        char charr = (char)[[string substringWithRange:r] characterAtIndex:0];
        int nr = ((i%[key length])-1);
        if( nr< 0){
            nr = (int)[key length]-abs(nr);
        }
        
        
        char keyChar = [[key substringWithRange:NSMakeRange(nr, 1)] characterAtIndex:0];
        char mychar = (char)((int)charr-(int)keyChar);
        
        [result appendFormat:@"%c",mychar];
        
    }
    
    return result ;
}

@end
