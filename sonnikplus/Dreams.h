//
//  Dreams.h
//  sonnikplus
//
//  Created by neko on 02.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dreams : NSManagedObject

@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSString * word;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * dictname;

@end
