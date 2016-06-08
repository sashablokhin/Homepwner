//
//  TableItem.h
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABTableItem : NSObject <NSCoding>

@property (nonatomic, strong) ABTableItem *containedItem;
@property (nonatomic, weak) ABTableItem *container;

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, assign) int valueInDollars;
@property (nonatomic, strong, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *imageKey;

+ (ABTableItem *)randomItem;

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

@end
