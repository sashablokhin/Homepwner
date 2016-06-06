//
//  DetailViewController.h
//  Homepwner
//
//  Created by Alexander Blokhin on 02.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABTableItem;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) ABTableItem *item;

@end
