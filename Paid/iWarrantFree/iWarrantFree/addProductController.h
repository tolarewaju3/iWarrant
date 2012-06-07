//
//  addProductController.h
//  iTab
//
//  Created by TiOluwa Olarewaju on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Products.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"


@interface addProductController : UITableViewController<UIImagePickerControllerDelegate>{

}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *storeP;
@property (weak, nonatomic) IBOutlet UITextField *productName;

@property (weak, nonatomic) IBOutlet UITextField *serialNumber;
@property (weak, nonatomic) IBOutlet UITextField *month;

@property (weak, nonatomic) IBOutlet UITextField *day;
@property (weak, nonatomic) IBOutlet UITextField *year;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIImageView *imageField;
@property (strong, nonatomic) NSData *pickedImage;

- (IBAction)closeKeyboard:(id)sender;

- (IBAction)addProduct:(id)sender;
- (BOOL)checkForEmpty;
-(BOOL)checkDate;
-(void)syncToServer:(Products*)product;
-(void)updatePrefCount;



@end
