//
//  ABItem+CoreDataProperties.m
//  Homepwner
//
//  Created by Alexander Blokhin on 15.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ABItem+CoreDataProperties.h"

@implementation ABItem (CoreDataProperties)

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

@end
