//
//  Singleton.m
//  drugsfree
//
//  Created by neko on 14.08.14.
//  Copyright (c) 2014 Lev Natalya. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

-(BOOL)checkFullVersion {
    switch (kFullVersion) {
        case 0:
            return NO;
            break;
        case 1:
            return YES;
            break;
        default:
            break;
    }
}

@end
