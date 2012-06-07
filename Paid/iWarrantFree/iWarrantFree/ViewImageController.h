//
//  ViewImageController.h
//  iWarrantFree
//
//  Created by TiOluwa Olarewaju on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Products.h"

@interface ViewImageController : UIViewController{
    
}

@property (strong, nonatomic) IBOutlet UIImageView *imageField;

@property (strong, nonatomic) Products *product;
@end
