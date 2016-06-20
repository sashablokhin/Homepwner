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
    //ABItem *item = [[ABItem alloc] init];//[ABItem randomItem];
    
    double order;
    
    if (self.allItems.count == 0) {
        order = 1.0;
    } else {
        order = [[self.allItems lastObject] orderingValue] + 1.0;
    }
    
    NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)self.allItems.count, order);
    
    ABItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"ABItem" inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    [_allItems addObject:item];
    
    return item;
}

- (void)removeItem:(ABItem *)item {
    [[ABImageStore sharedInstance] deleteImageForKey:[item imageKey]];
    
    [self.context deleteObject:item];
    
    [_allItems removeObjectIdenticalTo:item]; // removeObject сравнивает поля, removeObjectIdenticalTo - удаляет именно нужный объект
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to {
    if (from == to) {
        return;
    }
    
    ABItem *item = [_allItems objectAtIndex:from];
    
    [_allItems removeObjectAtIndex:from];
    [_allItems insertObject:item atIndex:to];
    
    // Вычисление нового значения orderValue для перемещенного объекта
    double lowerBound = 0.0;
    
    if (to > 0) {
        lowerBound = [[self.allItems objectAtIndex:to - 1] orderingValue];
    } else {
        lowerBound = [[self.allItems objectAtIndex:1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Имеется ли в массиве последующий объект?
    
    if (to < self.allItems.count - 1) {
        upperBound = [[self.allItems objectAtIndex:to + 1] orderingValue];
    } else {
        upperBound = [[self.allItems objectAtIndex:to - 1] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"Moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
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
    
    if (!self.allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entityDesc = [[self.model entitiesByName] objectForKey:@"ABItem"];
        request.entity = entityDesc;
        
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:true];
        request.sortDescriptors = @[sortDesc];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", error.localizedDescription ];
        }
        
        self.allItems = [[NSMutableArray alloc] initWithArray:result];
        
        // Для выборки используется предикат
        // request.predicate = [NSPredicate predicateWithFormat:@"valueInDollars > 50"];
    }
    
}


- (NSArray *)allAssetTypes {
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entityDecr = [[_model entitiesByName] objectForKey:@"ABAssetType"];
        
        [request setEntity:entityDecr];
        
        NSError *error;
        NSArray *result = [_context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", error.localizedDescription];
        }
        
        _allAssetTypes = [result mutableCopy];
    }
    
    // Программа запускается первый раз?
    if (_allAssetTypes.count == 0) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ABAssetType" inManagedObjectContext:_context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ABAssetType" inManagedObjectContext:_context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ABAssetType" inManagedObjectContext:_context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    
    return _allAssetTypes;
}


@end


















