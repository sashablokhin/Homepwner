//
//  ABItemStore.m
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "ABItemStore.h"
//#import "ABTableItem.h"
#import "ABItem.h"
#import "ABImageStore.h"

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
        /* 
         вариант с архивированием
        
         NSString *path = [self itemArchivePath];
        self.allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!self.allItems) {
            self.allItems = [[NSMutableArray alloc] init];
        }*/
        
        // Считывание из файла Homepwner.xcdatamodeld
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        // Где находится файл SQLite?
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Создание управляемого контекста объекта
        self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.context setPersistentStoreCoordinator:psc];
        
        // Управляемый контекст объекта может управлять отменой, но не нуждается в этом
        [self.context setUndoManager:nil];
        [self loadAllItems];
    }
    return self;
}


- (ABItem *)createItem {
    ABItem *item = [[ABItem alloc] init];//[ABItem randomItem];
    [_allItems addObject:item];
    
    return item;
}

- (void)removeItem:(ABItem *)item {
    [[ABImageStore sharedInstance] deleteImageForKey:[item imageKey]];
    
    [_allItems removeObjectIdenticalTo:item]; // removeObject сравнивает поля, removeObjectIdenticalTo - удаляет именно нужный объект
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to {
    if (from == to) {
        return;
    }
    
    ABItem *item = [_allItems objectAtIndex:from];
    
    [_allItems removeObjectAtIndex:from];
    [_allItems insertObject:item atIndex:to];
}

/*
- (ABTableItem *)createItem {
    ABTableItem *item = [ABTableItem randomItem];
    [_allItems addObject:item];
    
    return item;
}

- (void)removeItem:(ABTableItem *)item {
    [[ABImageStore sharedInstance] deleteImageForKey:[item imageKey]];
    
    [_allItems removeObjectIdenticalTo:item]; // removeObject сравнивает поля, removeObjectIdenticalTo - удаляет именно нужный объект
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to {
    if (from == to) {
        return;
    }
    
    ABTableItem *item = [_allItems objectAtIndex:from];
    
    [_allItems removeObjectAtIndex:from];
    [_allItems insertObject:item atIndex:to];
}*/

- (NSString *)itemArchivePath {
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    // Возвращает массив так как в OS X может быть несколько путей, которые соответствуют критериям поиска. Но в iOS может быть только путь. 
    
    // Получение из списка только каталога документа
    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
    
    //return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges {
    // вариант с архивированием
    //NSString *path = [self itemArchivePath];
    //return [NSKeyedArchiver archiveRootObject:_allItems toFile:path];
    
    NSError *error = nil;
    BOOL success = [self.context save:&error];
    
    if (!success) {
        NSLog(@"Error saving: %@", error.localizedDescription);
    }
    
    return success;
}

- (void)loadAllItems {
    
}

@end


















