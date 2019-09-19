//
//  ContentView.m
//  drugsplus
//
//  Created by neko on 31.01.13.
//  Copyright (c) 2013 Denis Alfa. All rights reserved.
//

#import "ContentView.h"
#import "MainViewController.h"
#import "CustomHeader.h"
#import "FavoritsViewController.h"
#import "Dreams.h"

@interface ContentView ()

@end

@implementation ContentView

@synthesize managedObjects;

- (void)favAction:(NSInteger)rowNumber {
    Dreams *dreams = [self.managedObjects objectAtIndex:rowNumber];
    if ([[SharedAppDelegate.favorits objectForKey:@"name"] containsObject:dreams.number]) {
        [[SharedAppDelegate.favorits objectForKey:@"name"] removeObject:dreams.number];
        [self.navigationController popViewControllerAnimated:YES];
        [self showAlertWithTitle:@"Успешно" andMessage:@"Удалено из избранного."];
    } else {
        [[SharedAppDelegate.favorits objectForKey:@"name"] addObject:dreams.number];
        [drugsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:rowNumber]] withRowAnimation:UITableViewRowAnimationFade];
        [self showAlertWithTitle:@"Успешно" andMessage:@"Добавлено в избранное."];
    }

    NSString *favoritsPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/favorits.plist"];
    [SharedAppDelegate.favorits writeToFile:favoritsPath atomically: YES];
    FavoritsViewController *fvc = [[SharedAppDelegate.tabBarController childViewControllers][1] childViewControllers][0];
    [fvc reloadView];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                }];
    
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)smsShareAction:(NSInteger)rowNumber {
    if ([MFMessageComposeViewController canSendText]) {
        NSManagedObject *managedObject = managedObjects[rowNumber];
        NSString *dictStr = [managedObject valueForKey:@"dictname"];
        NSString *contentStr = [managedObject valueForKey:@"content"];
        NSString *wordStr = [managedObject valueForKey:@"word"];
        NSString *outStr = [NSString stringWithFormat:@"\"%@\": %@ - %@", dictStr, wordStr, contentStr];
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        messageController.body = outStr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:messageController animated:YES completion:NULL];
        });
    } else {
        [self showAlertWithTitle:@"Внимание!" andMessage:@"Отправка сообщений не поддерживается на Вашем устройстве."];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@",[[[[managedObjects objectAtIndex:0] valueForKey:@"word"] substringToIndex:1] uppercaseString],[[[[managedObjects objectAtIndex:0] valueForKey:@"word"] lowercaseString] substringFromIndex:1]];
    drugsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    drugsTable.delegate = self;
    drugsTable.dataSource = self;
    drugsTable.backgroundColor = [UIColor clearColor];
    drugsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    drugsTable.separatorColor = [UIColor clearColor];
    drugsTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:drugsTable];

    NSLayoutConstraint *leadingConstraint = [drugsTable.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint *topConstraint = [self.view.topAnchor constraintEqualToAnchor:drugsTable.topAnchor];
    NSLayoutConstraint *trailingConstraint = [drugsTable.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    NSLayoutConstraint *bottomConstraint = [drugsTable.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    [NSLayoutConstraint activateConstraints:@[leadingConstraint,
                                              topConstraint,
                                              trailingConstraint,
                                              bottomConstraint]];
    self.view.backgroundColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellText = [[managedObjects objectAtIndex:indexPath.section] valueForKey:@"content"];
    CGSize labelSize = [cellText boundingRectWithSize:CGSizeMake(drugsTable.frame.size.width - 10.0, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                              context:nil].size;
    return labelSize.height + 56.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CustomHeader *header = [[CustomHeader alloc] init];
    header.lightColor = [UIColor colorWithRed:0.3569 green:0.5137 blue:0.7765 alpha:1.0000];
    header.darkColor = [UIColor colorWithRed:0.0510 green:0.1059 blue:0.5176 alpha:1.0000];
    header.titleLabel.text = [[managedObjects objectAtIndex:section] valueForKey:@"dictname"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [managedObjects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (ContentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell" cellText:[[managedObjects objectAtIndex:indexPath.section] valueForKey:@"content"] rowNumber:indexPath.section frame:self.view.bounds number:[[managedObjects objectAtIndex:indexPath.section] valueForKey:@"number"]];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
