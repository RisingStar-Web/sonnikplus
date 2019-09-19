//
//  FavouritesViewController.h
//  drugsplus
//
//  Created by neko on 06.02.13.
//  Copyright (c) 2013 Denis Alfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritsViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *favsArray;
    UITableView *tableView;
}

- (void)reloadView;

@property (nonatomic, strong) NSArray *favsArray;
@property (nonatomic, strong) UITableView *tableView;

@end