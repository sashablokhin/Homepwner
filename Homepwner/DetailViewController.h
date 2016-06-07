//
//  DetailViewController.h
//  Homepwner
//
//  Created by Alexander Blokhin on 02.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABTableItem;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) ABTableItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (id)initForNewItem:(BOOL)isNew;

@end
