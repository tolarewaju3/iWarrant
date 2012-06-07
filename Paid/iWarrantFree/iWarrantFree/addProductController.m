//
//  addProductController.m
//  iTab
//
//  Created by TiOluwa Olarewaju on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "addProductController.h"

@interface addProductController ()

@end

@implementation addProductController

@synthesize pickedImage;
@synthesize month;
@synthesize day;
@synthesize year;
@synthesize storeP;
@synthesize productName;
@synthesize serialNumber;
@synthesize imagePicker;
@synthesize imageField;


@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

//  Take an image with camera
- (IBAction)imageFromCamera:(id)sender
{
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
}

//  Take an image with camera
- (IBAction)clearImage:(id)sender
{
    [imageField setImage:nil];
}



//  On cancel, only dismiss the picker controller
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == storeP) {
        [storeP resignFirstResponder];
    }
    if (textField == productName) {
        [productName resignFirstResponder];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == month || textField == day){
        return (newLength > 2) ? NO : YES;
    }
    
    if (textField == year){
        return (newLength > 4) ? NO : YES;
    }
    
    if (textField == year){
        return (newLength > 4) ? NO : YES;
    }
    
    
    return (newLength > 25) ? NO : YES;
}

- (IBAction)closeKeyboard:(id)sender{
    if ([year.text length]>=4) {
        [year resignFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{

    [self setStoreP:nil];
    [self setProductName:nil];
    [self setSerialNumber:nil];
    [self setMonth:nil];
    [self setDay:nil];
    [self setYear:nil];
    [self setImageField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)addProduct:(id)sender {
    if ([self checkForEmpty] && [self checkDate]) {
        NSLog(@"Product Added");
        
        NSString *bN = storeP.text;
        NSString *pN = productName.text;
        NSString *sN = serialNumber.text;
        
        NSString *m1 = month.text;
        NSString *y1 = year.text;
        NSString *d1 = day.text;
        
        NSString *date = [[NSString alloc]initWithFormat:@"%@/%@/%@", m1, d1, y1];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Product Added!"
                              message: nil
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        
        // Add our default user object in Core Data
        Products *product = (Products *)[NSEntityDescription insertNewObjectForEntityForName:@"Products" inManagedObjectContext:self.managedObjectContext];
        [product setName:pN];
        [product setSerialNumber:sN];
        [product setStorePurchased:bN];
        [product setReceiptPicture:pickedImage];
        [product setPurchaseDate:date];
        
        // Commit to core data
        NSError *error;
        if (![self.managedObjectContext save:&error])
            NSLog(@"Failed to add default user with error: %@", [error domain]);
        

        [self performSelectorInBackground:@selector(syncToServer:) withObject:product];
        
                
        [storeP setText:@""];
        [serialNumber setText:@""];
        [productName setText:@""];
        [month setText:@""];
        [day setText:@""];
        [year setText:@""];
        [imageField setImage:nil];
        
        
        [month resignFirstResponder];
        [day resignFirstResponder];
        [year resignFirstResponder];
    }
    [month resignFirstResponder];
    [day resignFirstResponder];
    [year resignFirstResponder];
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
    NSString *pN = productName.text;
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

-(void)updatePrefCount{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int count = [prefs integerForKey:@"productCount"];
    count = count + 1;
    [prefs setInteger:count forKey:@"productCount"];
    [prefs synchronize];
}

-(void)syncToServer:(Products*)product{
    NSLog(@"Migrating...");
    [self updatePrefCount];
    PFUser *user = [PFUser currentUser];
    PFFile *f1 = [PFFile fileWithName:@"receiptPicture.jpg" data:[product receiptPicture]];
    [f1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error){
            PFObject *product1 = [PFObject objectWithClassName:@"Product"];
            [product1 setObject:product.storePurchased forKey:@"locationP"];
            [product1 setObject:product.name forKey:@"name"];
            [product1 setObject:product.serialNumber forKey:@"serialNumber"];
            [product1 setObject:product.purchaseDate forKey:@"date"];
            [product1 setObject:user forKey:@"user"];
            [product1 setObject:f1 forKey:@"receiptPicture"];
            
            product1.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [product1 saveEventually];
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
