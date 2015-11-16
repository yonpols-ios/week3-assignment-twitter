//
//  Utils.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/8/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString*) numberWithShortcut:(unsigned long long)number
{
    NSUInteger index = 0;
    double dvalue = (double)number;
    
    NSArray *suffix = @[ @"", @"k", @"m", @"b"];
    
    while ((number /= 1000) && ++index && index < [suffix count]) dvalue /= 1000;
    
    NSString *svalue;
    double rounded = round(dvalue * 100) / 100;
    if (rounded == truncf(dvalue)) {
        svalue = [NSString stringWithFormat:@"%.0f%@", rounded, [suffix objectAtIndex:index]];
    } else {
        svalue = [NSString stringWithFormat:@"%.2f%@", rounded, [suffix objectAtIndex:index]];
    }
    
    return svalue;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
