//
//  Utils.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/8/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Utils : NSObject

+ (NSString*) numberWithShortcut:(unsigned long long)number;

@end
