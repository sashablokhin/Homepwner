//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "ItemsViewController.h"
#import "ABItemStore.h"
#import "ABImageStore.h"
//#import "ABTableItem.h"
#import "ABItem.h"
#import "ImageViewController.h"

@interface ItemsViewController ()

@end

@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
    
    /*
    for (int i = 0; i < 5; i++) {
        [[ABItemStore sharedInstance] createItem];
    }*/
    
    self.navigationItem.title = @"Homepwner";
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(addNewItem:)];
    
    self.navigationItem.rightBarButtonItem = addBarButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ABItemStore sharedInstance] allItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell" forIndexPath:indexPath];
  
    //ABTableItem *item = [[[ABItemStore sharedInstance] allItems] objectAtIndex:indexPath.row];
    ABItem *item = [[[ABItemStore sharedInstance] allItems] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    
    cell.controller = self;
    cell.tableView = tableView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[[ABItemStore sharedInstance] allItems] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[ABItemStore sharedInstance] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:false];
    
    //ABTableItem *item = [[[ABItemStore sharedInstance] allItems] objectAtIndex:indexPath.row];
    ABItem *item = [[[ABItemStore sharedInstance] allItems] objectAtIndex:indexPath.row];
    detailViewController.item = item;
    
    [self.navigationController pushViewController:detailViewController animated:true];
}


#pragma mark - UITableViewDelegate
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[self headerView] bounds].size.height;
}*/


- (UIView *)headerView {
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    
    return _headerView;
}

#pragma mark - Actions

- (IBAction)toggleEditMode:(id)sender {
    if ([self isEditing]) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:false animated:true];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:true animated:true];
    }
}

- (IBAction)addNewItem:(id)sender {
    
    //ABTableItem *newItem = [[ABItemStore sharedInstance] createItem];
    ABItem *newItem = [[ABItemStore sharedInstance] createItem];
    
    /*
    int lastRow = [[[ABItemStore sharedInstance] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [[self tableView] insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
     */
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:true];
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
        [self.tableView reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:true completion:nil];
}

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)indexPath {

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        //ABTableItem *item = [[[ABItemStore sharedInstance] allItems] objectAtIndex:indexPath.row];
        ABItem *item = [[[ABItemStore sharedInstance] allItems] objectAtIndex:indexPath.row];
        NSString *imageKey = [item imageKey];
        
        // Если изображение остутствует, ничего отображать не нужно
        UIImage *img = [[ABImageStore sharedInstance] imageForKey:imageKey];
        
        if (!img) return;
        
        // Создание прямоугольника, который является фреймом для кнопки по отношению к табличному представлению
        CGRect rect = [self.view convertRect:[sender bounds] fromView:sender];
        
        // Создание нового контроллера ImageViewController и установка его изображения
        
        ImageViewController *ivc = [[ImageViewController alloc] init];
        ivc.modalPresentationStyle = UIModalPresentationPopover;
        
        [ivc setImage:img];
        
        // Представление всплывающего окна 600x600 пикселей на основе прямоугольника
        [ivc setPreferredContentSize:CGSizeMake(600, 600)];
        
        UIPopoverPresentationController *popController = [ivc popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popController.sourceView = self.view;
        popController.sourceRect = rect;
        
        popController.delegate = self;
        
        [self presentViewController:ivc animated:true completion:nil];
    }

}

@end









