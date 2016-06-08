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
        NSString *path = [self itemArchivePath];
        self.allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!self.allItems) {
            self.allItems = [[NSMutableArray alloc] init];
        }
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

- (void)moveItemAtIndex:(int)from toIndex:(int)to {
    if (from == to) {
        return;
    }
    
    ABTableItem *item = [_allItems objectAtIndex:from];
    
    [_allItems removeObjectAtIndex:from];
    [_allItems insertObject:item atIndex:to];
}

- (NSString *)itemArchivePath {
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    // Возвращает массив так как в OS X может быть несколько путей, которые соответствуют критериям поиска. Но в iOS может быть только путь. 
    
    // Получение из списка только каталога документа
    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges {
    NSString *path = [self itemArchivePath];
    
    NSLog(@"%@", path);
    
    return [NSKeyedArchiver archiveRootObject:_allItems toFile:path];
}

@end


















