//
//  ABImageStore.m
//  Homepwner
//
//  Created by Alexander Blokhin on 06.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "ABImageStore.h"

@implementation ABImageStore

+ (ABImageStore *)sharedInstance {
    
    static ABImageStore *sharedInstance = nil;
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
        dictionary = [[NSMutableDictionary alloc] init];
        
        // Регистрация в качестве наблюдателя за событием нехватки памяти
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)clearCache:(NSNotification *)notification {
    NSLog(@"flushing %d images out of the cache", [dictionary count]);
    [dictionary removeAllObjects];
    
    // Удалятся все изображения кроме отображаемого в DetailViewController так как его держит imageView сильной ссылкой
    // При необходимости изображения будут снова загружены из файлового хранилища
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [dictionary setObject:image forKey:key];
    
    // Создание полного пути для изображения
    NSString *imagePath = [self imagePathForKey:key];
    
    // Превращение изображения в JPEG данные
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Запись по полному пути
    [data writeToFile:imagePath atomically:true];
}

- (UIImage *)imageForKey:(NSString *)key {    
    // По возможности получить из словаря
    UIImage *result = [dictionary objectForKey:key];
    
    if (!result) {
        // Создание объекта UIImage из файла
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:key]];
        
        // Если нашли изображение в файловой системе, поместим его в кэш
        if (result)
            [dictionary setObject:result forKey:key];
        else
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key {
    if (key) {
        [dictionary removeObjectForKey:key];
        
        NSString *path = [self imagePathForKey:key];
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
}

- (NSString *)imagePathForKey:(NSString *)key {
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end
