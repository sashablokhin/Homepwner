//
//  ABItem.m
//  Homepwner
//
//  Created by Alexander Blokhin on 15.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "ABItem.h"

@implementation ABItem

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

- (void)awakeFromFetch {
    [super awakeFromFetch];
    
    UIImage *tn = [UIImage imageWithData:self.thumbnailData];
    [self setPrimitiveValue:tn forKey:@"thumbnail"];
}

// После добавления объектов в базу данных они отсылают сообщение awakeFromInsert
- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.dateCreated = [[NSDate date] timeIntervalSinceReferenceDate];
}

@end
