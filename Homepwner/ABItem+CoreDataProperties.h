//
//  ABItem+CoreDataProperties.h
//  Homepwner
//
//  Created by Alexander Blokhin on 15.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ABItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *itemName;
@property (nullable, nonatomic, retain) NSString *serialNumber;
@property (nonatomic) int32_t valueInDollars;
@property (nonatomic) NSTimeInterval dateCreated;
@property (nullable, nonatomic, retain) NSString *imageKey;
@property (nullable, nonatomic, retain) NSData *thumbnailData;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nullable, nonatomic, retain) NSManagedObject *assetType;

@end

NS_ASSUME_NONNULL_END
