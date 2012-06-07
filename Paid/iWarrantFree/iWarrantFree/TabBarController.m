//
//  TabBarController.m
//  iTab
//
//  Created by TiOluwa Olarewaju on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"
#import "AppDelegate.h"
#import "MyLoginViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController
@synthesize managedObjectContext;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)logOutNOW:(id)sender{
    UITabBarController *tabBarController = self;
    [tabBarController setSelectedIndex:0];
    
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    
    [self prepareToLogOn];

}

-(void)prepareToLogOn{
    MyLoginViewController *logInController = [[MyLoginViewController alloc] init];
    
    logInController.delegate = self;
    logInController.signUpController.delegate = self;
    [self presentModalViewController:logInController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSArray *controllers = self.viewControllers;
    UINavigationController *nv1 = (UINavigationController *)[controllers objectAtIndex:0];
    addProductController *a1 = (addProductController *)nv1.topViewController;
    a1.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *nv2 = (UINavigationController *)[controllers objectAtIndex:1];
    ProductTableViewController *q1 = (ProductTableViewController *)nv2.topViewController;
    q1.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *nv3 = (UINavigationController *)[controllers objectAtIndex:2];
    aboutViewController *ab1 = (aboutViewController *)nv3.topViewController;
    ab1.managedObjectContext = self.managedObjectContext;
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    
    if (!currentUser) {
        [self prepareToLogOn];
    }
   
}

-(void)migrateFromServer{
    NSLog(@"Migrating...");
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        PFQuery *query = [PFQuery queryWithClassName:@"Product"];
        [query whereKey:@"user" equalTo:currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                for (PFObject* p1 in objects) {
                    [self performSelectorInBackground:@selector(saveToCore:) withObject:p1];
                }
                NSLog(@"Successfully retrieved %d products.", objects.count);
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}


-(void)saveToCore:(PFObject*)saveObj{
    NSString *productName = [saveObj objectForKey:@"name"];
    NSString *storePurchased = [saveObj objectForKey:@"locationP"];
    NSString *serialNumber1 = [saveObj objectForKey:@"serialNumber"];
    NSString *date = [saveObj objectForKey:@"date"];
    
    PFFile *receipt = [saveObj objectForKey:@"receiptPicture"];
    NSData *pic1 = [receipt getData];
    
    Products *product = (Products *)[NSEntityDescription insertNewObjectForEntityForName:@"Products" inManagedObjectContext:self.managedObjectContext];
    [product setName:productName];
    [product setSerialNumber:serialNumber1];
    [product setStorePurchased:storePurchased];
    [product setReceiptPicture:pic1];
    [product setPurchaseDate:date];
    
    // Commit to core data
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Failed to add default user with error: %@", [error domain]);

}



- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {

    [self dismissModalViewControllerAnimated:YES];
    
    PFUser *currentUser = [PFUser currentUser];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs integerForKey:@"productCount"] == 0){
        [self performSelectorInBackground:@selector(migrateFromServer) withObject:nil];
        NSLog(@"HI");
    }

    
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
