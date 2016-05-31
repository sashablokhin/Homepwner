//
//  ABItemStore.h
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABTableItem; // директива class существенно ускоряет время компиляции

@interface ABItemStore : NSObject

@property NSMutableArray *allItems;

+ (ABItemStore *)sharedInstance;

- (ABTableItem *)createItem;

@end
