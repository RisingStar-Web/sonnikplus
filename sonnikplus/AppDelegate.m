//
//  AppDelegate.m
//  sonnikplus
//
//  Created by neko on 02.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import "AppDelegate.h"
#import "Dreams.h"
#import "MainViewController.h"
#import "FavoritsViewController.h"
#import "UILunarController.h"
#import <SBJson/SBJson5.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tabBarController = _tabBarController;
@synthesize favorits = _favorits;
@synthesize moonDaysDict,moonPhaseDict,zodiacNameDict;

- (void)createFavoritsDictionary {
    NSString *favoritsPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/favorits.plist"];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:favoritsPath];
    if (exist) {
        self.favorits = [[NSMutableDictionary alloc] initWithContentsOfFile:favoritsPath];
    } else {
        self.favorits = [[NSMutableDictionary alloc] init];
        NSMutableArray *name = [NSMutableArray array];
        [self.favorits setObject:name forKey:@"name"];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSData *jsonData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"moondays.json"]];
    NSData *jsonData1 = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"moonphase.json"]];
    NSData *jsonData2 = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"zodiacname.json"]];
    
    SBJson5Parser *parser = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
        self.moonDaysDict = [[NSDictionary alloc] initWithDictionary: item];
    } errorHandler:nil];
    [parser parse:jsonData];

    SBJson5Parser *parser1 = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
        self.moonPhaseDict = [[NSDictionary alloc] initWithDictionary: item];
    } errorHandler:nil];
    [parser1 parse:jsonData1];

    SBJson5Parser *parser2 = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
        self.zodiacNameDict = [[NSDictionary alloc] initWithDictionary: item];
    } errorHandler:nil];
    [parser2 parse:jsonData2];

    [self copyDatabaseIfNeeded];
    [self createFavoritsDictionary];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *mainViewController = MainViewController.new;
    UINavigationController *mvnController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    mvnController.tabBarItem.image = [UIImage imageNamed:@"book.png"];
    
    FavoritsViewController *favoritsViewController = [[FavoritsViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *fvnController = [[UINavigationController alloc] initWithRootViewController:favoritsViewController];
    fvnController.tabBarItem.image = [UIImage imageNamed:@"star.png"];
    
    UILunarController *lController = [[UILunarController alloc] initWithNibName:nil bundle:nil];
    lController.tabBarItem.image = [UIImage imageNamed:@"moon.png"];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:mvnController, fvnController, lController, nil];
    self.window.rootViewController = self.tabBarController;
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.1973 green:0.2112 blue:0.5297 alpha:1.0000]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0510 green:0.1059 blue:0.5176 alpha:1.0000]];
    [[UINavigationBar appearance] setTranslucent:NO];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    [self saveContext];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        [managedObjectContext save:&error];
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sonnikplus" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"sonnikplus.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    return _persistentStoreCoordinator;
}

- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sonnikplus.sqlite"];
		[fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
	}
}

- (NSString *) getDBPath {
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"sonnikplus.sqlite"];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
