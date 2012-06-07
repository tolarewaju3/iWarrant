//
//  TabBarController.h
//  iTab
//
//  Created by TiOluwa Olarewaju on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "addProductController.h"
#import "aboutViewController.h"
#import "ProductTableViewController.h"


@interface TabBarController : UITabBarController{
    
    
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (IBAction)logOutNOW:(id)sender; 
-(void)prepareToLogOn;
-(void)migrateFromServer;
-(void)saveToCore:(PFObject*)saveObj;

@end
