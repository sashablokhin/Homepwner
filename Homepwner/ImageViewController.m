//
//  ImageViewController.m
//  Homepwner
//
//  Created by Alexander Blokhin on 14.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGSize size = self.image.size;
    [scrollView setContentSize:size];
    [imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [imageView setImage:self.image];
}

@end
