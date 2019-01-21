//
//  DecryptManager.h
//  Wallpapers
//
//  Created by Alejando M on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecryptManager : NSObject
- (NSString*)decryptData:(NSData*)stringData key:(NSString*)key;
- (NSString*)decryptString:(NSString*)stringToDecript key:(NSString*)key;
+ (id)sharedManager;
@end
