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

// Для архивирования
// Что бы кодирование стало возможным, объекты должны соответствовать протоколу NSCoding

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_itemName forKey:@"itemName"];
    [aCoder encodeObject:_serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:_dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:_imageKey forKey:@"imageKey"];
    
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
        
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
    }
    
    return self;
}

@end





