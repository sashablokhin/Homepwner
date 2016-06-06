//
//  DetailViewController.m
//  Homepwner
//
//  Created by Alexander Blokhin on 02.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "DetailViewController.h"
#import "ABTableItem.h"
#import "ABImageStore.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePicture:(id)sender;

@end

@implementation DetailViewController

@synthesize item;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    self.navigationItem.title = item.itemName;
    
    [self configureNumberKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _nameField.text = item.itemName;
    _serialField.text = item.serialNumber;
    _valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    _dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    if (item.imageKey) {
        UIImage *imageToDisplay = [[ABImageStore sharedInstance] imageForKey:item.imageKey];
        _imageView.image = imageToDisplay;
    } else {
        _imageView.image = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:true];
    
    item.itemName = _nameField.text;
    item.serialNumber = _serialField.text;
    item.valueInDollars = _valueField.text.intValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureNumberKeyboard {
    UIBarButtonItem *numberPadDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                         target:self.valueField
                                                                                         action:@selector(resignFirstResponder)];
    
    UIToolbar *numberPadAccessoryInputView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    numberPadAccessoryInputView.items = @[space, numberPadDoneButton];
    
    self.valueField.inputAccessoryView = numberPadAccessoryInputView;
}

- (NSString *)makeUniqueIDString {
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString *string = (__bridge NSString *)newUniqueIDString;
    
    // Объекты Core Foundation нужно релизить
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    return string;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (item.imageKey) {
        [[ABImageStore sharedInstance] deleteImageForKey:item.imageKey];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [item setImageKey:[self makeUniqueIDString]];
    [[ABImageStore sharedInstance] setImage:image forKey:item.imageKey];
    
    [self dismissViewControllerAnimated:true completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:true completion:nil];
}

@end
