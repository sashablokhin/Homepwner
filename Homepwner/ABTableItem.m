//
//  TableItem.m
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "ABTableItem.h"

@implementation ABTableItem


+ (id)randomItem {
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count]; // случайное чило 0...2
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    ABTableItem *newItem = [[self alloc] initWithItemName:randomName
                                           valueInDollars:randomValue
                                             serialNumber:randomSerialNumber];
    
    return newItem;
}

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber {
    self = [super init];
    
    if (self) {
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        _dateCreated = [NSDate date];
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %d $ - %@", _itemName, _valueInDollars, _serialNumber];
}

- (UIImage *)thumbnail {
    // Если остутствует thumbnailData, нет возвращаемой миниатюры
    if (!_thumbnailData) {
        return nil;
    }
    
    // Если не создано изображение миниатюры на основе моих данных, создайте его
    if (!_thumbnail) {
        _thumbnail = [UIImage imageWithData:_thumbnailData];
    }
    
    return _thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image {
    CGSize origImageSize = image.size;
    
    // Прямоугольник миниатюры
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Определение пропорций масштабирования, гарантирующих поддержку одинаковых пропорций
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    // Создание прозрачного контекста растра с коэффициентом масштабирования, соответствующим данному экрану
    UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0);
    
    // Создание контура в виде прямоугольника со скругленными краями
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    // Создание всех последующих клипов рисунка для этого прямоугольника со скругленными краями
    [path addClip];
    
    // Центрирование изображения в области прямоугольника миниатюры
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Рисование изображения
    [image drawInRect:projectRect];
    
    // Получение изображения на основе контекста изображения, его сохранение в виде миниатюры
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    // Получение PNG-представления изображения и его настройка в виде архивируемых данных
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // Очистка ресурсов контекста изображения, завершено
    UIGraphicsEndImageContext();
}

// Для архивирования
// Что бы кодирование стало возможным, объекты должны соответствовать протоколу NSCoding

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_itemName forKey:@"itemName"];
    [aCoder encodeObject:_serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:_dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:_imageKey forKey:@"imageKey"];
    [aCoder encodeObject:_thumbnailData forKey:@"thumbnailData"];
    
    [aCoder encodeInt:_valueInDollars forKey:@"valueInDollars"];
}

// Объекты загруженные из архива, отсылают сообщение initWithCoder. Этот метод будет захватывать все объекты,
// которые были закодированы в encodeWithCoder, присваивая их соответствующим переменным экземпляра класса.

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setThumbnailData:[aDecoder decodeObjectForKey:@"thumbnailData"]];
        
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
    }
    
    return self;
}

@end





