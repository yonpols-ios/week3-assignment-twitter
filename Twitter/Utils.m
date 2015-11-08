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
    
    NSString *svalue = [NSString stringWithFormat:@"%@%@",[NSNumber numberWithDouble:dvalue], [suffix objectAtIndex:index]];
    
    return svalue;
}


@end
