//
//  DetailViewController.m
//  Homepwner
//
//  Created by Alexander Blokhin on 02.06.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import "DetailViewController.h"
//#import "ABTableItem.h"
#import "ABItem.h"
#import "ABImageStore.h"
#import "ABItemStore.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton;

- (IBAction)takePicture:(id)sender;
- (IBAction)deleteImageButtonPressed:(id)sender;


@end

@implementation DetailViewController

@synthesize item, dismissBlock;

- (id)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    _nameField.delegate = self;
    _serialField.delegate = self;
    
    self.navigationItem.title = item.itemName;
    
    [self configureNumberKeyboard];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // проверка устройства
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _nameField.text = item.itemName;
    _serialField.text = item.serialNumber;
    _valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //_dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:item.dateCreated];
    _dateLabel.text = [dateFormatter stringFromDate:date];
    
    if (item.imageKey) {
        UIImage *imageToDisplay = [[ABImageStore sharedInstance] imageForKey:item.imageKey];
        _imageView.image = imageToDisplay;
        _deleteImageButton.hidden = false;
    } else {
        _imageView.image = nil;
        _deleteImageButton.hidden = true;
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


- (void)save:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:true completion:dismissBlock];
}

- (void)cancel:(id)sender {
    [[ABItemStore sharedInstance] removeItem:item];
    [[self presentingViewController] dismissViewControllerAnimated:true completion:dismissBlock];
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
    
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [item setThumbnailDataFromImage:image]; // создание миниатюры изображения
    [item setImageKey:[self makeUniqueIDString]];
    [[ABImageStore sharedInstance] setImage:image forKey:item.imageKey];
    
    [self dismissViewControllerAnimated:true completion:nil];
    
    _imageView.image = image;
    _deleteImageButton.hidden = false;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
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
    imagePicker.allowsEditing = true;
    imagePicker.modalPresentationStyle = UIModalPresentationPopover;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    UIPopoverPresentationController *popController = [imagePicker popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = sender;
    popController.delegate = self;
    
    [self presentViewController:imagePicker animated:true completion:nil];
}

- (IBAction)deleteImageButtonPressed:(id)sender {
    if (item.imageKey) {
        [[ABImageStore sharedInstance] deleteImageForKey:item.imageKey];
        item.imageKey = nil;
        _imageView.image = nil;
        _deleteImageButton.hidden = true;
    }
}

@end
