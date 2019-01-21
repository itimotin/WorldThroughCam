//
//  FirstViewController.m
//  ThroughtCam
//
//  Created by iVanea! on 5/3/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import "FirstViewController.h"
#import "VideoViewController.h"
#import "AsyncImageView.h"
#import "ASyncURLConnection.h"
#import "JSONKit.h"
#import "StorageResource.h"
#import "SSZipArchive.h"

NSString *const pathImage = @"http://cyberia.net.in/cameras/1.php?resize=";
NSString *const pathVideo = @"http://cyberia.net.in/cameras/indexNew.php?id=";
NSString *const pathInfo = @"http://cyberia.net.in/cameras/indexNew.php?fotoId=";
NSString *const pathAll = @"http://cyberia.net.in/cameras/indexNew.php?all";
NSString *const pathPhotos = @"http://cyberia.net.in/cameras/small_img.zip";

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize arrayWithDict;
@synthesize searchBarC;

#pragma mark -
#pragma mark WiFi CONNECTION

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    
	if(curReach == wifiReach)
	{
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        BOOL connectionRequired= [curReach connectionRequired];
        switch (netStatus)
        {
            case NotReachable:
            {
                ////NSLog(@"Access Not Available");
                isConnectionToWiFi = NO;
                connectionRequired= NO;
                break;
            }
                
            case ReachableViaWWAN:
            {
                ////NSLog(@"Reachable WWAN");
                isConnectionToWiFi = YES;
                break;
            }
            case ReachableViaWiFi:
            {
                ////NSLog(@"Reachable WiFi");
                isConnectionToWiFi = YES;
                break;
            }
        }
        if(connectionRequired)
        {
            ////NSLog(@"True Connection");
        }
	}
	
}
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

- (void)functionWiFi{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    wifiReach = [Reachability reachabilityForLocalWiFi];
	[wifiReach startNotifier];
    [self updateInterfaceWithReachability: wifiReach];
}

#pragma mark -
#pragma mark INIT

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Live Cams", @"Live Cams ");
        self.tabBarItem.image = [UIImage imageNamed:@"live_cams"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(functionConection) name:@"wifi" object:nil];
    boolChangeContains = YES;
    isSegmentSelected = YES;
    if (IS_IPAD) {
        // tot e deja amplasat dupa aceaste marimi
    }else{
        if (isFourInch) {
            
        }else{
            self.view.frame = CGRectMake(0, 0, 320, 480);
        }
    }
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    isSegmentNumber = 0;
    [self.view setUserInteractionEnabled:NO];
    
    
    [self functionIndicatorLoading];
    decript = [DecryptManager sharedManager];
    // spinner is not visible until started
    [spinner startAnimating];
    if ([self isInternetConnection]) {
        isAllocated = NO;
        arrayForFirstCams = [[NSMutableArray alloc]init];
        
        //aici aray cu toate-camerele
        [self functionConnectToServer:^(NSMutableArray *res) {
            arrayAll = res;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                     (unsigned long)NULL), ^(void) {
                [self functionAddTenCams];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (IS_IPAD) {
                        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
                            tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 100.0, 736.0, self.view.bounds.size.height-150) style:UITableViewStylePlain];
                        }
                        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
                            tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 90.0, 992, self.view.bounds.size.height-100)style:UITableViewStylePlain];
                        }
                    }else{
                        if (isFourInch) {
                            if(isLandscape) {
                                tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 88.0, 538.0, self.view.bounds.size.height-153)style:UITableViewStylePlain];
                            }else {
                                tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 95.0, 290.0, self.view.bounds.size.height-175) style:UITableViewStylePlain];
                            }
                        }else{
                            if (!isLandscape) {
                                tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 88.0, 290.0, self.view.bounds.size.height-132) style:UITableViewStylePlain];
                            }else {
                                tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 88.0, 450.0, self.view.bounds.size.height-123) style:UITableViewStylePlain];
                            }
                        }
                    }
                    
                    tableViewWithCams.rowHeight = 75;
                    [tableViewWithCams.layer setCornerRadius:10];
                    
                    [self.view addSubview:tableViewWithCams];
                    [self functionTableDelegate];
                    
                    [self.view setUserInteractionEnabled:YES];
                    [spinner stopAnimating];
                    [viewwithActivitiInd setAlpha:0.0];
                });
            });
        }];
        
    }else{
        isAllocated = YES;
        [self.view setUserInteractionEnabled:YES];
        [spinner stopAnimating];
        [viewwithActivitiInd setAlpha:0.0];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error Wi-fi connection, please check your Wi-Fi connection." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refresh", nil];
        alert.delegate = self;
        [alert show];
    }
}

-(BOOL)isInternetConnection
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        return NO;
    }
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    if (isSegmentSelected && ver_float < 7 ) {
        isSegmentSelected = NO;
        for (UISegmentedControl *subview in [segmentControll subviews]) {
            if ([subview isSelected])
                [subview setTintColor:[UIColor colorWithRed:130.0/255.0 green:170.0/255.0 blue:250.0/255.0 alpha:1.0]];
            else
                [subview setTintColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:YES];
    if (IS_IPAD) {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
            tableViewWithCams.frame = CGRectMake(15.0, 100.0, 736.0, self.view.bounds.size.height-150);
        }
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
            tableViewWithCams.frame = CGRectMake(15.0, 90.0, 992.0, self.view.bounds.size.height-110);
        }
    }else{
        if (isFourInch) {
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
                tableViewWithCams.frame = CGRectMake(15.0, 95.0, 290.0, self.view.bounds.size.height-165);
            }else{
                tableViewWithCams.frame = CGRectMake(15.0, 88.0, 538.0, self.view.bounds.size.height-153);
            }
        }else{
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
                tableViewWithCams.frame = CGRectMake(15.0, 88.0, 290.0, self.view.bounds.size.height-132);
            }else{
                tableViewWithCams.frame = CGRectMake(15.0, 88.0, 450.0, self.view.bounds.size.height-123);
            }
        }
    }
    
}


#pragma mark -
#pragma mark ROTATION

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (IS_IPAD) {
        //        if(toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        //            [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.height/2.0+25, self.view.bounds.size.width/2.0)];
        //            tableViewWithCams.frame = CGRectMake(15.0, 95.0, 970.0, self.view.bounds.size.height-110);
        //            isLandscape = NO;
        //        }
        //
        //        if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        //           toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //            [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.height/2.0+25, self.view.bounds.size.width/2.0)];
        //            tableViewWithCams.frame = CGRectMake(15.0, 95.0, 735.0, self.view.bounds.size.height-150);
        //            isLandscape = YES;
        //        }
    }else{
        if (isFourInch) {
            if(toInterfaceOrientation == UIInterfaceOrientationPortrait) {
                [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.height/2.0+25, self.view.bounds.size.width/2.0)];
                tableViewWithCams.frame = CGRectMake(15.0, 95.0, 538.0, self.view.bounds.size.height-165);
                isLandscape = NO;
            }
            
            if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
               toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.height/2.0+25, self.view.bounds.size.width/2.0)];
                tableViewWithCams.frame = CGRectMake(15.0, 95.0, 290.0, self.view.bounds.size.height-153);
                isLandscape = YES;
            }
        }else{
        	if(toInterfaceOrientation == UIInterfaceOrientationPortrait) {
                [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.height/2.0+25, self.view.bounds.size.width/2.0)];
                tableViewWithCams.frame = CGRectMake(15.0, 88.0, 450.0, self.view.bounds.size.height-132);
                isLandscape = NO;
            }
            
            if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
               toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.height/2.0+25, self.view.bounds.size.width/2.0)];
                tableViewWithCams.frame = CGRectMake(15.0, 88.0, 290.0, self.view.bounds.size.height-123);
                isLandscape = YES;
            }
        }
    }
}


#pragma mark -
#pragma mark TABLE VIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    ////NSLog(@"table contains %d - rows" , arrayForFirstCams.count);
    return arrayForFirstCams.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        //create new cell
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //common settings
        cell.selectionStyle = UITableViewCellSelectionStyleGray; // cind tap pe cell schimba culoarea
		cell.indentationWidth = 76.0f;
		cell.indentationLevel = 1;
		//add AsyncImageView to cell
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 82.0f, 54.0f)];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		imageView.tag = IMAGE_VIEW_TAG;
		[cell addSubview:imageView];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 10.0f, 150.0f, 20.0f)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.tag = TAGLabelName;
        lblName.contentMode = UIViewContentModeScaleAspectFill;
		lblName.clipsToBounds = YES;
        [cell addSubview:lblName];
        
        UILabel *lblCity = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 25.0f, 150.0f, 20.0f)];
        lblCity.backgroundColor = [UIColor clearColor];
        lblCity.tag = TAGLabelCountry;
        lblCity.contentMode = UIViewContentModeScaleAspectFill;
		lblCity.clipsToBounds = YES;
        [cell addSubview:lblCity];
        
        UIView *viewForStars = [[UIView alloc]initWithFrame:CGRectMake(100.0, 45.0, 51, 10)];
        viewForStars.tag = TAGStars;
        viewForStars.backgroundColor = [UIColor clearColor];
        viewForStars.clipsToBounds = YES;
        [cell addSubview:viewForStars];
        UIView *viewColor = [[UIView alloc]  initWithFrame:CGRectMake(0.1, 0.1, 50.8, 9.8)];
        viewColor.tag = TAGColor;
        viewColor.backgroundColor = [UIColor orangeColor];
        [viewForStars addSubview:viewColor];
       
        UIView *viewColor1 = [[UIView alloc]  initWithFrame:CGRectMake(0.1, 0.1, 50.8, 9.8)];
        viewColor1.tag = TAGColor-1;
        viewColor1.backgroundColor = [UIColor grayColor];
        [viewForStars addSubview:viewColor1];
        [viewForStars insertSubview:viewColor1 belowSubview:viewColor];
        
        UIImageView *imgStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stars.png"]];
        imgStar.tag =  1;
        imgStar.frame = CGRectMake(0.0, 0.0, 51, 10);
        [viewForStars addSubview:imgStar];
        [viewForStars insertSubview:imgStar aboveSubview:viewColor];
        
        UILabel *lblLikes = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 40.0f, 120.0f, 20.0f)];
        lblLikes.backgroundColor = [UIColor clearColor];
        lblLikes.tag = TAGLabelLike;
        lblLikes.contentMode = UIViewContentModeScaleAspectFill;
		lblLikes.clipsToBounds = YES;
        [cell addSubview:lblLikes];
    }
    
    NSDictionary *dict = [arrayForFirstCams objectAtIndex:indexPath.row];
    NSNumber *stars = [dict objectForKey:@"stars"];
    UIView *imgStar = (UIView*)[cell viewWithTag:TAGColor];
    imgStar.frame = CGRectMake(imgStar.frame.origin.x, imgStar.frame.origin.y, stars.floatValue*50.8, 9.8);

    
//    ////NSLog(@"%@", [cell viewWithTag:1].description);
    
    NSString *idPhoto = [dict objectForKey:@"id"];
    
    NSString *stringName = [dict objectForKey:@"city"];
    UILabel *lbl = (UILabel *)[cell viewWithTag:TAGLabelName];
    if (stringName != (id)[NSNull null]) {
        lbl.text = [dict objectForKey:@"city"];
    }else{
        lbl.text = [NSString stringWithFormat:@"Camera %@",idPhoto];
    }
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:14];
    //OTHER label !!!!
    stringName = [dict objectForKey:@"country"];
    lbl = (UILabel *)[cell viewWithTag:TAGLabelCountry];
    if (stringName != (id)[NSNull null]) {
        lbl.text = [dict objectForKey:@"country"];
    }else{
        lbl.text = [NSString stringWithFormat:@"country %@",idPhoto];
    }
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = [UIColor grayColor];
    lbl.font = [UIFont fontWithName:@"Helvetica" size:10];
	//get image view
    NSInteger like = [[dict objectForKey:@"like"] integerValue];
    
    lbl = (UILabel *)[cell viewWithTag:TAGLabelLike];
    NSString *stringAccuracyLikes;
    stringAccuracyLikes = @"Likes";
    
    if (like < 2) {
        stringAccuracyLikes = @"Like";
    }
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = [UIColor grayColor];
    lbl.font = [UIFont fontWithName:@"Helvetica" size:10];
    lbl.text = [NSString stringWithFormat:@"%02d %@",like ,stringAccuracyLikes];
    
	AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
	
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    //load image
    imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cyberia.net.in/cameras/thumbs/%d.jpg",idPhoto.intValue]];
    return cell;
    
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row+1 == arrayForFirstCams.count && arrayForFirstCams.count != arrayAll.count) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            [self functionAddTenCams];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
        });
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [arrayForFirstCams objectAtIndex:indexPath.row];
    indexRowforCamera = indexPath.row;
    NSString *idPhoto = [dict objectForKey:@"id"];
    cameraIndexOnRow = idPhoto.integerValue;
    NSString *stringWithNameCamera = [dict objectForKey:@"city"];
    if (stringWithNameCamera == (id)[NSNull null]) {
        stringWithNameCamera = [NSString stringWithFormat:@"Camera %@",idPhoto];
    }
    
    NSString *stringLocation = [dict objectForKey:@"country"];
    if (stringWithNameCamera == (id)[NSNull null]) {
        stringWithNameCamera = [NSString stringWithFormat:@"New %@",idPhoto];
    }
    
    __block NSMutableArray *arrayWithCameraData;
    [self functionGiveVideoWithId:idPhoto.integerValue when:^(NSMutableArray *res) {
        arrayWithCameraData = res;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSDictionary *dict1 = [arrayWithCameraData objectAtIndex:0];
               
               NSString *strUrlVideo = [decript decryptString:[dict1 objectForKey:@"video"] key:KEY];
                
                if (strUrlVideo.length == 0) {
                    strUrlVideo = @"http://216.168.105.248:12122/axis-cgi/mjpg/video.cgi?camera=1";
                }
                
                NSNumber *star = [dict1 objectForKey:@"stars"];
                NSNumber *like = [dict1 objectForKey:@"like"];
                NSNumber *dislike = [dict1 objectForKey:@"dislike"];
                
                UIStoryboard *mainStoryboard;
                if (IS_IPAD) {
                    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
                }else{
                    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
                }
                VideoViewController *viewController = (VideoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"VideoController"];
                [viewController view];//load View
                viewController.delegate =self;
                [viewController functionSendVideoString:strUrlVideo Name:stringWithNameCamera Location:stringLocation Id:idPhoto Like:like.integerValue Dislike:dislike.integerValue Stars:star.floatValue];
                viewController.title = stringWithNameCamera;
                [self.navigationController pushViewController:viewController animated:YES];
            });
        });
    }];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return YES;
}

#pragma mark -
#pragma mark ACTIONS

- (IBAction)actionSegmentControll:(id)sender {
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    [tableViewWithCams scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    viewwithActivitiInd.hidden = NO;
    [spinner startAnimating];
    tableViewWithCams.userInteractionEnabled = NO;
    if (ver_float < 7) {
        for (UISegmentedControl *subview in [segmentControll subviews]) {
            if ([subview isSelected])
                [subview setTintColor:[UIColor colorWithRed:130.0/255.0 green:170.0/255.0 blue:250.0/255.0 alpha:1.0]];
            else
                [subview setTintColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
    }
    if (segmentControll.selectedSegmentIndex == 0)   {
        //ALL
        if (segmentControll.selectedSegmentIndex != isSegmentNumber) {//control pentru nerepetare de 2 ori
            
            isSegmentNumber = segmentControll.selectedSegmentIndex;
            [self functionAddAll];
        }
    }else{
        //FullHD
        if (segmentControll.selectedSegmentIndex == 1) {
            if (segmentControll.selectedSegmentIndex != isSegmentNumber) {
                
                isSegmentNumber = segmentControll.selectedSegmentIndex;
                [self functionHDCams];
            }
        }else{
            //MyLikes
            if (segmentControll.selectedSegmentIndex != isSegmentNumber) {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                
                NSData *dat = [userDef objectForKey:@"arrLike"];
                NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
                NSMutableArray *newArray = [[NSMutableArray alloc] init];
                if (arr != NULL || arr.count != 0) {
                    isSegmentNumber = segmentControll.selectedSegmentIndex;
                    NSData *data2 = [NSData dataWithContentsOfFile:[documents stringByAppendingPathComponent:@"Cameras.plist"]];
                    arrayAll =  [data2 objectFromJSONData];
                    for (NSNumber *num in arr) {
                        for (NSDictionary *dict in arrayAll) {
                            NSString *camId = [dict objectForKey:@"id"];
                            if (camId.integerValue == num.integerValue) {
                                [newArray addObject:dict];
                            }
                        }
                    }
                    
                    arrayAll = nil;
                    [arrayForFirstCams removeAllObjects];
                    arrayAll = newArray;
                    
                    [self functionAddTenCams];
                    [tableViewWithCams scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                    [tableViewWithCams reloadData];
                    viewwithActivitiInd.hidden = YES;
                    [spinner stopAnimating];
                    tableViewWithCams.userInteractionEnabled = YES;
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"You don't have liked cameras." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    alert.delegate = self;
                    [alert show];
                    viewwithActivitiInd.hidden = YES;
                    [spinner stopAnimating];
                    tableViewWithCams.userInteractionEnabled = YES;
                }
                
            }
            
        }
        
    }
    
}
#pragma mark -
#pragma mark FUNCTIONS-ALERT

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self viewDidLoad];
    }
    
}



#pragma mark -
#pragma mark FUNCTIONS


- (void)like{
    update = YES;
    [self functionUpdate];
}

- (void)functionShowLatest{
    [spinner startAnimating];
    [viewwithActivitiInd setAlpha:0.6];
    [self.view setUserInteractionEnabled:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        
        NSData *data2 = [NSData dataWithContentsOfFile:[documents stringByAppendingPathComponent:@"Cameras.plist"]];
        arrayAll =  [data2 objectFromJSONData];
        [arrayForFirstCams removeAllObjects];
        [self functionAddTenCams];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableViewWithCams scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            [tableViewWithCams reloadData];
            [self.view setUserInteractionEnabled:YES];
            [spinner stopAnimating];
            [viewwithActivitiInd setAlpha:0.0];
            viewwithActivitiInd.hidden = YES;
            [spinner stopAnimating];
            tableViewWithCams.userInteractionEnabled = YES;
        });
        
    });
    
}

- (void)functionConection{
    if ([self isInternetConnection] && isAllocated) {
        arrayForFirstCams = [[NSMutableArray alloc]init];
        isAllocated = NO ;
        //aici aray cu toate-camerele
        [self functionConnectToServer:^(NSMutableArray *res) {
            arrayAll = res;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                     (unsigned long)NULL), ^(void) {
                [self functionAddTenCams];
                
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (IS_IPAD) {
                        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
                            tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 100.0, 736.0, self.view.bounds.size.height-150) style:UITableViewStylePlain];
                        }
                        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
                            tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 90.0, 992, self.view.bounds.size.height-100)style:UITableViewStylePlain];
                        }
                    }else{
                        if (isFourInch) {
                            if(isLandscape) {
                                tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 88.0, 538.0, self.view.bounds.size.height-123)style:UITableViewStylePlain];
                            }else{
                                tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 95.0, 290.0, self.view.bounds.size.height-145) style:UITableViewStylePlain];
                            }
                        }else{
                            if (!isLandscape) {
                                tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 88.0, 290.0, self.view.bounds.size.height-132) style:UITableViewStylePlain];
                            }else{
                                tableViewWithCams = [[UITableView alloc] initWithFrame:CGRectMake(15.0, 88.0, 450.0, self.view.bounds.size.height-123) style:UITableViewStylePlain];
                            }
                        }
                    }
                    
                    
                    
                    tableViewWithCams.rowHeight = 75;
                    [tableViewWithCams.layer setCornerRadius:10];
                    
                    [self.view addSubview:tableViewWithCams];
                    [self functionTableDelegate];
                    
                    [self.view setUserInteractionEnabled:YES];
                    [spinner stopAnimating];
                    [viewwithActivitiInd setAlpha:0.0];
                });
                
            });
            
        }];
    }
}

- (void)functionAddAll{
    [spinner startAnimating];
    [viewwithActivitiInd setAlpha:0.6];
    [self.view setUserInteractionEnabled:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        
        NSData *data2 = [NSData dataWithContentsOfFile:[documents stringByAppendingPathComponent:@"Cameras.plist"]];
        arrayAll =  [data2 objectFromJSONData];
        [arrayForFirstCams removeAllObjects];
        [self functionAddTenCams];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableViewWithCams scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            [tableViewWithCams reloadData];
            [self.view setUserInteractionEnabled:YES];
            [spinner stopAnimating];
            [viewwithActivitiInd setAlpha:0.0];
            viewwithActivitiInd.hidden = YES;
            [spinner stopAnimating];
            tableViewWithCams.userInteractionEnabled = YES;
        });
        
    });
}


- (void)functionHDCams{
    [spinner startAnimating];
    [viewwithActivitiInd setAlpha:0.6];
    [self.view setUserInteractionEnabled:NO];
    //    [self.view insertSubview:tableViewWithCams belowSubview:viewwithActivitiInd];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        
        NSData *data2 = [NSData dataWithContentsOfFile:[documents stringByAppendingPathComponent:@"Cameras.plist"]];
        arrayAll =  [data2 objectFromJSONData];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i=0; i < arrayAll.count; i++) {
            NSDictionary *dictTemp = [arrayAll objectAtIndex:i];
            NSString *hd = [dictTemp objectForKey:@"hd"];
            
            if ([hd isEqual:@"1"]) {
                [arr addObject:[arrayAll objectAtIndex:i]];
            }
        }
        [arrayForFirstCams removeAllObjects];
        arrayAll = nil;
        arrayAll = arr;
        [self functionAddTenCams];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableViewWithCams scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            [tableViewWithCams reloadData];
            [self.view setUserInteractionEnabled:YES];
            [spinner stopAnimating];
            [viewwithActivitiInd setAlpha:0.0];
            viewwithActivitiInd.hidden = YES;
            [spinner stopAnimating];
            tableViewWithCams.userInteractionEnabled = YES;
        });
        
    });
}

- (void)functionIndicatorLoading{
    viewwithActivitiInd = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 80)];
    viewwithActivitiInd.backgroundColor = [UIColor blackColor];
    [viewwithActivitiInd.layer  setCornerRadius:14];
    [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)];
    
    UILabel *labelLoad = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 55, 100, 20)]autorelease];
    labelLoad.text = @"loading...";
    [labelLoad  setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    labelLoad.textColor = [UIColor grayColor];
    labelLoad.textAlignment = NSTextAlignmentCenter;
    labelLoad.backgroundColor = [UIColor clearColor];
    [viewwithActivitiInd addSubview:labelLoad];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(viewwithActivitiInd.bounds.size.width/2.0, (viewwithActivitiInd.bounds.size.height/2.0)-10)]; // I do this because I'm in landscape mode
    
    [viewwithActivitiInd addSubview:spinner];
    [self.view addSubview:viewwithActivitiInd];
}


- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

- (void)functionGiveVideoWithId:(NSInteger)index when:(void(^) (NSMutableArray* res))result
{
    NSString *link = [NSString stringWithFormat:@"%@%d", pathVideo, index];
    
    [AsyncURLConnection request:link completeBlock:^(NSData *data, NSString *url) {
        result([data objectFromJSONData]);
    } errorBlock:^(NSError *error) {
        ////NSLog(@"erro downoading : %@",[error description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No server connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }];
    
}

- (void)functionConnectToServer:(void(^) (NSMutableArray* res))result
{
    NSData *dataSavedCamerasInPlist = [NSData dataWithContentsOfFile:[documents stringByAppendingPathComponent:@"Cameras.plist"]];
    NSArray *arrayPlist = [dataSavedCamerasInPlist objectFromJSONData];
    if (dataSavedCamerasInPlist && [arrayPlist count] && boolChangeContains) {
        result([dataSavedCamerasInPlist objectFromJSONData]);
    }
    else{
        [AsyncURLConnection request:pathAll completeBlock:^(NSData *data, NSString *url) {

            [data writeToFile:[documents stringByAppendingPathComponent:@"Cameras.plist"] atomically:YES];
            result([data objectFromJSONData]);
            [[StorageResource sharedManager] addValuesToDB:[data objectFromJSONData]];
           
            //Download
            [self functionDownloadImageInDocuments];
        } errorBlock:^(NSError *error) {
            NSLog(@"erro downoading : %@",[error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No server connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
        }];
    }
}

- (void)functionDownloadImageInDocuments{

        dispatch_time_t popTime =
        dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(0.2* NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [AsyncURLConnection request:pathPhotos completeBlock:^(NSData *data, NSString *url) {
                NSString *filePath = [documents stringByAppendingPathComponent:@"small.zip"]; //Add the file name
                [data writeToFile:filePath atomically:YES];
                NSLog(@"IMAGE saved path :%@",filePath);
                [self unzipFileWithPath:filePath];
            } errorBlock:^(NSError *error) {
                NSLog(@"some eeror on DFownload : %@",[error description]);
            }];
        });
}

- (void)unzipFileWithPath:(NSString*) pathZip{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [SSZipArchive unzipFileAtPath:pathZip toDestination:documents];
        NSLog(@"s-a Salvat");
    });
    
}


- (void)functionAddTenCams{
    int n = arrayForFirstCams.count+10;
    if (IS_IPAD) {
        n=n+5;
    }
    if (n> arrayAll.count){
        n= arrayAll.count;
    }
    for (int i = arrayForFirstCams.count; i< n; i++) {
        
        [arrayForFirstCams addObject:[arrayAll objectAtIndex:i]];
        
    }
}

- (void)functionUpdate{
    viewwithActivitiInd.hidden = NO;
    [spinner startAnimating];
    [tableViewWithCams setUserInteractionEnabled:NO];
    
    boolChangeContains = NO;
    [self functionGiveVideoWithId:cameraIndexOnRow when:^(NSMutableArray *res) {
        NSArray *arrayCurrent =  res;
        NSDictionary *dict = [arrayCurrent objectAtIndex:0];
        UITableViewCell   *cell =  [tableViewWithCams cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexRowforCamera inSection:0]];
        for (UILabel *label in cell.subviews) {
            if (label.tag == TAGLabelLike) {
                NSInteger like =[[dict objectForKey:@"like"] integerValue];
                NSString *stringAccuracyLikes;
                stringAccuracyLikes = @"Likes";
                
                if (like < 2) {
                    stringAccuracyLikes = @"Like";
                }
                label.textAlignment = NSTextAlignmentLeft;
                label.textColor = [UIColor grayColor];
                label.font = [UIFont fontWithName:@"Helvetica" size:10];
                label.text = [NSString stringWithFormat:@"%02d %@",like ,stringAccuracyLikes];
                
            }
        }
     NSNumber *stars = [dict objectForKey:@"stars"];
     UIView *imgStar = (UIView*)[cell viewWithTag:TAGColor];
     imgStar.frame = CGRectMake(imgStar.frame.origin.x, imgStar.frame.origin.y, stars.floatValue*50.8, 9.8);

        viewwithActivitiInd.hidden = YES;
        
        [spinner stopAnimating];
        [tableViewWithCams setUserInteractionEnabled:YES];
    }];
    
    
}


- (void)functionTableDelegate
{
    tableViewWithCams.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableViewWithCams.delegate = self;
    tableViewWithCams.dataSource = self;
}

#pragma mark -
#pragma mark SEARCH BAR

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    tableViewWithCams.allowsSelection = NO;
    tableViewWithCams.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    tableViewWithCams.allowsSelection = YES;
    tableViewWithCams.scrollEnabled = YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    NSArray* arrayTemp = [[NSArray alloc]init] ;
    
    arrayTemp = [self functionConnectToServerForSearching:searchBar.text];
    if (arrayTemp.count){
        [spinner startAnimating];
        [viewwithActivitiInd setAlpha:0.6];
        [self.view setUserInteractionEnabled:NO];
        [self.view insertSubview:tableViewWithCams belowSubview:viewwithActivitiInd];
        arrayAll = nil;
        [arrayForFirstCams removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            
            arrayAll = [NSMutableArray arrayWithArray:arrayTemp];
            
            [self functionAddTenCams];
            
            isSegmentNumber = -1;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [tableViewWithCams setContentOffset:CGPointZero animated:NO];
                [self.view setUserInteractionEnabled:YES];
                [spinner stopAnimating];
                [viewwithActivitiInd setAlpha:0.0];
                [tableViewWithCams reloadData];
            });
            
        });
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"We could not find your desired destination!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil , nil];
        alert.delegate = self;
        [alert show];
    }
    
    
    tableViewWithCams.allowsSelection = YES;
    tableViewWithCams.scrollEnabled = YES;
    searchBar.text = @"";
}



- (NSMutableArray*)functionConnectToServerForSearching:(NSString *)searchStr
{
    NSString *path1;
    path1= @"http://cyberia.net.in/cameras/indexNew.php?str=";
    NSString *clearPathSearch= [searchStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path1 = [path1 stringByAppendingFormat:@"%@",clearPathSearch];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path1] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
    if(connection) {
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                      path1]];
    
       
        arr = [data objectFromJSONData];
    } else {
        ////NSLog(@"connection failed");
    }
    return arr;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

