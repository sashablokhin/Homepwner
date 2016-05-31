//
//  ABItemStore.m
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "ABItemStore.h"
#import "ABTableItem.h"

@implementation ABItemStore

+ (ABItemStore *)sharedInstance {
    
    static ABItemStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (ABTableItem *)createItem {
    ABTableItem *item = [ABTableItem randomItem];
    [_allItems addObject:item];
    
    return item;
}

- (void)removeItem:(ABTableItem *)item {
    [_allItems removeObjectIdenticalTo:item]; // removeObject сравнивает поля, removeObjectIdenticalTo - удаляет именно нужный объект
}

@end
