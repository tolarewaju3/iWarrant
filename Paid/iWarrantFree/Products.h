//
//  Products.h
//  iWarrantFree
//
//  Created by TiOluwa Olarewaju on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Products : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) NSString * storePurchased;
@property (nonatomic, retain) NSString * purchaseDate;
@property (nonatomic, retain) NSData * receiptPicture;

@end
