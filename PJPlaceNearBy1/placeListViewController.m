//
//  placeListViewController.m
//  PJPlaceNearBy1
//
//  Created by Mac on 07/11/16.
//  Copyright © 2016 Pragati Jawale. All rights reserved.
//

#import "placeListViewController.h"
#import "ViewController.h"
#import "PlaceDetailViewController.h"
#import "customTableViewCell.h"

@interface placeListViewController ()

@end

@implementation placeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    placeList =[[NSMutableArray alloc]init];
    
    if ([self.selectedPlaceType isEqualToString:@"ATM"]) {
        self.title = self.selectedPlaceType.uppercaseString;
    }
    else{
        self.title =self.selectedPlaceType.capitalizedString;
    }
    [self getPlaceListWithAPIKey:kPlaceAPIKey placeType:self.selectedPlaceType radius:1000 latitude:kLatitude longitude:kLongitude format:@"xml"];
    
    [self.tableViewPlaceList reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)getPlaceListWithAPIKey:(NSString *)key
                    placeType:(NSString *)type
                       radius:(int)radius
                     latitude:(double)latitude
                    longitude:(double)longitude
                       format:(NSString *)format
{
    NSString *urlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/%@?&key=%@&location=%f,%f&radius=%d&types=%@",format,key,latitude,longitude,radius,type];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *mySession =[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
        }
        else if (response){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode == 200) {
                if (data) {
                    parser = [[NSXMLParser alloc]initWithData:data];
                    parser.delegate =self;
                    [parser parse];
                }
            }
        }
    }];
    [task resume];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return placeList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
    
    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"place_cell"];
    
    NSMutableDictionary *tempDictionary = [placeList objectAtIndex:indexPath.row];
    //
    NSLog(@"%@",tempDictionary);
    //
    //
    NSString *address = [tempDictionary valueForKey:@"vicinity"];
    NSString *placeName = [tempDictionary valueForKey:@"name"];
    //
    //
    //
    //
    // //   cell.detailTextLabel.numberOfLines = 5;
    //  //  [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //
    cell.nameLabel.text = placeName;
    cell.addressLabel.text = address;
    //
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    placeDetailViewController *placeDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceDetailViewController"];
    
    NSDictionary *placeDic = [placeList objectAtIndex:indexPath.row];
    
    NSString *place_id = [placeDic valueForKey:@"place_id"];
    
    
    // placeDetailViewController.selectedPlaceID = place_id;
    
    [self.navigationController pushViewController:placeDetailViewController animated:YES];
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDic
{
    if ([elementName isEqualToString:@"result"]) {
        placeDictionary = [[NSMutableDictionary alloc]init];
    }
    else if ([elementName isEqualToString:@"name"]) {
        dataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"vicinity"]) {
        dataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"place_id"]) {
        dataString = [[NSMutableString alloc]init];
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    dataString = string;
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"result"]) {
        
        [placeList addObject:placeDictionary];
        
    }
    else if ([elementName isEqualToString:@"name"]) {
        
        [placeDictionary setValue:dataString forKey:@"name"];
        
    }
    else if ([elementName isEqualToString:@"vicinity"]) {
        
        [placeDictionary setValue:dataString forKey:@"vicinity"];
        
    }
    else if ([elementName isEqualToString:@"place_id"]) {
        
        [placeDictionary setValue:dataString forKey:@"place_id"];
        
    }
    else if([elementName isEqualToString:@"PlaceSearchResponse"]){
        
        
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
        
    }
}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"PARSE ERROR : %@",parseError.localizedDescription);
}
-(void)updateTableView{
    [self.tableViewPlaceList reloadData];
}



@end
