//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Alexander Blokhin on 14.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender {
    // Получение этого имени для данного метода, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    
    // Теперь селектор - это "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Подготовка селектора для данной строки
    SEL newSelector = NSSelectorFromString(selector);
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
            [[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
}
@end
