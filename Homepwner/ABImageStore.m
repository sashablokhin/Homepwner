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
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    return [dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key {
    if (key) {
        [dictionary removeObjectForKey:key];
    }
}

@end
