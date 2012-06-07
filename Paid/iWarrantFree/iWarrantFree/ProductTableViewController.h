//
//  ProductTableViewController.h
//  iWarrantFree
//
//  Created by TiOluwa Olarewaju on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "editProductViewController.h"
#import "CoreDataHelper.h"
#import "Products.h"

@interface ProductTableViewController : UITableViewController{

}
@property (strong, nonatomic) Products *selectedProduct;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *productListData;

- (void)readDataForTable;
@end
