//
//  Created by neko on 17.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICurrentMoonController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *currentMoonInfo;
    NSString *moonRising;
    NSString *moonRisingState;
    NSMutableArray *contentArray;
}

@property (nonatomic, strong) NSString *moonRising;

- (id)initWithStyle:(UITableViewStyle)style moonInfoDict:(NSDictionary*)moonInfoDict;

@end
