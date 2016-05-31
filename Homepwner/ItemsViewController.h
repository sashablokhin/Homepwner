//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UITableViewController

- (IBAction)toggleEditMode:(id)sender;
- (IBAction)addNewItem:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *headerView;

- (UIView *)headerView;

@end
