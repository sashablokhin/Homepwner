//
//  ABItem.h
//  Homepwner
//
//  Created by Alexander Blokhin on 15.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABItem : NSManagedObject

- (void)setThumbnailDataFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

#import "ABItem+CoreDataProperties.h"
