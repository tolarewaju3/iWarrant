//
//  editProductViewController.h
//  iTab
//
//  Created by TiOluwa Olarewaju on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Products.h"
#import "ViewImageController.h"
#import <Parse/Parse.h>

@interface editProductViewController : UITableViewController<UIImagePickerControllerDelegate>{
    BOOL newPic;
}
@property (weak, nonatomic) IBOutlet UITextField *storeP;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *serialNumber;
@property (weak, nonatomic) IBOutlet UITextField *month;
@property (weak, nonatomic) IBOutlet UITextField *day;
@property (weak, nonatomic) IBOutlet UITextField *year;

@property (strong, nonatomic) IBOutlet UIImageView *imageField;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) NSData *pickedImage;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Products *product;



- (IBAction)changePicture:(id)sender;
- (IBAction)clearPicture:(id)sender;

- (IBAction)done:(id)sender;
- (BOOL)checkForEmpty;
-(BOOL)checkDate;
-(void)syncToServer:(Products*)product;

@end
