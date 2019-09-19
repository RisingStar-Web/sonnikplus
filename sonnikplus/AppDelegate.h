//
//  AppDelegate.h
//  sonnikplus
//
//  Created by neko on 02.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILunarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableDictionary *favorits;
@property (nonatomic, strong) NSDictionary *moonDaysDict;
@property (nonatomic, strong) NSDictionary *moonPhaseDict;
@property (nonatomic, strong) NSDictionary *zodiacNameDict;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
