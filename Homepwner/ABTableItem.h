//
//  TableItem.h
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ABTableItem : NSObject <NSCoding>

@property (nonatomic, strong) ABTableItem *containedItem;
@property (nonatomic, weak) ABTableItem *container;

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, assign) int valueInDollars;
@property (nonatomic, strong, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *imageKey;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData; // так как UImage не подписан на NSCoding, то для архивирования используется NSData

- (void)setThumbnailDataFromImage:(UIImage *)image;

+ (ABTableItem *)randomItem;

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

@end
