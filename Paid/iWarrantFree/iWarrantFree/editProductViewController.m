//
//  editProductViewController.m
//  iTab
//
//  Created by TiOluwa Olarewaju on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "editProductViewController.h"

@interface editProductViewController ()

@end

@implementation editProductViewController
@synthesize storeP;
@synthesize name;
@synthesize serialNumber;
@synthesize month;
@synthesize day;
@synthesize year;

@synthesize imageField;
@synthesize imagePicker;

@synthesize product;
@synthesize managedObjectContext;
@synthesize pickedImage;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"viewImage"])
	{
		ViewImageController *vP = segue.destinationViewController;
        vP.product = product;
        
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == storeP) {
        [storeP resignFirstResponder];
    }
    if (textField == name) {
        [name resignFirstResponder];
    }
    if (textField == serialNumber) {
        [serialNumber resignFirstResponder];
    }
    if (textField == month) {
        [month resignFirstResponder];
    }
    if (textField == day) {
        [day resignFirstResponder];
    }
    if (textField == year) {
        [year resignFirstResponder];
    }
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    newPic = NO;
    name.text = product.name;
    storeP.text = product.storePurchased;
    serialNumber.text = product.serialNumber;
    if ([product receiptPicture]){
        [imageField setImage:[UIImage imageWithData:[product receiptPicture]]];
    }
        
    NSString *date = product.purchaseDate;
    
    NSArray *dateSplit = [date componentsSeparatedByString:@"/"];
    

    NSString *month1 = [dateSplit objectAtIndex:0];
    NSString *day1 = [dateSplit objectAtIndex:1];
    NSString *year1 = [dateSplit objectAtIndex:2];
    month.text = month1;
    day.text = day1;
    year.text = year1;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setStoreP:nil];
    [self setName:nil];
    [self setSerialNumber:nil];
    [self setMonth:nil];
    [self setDay:nil];
    [self setYear:nil];
    [self setProduct:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)changePicture:(id)sender {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissModalViewControllerAnimated:YES];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    [imageField setImage:smallImage];
    pickedImage = imageData;
    newPic = YES;
}


- (IBAction)clearPicture:(id)sender {
    [imageField setImage:nil];
}

-(PFObject*)returnProduct{
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    [query whereKey:@"serialNumber" equalTo:product.serialNumber];
    PFObject *one = [query getFirstObject];
    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            NSLog(@"%i is the count", objects.count);
//            one = [objects objectAtIndex:0];
//            NSString *n1 = [one objectForKey:@"name"];
//            NSLog(@"name is %@", n1);
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    return one;
}

-(void)syncToServer:(Products*)productO{

    if (newPic == YES) {
        NSLog(@"new pic");
        PFUser *user = [PFUser currentUser];
        PFFile *f1 = [PFFile fileWithName:@"receiptPicture.jpg" data:[productO receiptPicture]];
        [f1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error){
                PFObject *product1 = [self returnProduct];
                [product1 setObject:productO.storePurchased forKey:@"locationP"];
                [product1 setObject:productO.name forKey:@"name"];
                [product1 setObject:productO.serialNumber forKey:@"serialNumber"];
                [product1 setObject:productO.purchaseDate forKey:@"date"];
                [product1 setObject:user forKey:@"user"];
                [product1 setObject:f1 forKey:@"receiptPicture"];
                
                product1.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [product1 saveEventually];
            }
        }];
    }
    else {
        NSLog(@"no new pic");
        PFUser *user = [PFUser currentUser];
        PFObject *product1 = [self returnProduct];
        NSLog(@"%@", productO.name);
        [product1 setObject:productO.storePurchased forKey:@"locationP"];
        [product1 setObject:productO.name forKey:@"name"];
        [product1 setObject:productO.serialNumber forKey:@"serialNumber"];
        [product1 setObject:productO.purchaseDate forKey:@"date"];
        [product1 setObject:user forKey:@"user"];
        product1.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [product1 saveEventually];
            
    }
    
}




- (IBAction)done:(id)sender {
    if ([self checkForEmpty] && [self checkDate]) {
        NSLog(@"Product Updated");
        
        NSString *bN = storeP.text;
        NSString *pN = name.text;
        NSString *sN = serialNumber.text;
        
        NSString *m1 = month.text;
        NSString *y1 = year.text;
        NSString *d1 = day.text;
        NSString *date = [[NSString alloc]initWithFormat:@"%@/%@/%@", m1, d1, y1];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Product Updated!"
                              message: nil
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        NSData *picture = pickedImage;
        
        // Edit product in Core Data
        
        [product setName:pN];
        [product setSerialNumber:sN];
        [product setStorePurchased:bN];
        [product setPurchaseDate:date];
        if (picture) {
            [self.product setReceiptPicture:picture];
        }
        
        // Commit to core data
        NSError *error;
        if (![self.managedObjectContext save:&error])
            NSLog(@"Failed to add default user with error: %@", [error domain]);
        
        [self performSelectorInBackground:@selector(syncToServer:) withObject:product];


        
    }
}

-(BOOL)checkDate{
    NSString *m1 = month.text;
    NSString *y1 = year.text;
    NSString *d1 = day.text;
    
    if (m1.length == 0 | y1.length == 0 | d1.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Please Fill All Fields"
                              message: @""
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
    
}

-(BOOL)checkForEmpty{
    
    NSString *bN = storeP.text;
    NSString *pN = name.text;
    NSString *sN = serialNumber.text;
    
    
    if (bN.length == 0 | pN.length == 0 | sN.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Please Fill All Fields"
                              message: @""
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

@end
