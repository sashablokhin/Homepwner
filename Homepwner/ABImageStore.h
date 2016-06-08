//
//  ABImageStore.h
//  Homepwner
//
//  Created by Alexander Blokhin on 06.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+ (ABImageStore *)sharedInstance;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

- (NSString *)imagePathForKey:(NSString *)key;

@end
