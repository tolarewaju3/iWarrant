//
//  ViewImageController.m
//  iWarrantFree
//
//  Created by TiOluwa Olarewaju on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewImageController.h"

@interface ViewImageController ()

@end

@implementation ViewImageController
@synthesize product;
@synthesize imageField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([product receiptPicture]){
        NSLog(@"yes");
        [imageField setImage:[UIImage imageWithData:[product receiptPicture]]];
    }
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self  setImageField:nil];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
