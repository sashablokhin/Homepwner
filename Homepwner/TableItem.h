//
//  TableItem.h
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableItem : NSObject

@property (nonatomic, strong) TableItem *containedItem;
@property (nonatomic, weak) TableItem *container;

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, assign) int valueInDollars;
@property (nonatomic, strong, readonly) NSDate *dateCreated;

@end
