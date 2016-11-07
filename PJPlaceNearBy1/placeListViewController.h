//
//  placeListViewController.h
//  PJPlaceNearBy1
//
//  Created by Mac on 07/11/16.
//  Copyright © 2016 Pragati Jawale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface placeListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate>


{
    NSMutableArray *placeList;
    NSXMLParser *parser;
    NSString *dataString;
    NSMutableDictionary *placeDictionary;
}
@property NSString *selectedPlaceType;

@property (strong, nonatomic) IBOutlet UITableView *tableViewPlaceList;

@end
