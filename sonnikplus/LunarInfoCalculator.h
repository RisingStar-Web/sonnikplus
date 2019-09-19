//
//  LunarInfoCalculator.h
//  sonnikplus
//
//  Created by neko on 15.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunarInfoCalculator : NSDictionary {
//    NSMutableDictionary *moonInfo;
}

- (NSDictionary *)initWithGeoposAndDate:(int)outYear month:(int)outMonth day:(int)outDay hours:(int)outHours minutes:(int)outMinutes seconds:(double)outSeconds longitude:(double)longitude latitude:(double)latitude;

@end
