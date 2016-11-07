//
//  ViewController.h
//  PJPlaceNearBy1
//
//  Created by Mac on 06/11/16.
//  Copyright © 2016 Pragati Jawale. All rights reserved.
//

#define  kPlaceAPIKey @"AIzaSyDg8WffqMvskdPxe3gI_dofFlmn5xP_YLc"
#define kLatitude 18.516726
#define kLongitude 73.856255
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *placeTypes;
}
@property (strong, nonatomic) IBOutlet UITableView *tableViewPlaceType;


@end

