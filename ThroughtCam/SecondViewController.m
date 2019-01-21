//
//  SecondViewController.m
//  ThroughtCam
//
//  Created by iVanea! on 5/3/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import "SecondViewController.h"
#import "JSONKit.h"
#import "ASyncURLConnection.h"
#import "VideoViewController.h"

@class GMSMarker;
@interface SecondViewController () {}
@end

@implementation SecondViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Map View", @"Map View");
        self.tabBarItem.image = [UIImage imageNamed:@"map_view"];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    decript = [DecryptManager sharedManager];
    dictWithIndexes = [[NSMutableDictionary alloc] init];
    // Create a GMSCameraPosition that tells the map to display the
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    [locationManager stopUpdatingLocation];
    
    float longitude=location.coordinate.longitude;
    float latitude=location.coordinate.latitude;

    
    camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    self.view = mapView_;
    
    
    isPreview = YES;
    
    
    // Do any additional setup after loading the view, typically from a nib
    
    segmentControlPreview.opaque =segmentControll.opaque= YES;
    // add on view
    [self functionIndicatorLoading];
    
    //adaugam target
    mapTargetView.frame = [UIScreen mainScreen].bounds;
    
    
    [self performSelector:@selector(addOnView) withObject:self afterDelay:.3];
    
    [spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        
        NSData *data2 = [NSData dataWithContentsOfFile:[documents stringByAppendingPathComponent:@"Cameras.plist"]];
        arr =  [data2 objectFromJSONData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            [viewwithActivitiInd setHidden:YES];
        });
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    segmentControll.alpha = segmentControlPreview.alpha = 0.6;
}


-(void)viewDidAppear:(BOOL)animated{
    //NSLog(@"didApear");
    for (UISegmentedControl *subview in [segmentControll subviews]) {
        
        if ([subview isSelected]){
            [subview setTintColor:[UIColor colorWithRed:88.0/255.0 green:115.0/255.0 blue:151.0/255.0 alpha:1.0]];
        }
        else{
            [subview setTintColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
        }
    }
    for (UISegmentedControl *subview in [segmentControlPreview subviews]) {
        
        if ([subview isSelected]){
            [subview setTintColor:[UIColor colorWithRed:88.0/255.0 green:115.0/255.0 blue:151.0/255.0 alpha:1.0]];
        }
        else{
            [subview setTintColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
        }
    }
    isViewDidApear = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //    [mapView_ clear];
    //    //NSLog(@"AICI E WARNING");
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    mapTargetView = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark FUNCTIONS


- (void)functionIndicatorLoading{
    viewwithActivitiInd = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 80)];
    viewwithActivitiInd.backgroundColor = [UIColor blackColor];
    [viewwithActivitiInd.layer  setCornerRadius:14];
    
    if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
        viewwithActivitiInd.center = CGPointMake(WIDTH/2, HEIGHT/2);
    }
    
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
        viewwithActivitiInd.center = CGPointMake(HEIGHT/2, WIDTH/2);
    }
    
    UILabel *labelLoad = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 55, 100, 20)];
    labelLoad.text = @"Loading...";
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


- (void)addOnView{
    // ADAUGA PE VIEW TOATE BUTOANELE
    [self.view addSubview:segmentControll];
    [self.view addSubview:segmentControlPreview];
    
    segmentControlPreview.opaque =segmentControll.opaque= YES;
    segmentControll.hidden = segmentControlPreview.hidden = NO;
    
    
    if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
        if (IS_IPAD) {
            segmentControll.frame = CGRectMake(269, 10, 231, 30);
            segmentControlPreview.frame = CGRectMake(292, 930, 185, 30);
        }else{
            if (isFourInch) {
                segmentControll.frame = CGRectMake(44, 10, 231, 30);
                segmentControlPreview.frame = CGRectMake(79, 480, 161, 30);
            }else{
                segmentControll.frame = CGRectMake(44, 10, 231, 30);
                segmentControlPreview.frame = CGRectMake(79, 390, 161, 30);
            }
        }
    }
    
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
        if (IS_IPAD) {
            segmentControll.center = CGPointMake(HEIGHT/2, 25);
            segmentControlPreview.center = CGPointMake(HEIGHT/2, 700);
        }else{
            segmentControll.center = CGPointMake(HEIGHT/2, 25);
            segmentControlPreview.center = CGPointMake(HEIGHT/2, 250);
        }
    }
    
    [self.view addSubview:segmentControll];
    [self.view addSubview:segmentControlPreview];
}

- (void)didTapAdd {
    GMSVisibleRegion region = [mapView_.projection visibleRegion];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithRegion:region];
    
    NSArray *array = [[StorageResource sharedManager] getCamerasForRegions:bounds.northEast sw:bounds.southWest];
    
    int i = 0, kount= 100;
    if (isPreview) {
        kount = 15;
    }
    for (NSDictionary *dict in array) {
        
        NSString *stringControl = [dictWithIndexes valueForKey:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
        if (dictWithIndexes.count <100) {
//            [self functionDownloadWithId:[dict objectForKey:@"id"]];
            if (i>kount) {
                break;
            }
            if (!stringControl) {
                [dictWithIndexes setValue:@"1" forKey:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
                i++;
                dispatch_time_t popTime =
                dispatch_time(DISPATCH_TIME_NOW,
                              (int64_t)(0.05*i * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self addMarkerInBounds:bounds dict:dict];
                });
            }
        }
    }
}

-(void)addMarkerInBounds:(GMSCoordinateBounds *)bounds dict:(NSDictionary *)dict{
    NSNumber *latitudeCam = [dict objectForKey:@"latitude"];
    NSNumber *longitudeCam = [dict objectForKey:@"longitude"];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitudeCam.floatValue, longitudeCam.floatValue);
    GMSMarker *optionsMarker = [GMSMarker markerWithPosition:position];
    optionsMarker.position = CLLocationCoordinate2DMake(latitudeCam.floatValue, longitudeCam.floatValue);
    NSString *stringNotNul = [dict objectForKey:@"city"];
    if (!stringNotNul || stringNotNul.length==0) {
        stringNotNul = [dict objectForKey:@"country"];
    }
    optionsMarker.title = stringNotNul;
    optionsMarker.snippet = [dict objectForKey:@"name"];
    optionsMarker.userData = [dict objectForKey:@"id"];
    optionsMarker.appearAnimation = kGMSMarkerAnimationPop;
    if (isPreview) {
        NSString *pathImg =[documents stringByAppendingString:[NSString stringWithFormat:@"/small_img/%@.jpg",[dict objectForKey:@"id"]]];
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathImg]];
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        optionsMarker.icon = img;
    }
    
    optionsMarker.map = mapView_;
    
}

- (void)functionLoadingTime{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self didTapAdd];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
        });
        
    });
    
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    if ([mapView.markers count]>99) {
        [mapView clear];
        [dictWithIndexes removeAllObjects];
    }
    if (isViewDidApear) {
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(functionLoadingTime) userInfo:nil repeats:NO];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    NSString *idMarker = marker.userData;
    
    __block NSMutableArray *arrayWithCameraData;
    [self functionGiveVideoWithId:idMarker.integerValue when:^(NSMutableArray *res) {
        arrayWithCameraData = res;
    }];
    NSDictionary *dict1 = [arrayWithCameraData objectAtIndex:0];
    
    NSString *idPhoto = [dict1 objectForKey:@"id"];
    NSString *stringWithNameCamera = [dict1 objectForKey:@"city"];
    if (stringWithNameCamera == (id)[NSNull null]) {
        stringWithNameCamera = [NSString stringWithFormat:@"Camera %@",idPhoto];
    }
    
    NSString *stringLocation = [dict1 objectForKey:@"country"];
    if (stringWithNameCamera == (id)[NSNull null]) {
        stringWithNameCamera = [NSString stringWithFormat:@"New %@",idPhoto];
    }
    
    NSString *strUrlVideo = [decript decryptString:[dict1 objectForKey:@"video"] key:KEY];
    //NSLog(@"Aista e Video %@", strUrlVideo);
    if (strUrlVideo.length == 0) {
        strUrlVideo = @"http://216.168.105.248:12122/axis-cgi/mjpg/video.cgi?camera=1";
    }
    
    NSNumber *star = [dict1 objectForKey:@"stars"];
    NSNumber *like = [dict1 objectForKey:@"like"];
    NSNumber *dislike = [dict1 objectForKey:@"dislike"];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
    VideoViewController *viewController = (VideoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"VideoController"];
    
    [viewController view]; // load view
    [viewController functionSendVideoString:strUrlVideo Name:stringWithNameCamera Location:stringLocation Id:idPhoto Like:like.integerValue Dislike:dislike.integerValue Stars:star.floatValue];
    viewController.title = stringWithNameCamera;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)functionGiveVideoWithId:(NSInteger)index when:(void(^) (NSMutableArray* res))result
{
    NSString *link = [NSString stringWithFormat:@"http://cyberia.net.in/cameras/indexNew.php?id=%d",index];
    
    [AsyncURLConnection request:link completeBlock:^(NSData *data, NSString *url) {
        result([data objectFromJSONData]);
    } errorBlock:^(NSError *error) {
        //NSLog(@"erro downoading : %@",[error description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No server connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    NSString *idMarker = marker.userData;
    
    __block NSMutableArray *arrayWithCameraData;
    [self functionGiveVideoWithId:idMarker.integerValue when:^(NSMutableArray *res) {
        arrayWithCameraData = res;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSDictionary *dict1 = [arrayWithCameraData objectAtIndex:0];
                ////NSLog(@"dict %@ \n", dict1);
                NSString *idPhoto = [dict1 objectForKey:@"id"];
                NSString *stringWithNameCamera = [dict1 objectForKey:@"city"];
                if (stringWithNameCamera == (id)[NSNull null]) {
                    stringWithNameCamera = [NSString stringWithFormat:@"Camera %@",idPhoto];
                }
                
                NSString *stringLocation = [dict1 objectForKey:@"country"];
                if (stringWithNameCamera == (id)[NSNull null]) {
                    stringWithNameCamera = [NSString stringWithFormat:@"New %@",idPhoto];
                }
                
                NSString *strUrlVideo = [decript decryptString:[dict1 objectForKey:@"video"] key:KEY];
                ////NSLog(@"Aista e Video %@", strUrlVideo);
                if (strUrlVideo.length == 0) {
                    strUrlVideo = @"http://216.168.105.248:12122/axis-cgi/mjpg/video.cgi?camera=1";
                }
                
                NSNumber *star = [dict1 objectForKey:@"stars"];
                NSNumber *like = [dict1 objectForKey:@"like"];
                NSNumber *dislike = [dict1 objectForKey:@"dislike"];
                
                if (IS_IPAD) {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
                    
                    VideoViewController *viewController = (VideoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"VideoController"];
                    [viewController view];//load View
//                    viewController.delegate =self;
                    [viewController functionSendVideoString:strUrlVideo Name:stringWithNameCamera Location:stringLocation Id:idPhoto Like:like.integerValue Dislike:dislike.integerValue Stars:star.floatValue];
                    viewController.title = stringWithNameCamera;
                    [self.navigationController pushViewController:viewController animated:YES];
                }else{
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
                    VideoViewController *viewController = (VideoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"VideoController"];
                    [viewController view];//load View
//                    viewController.delegate =self;
                    [viewController functionSendVideoString:strUrlVideo Name:stringWithNameCamera Location:stringLocation Id:idPhoto Like:like.integerValue Dislike:dislike.integerValue Stars:star.floatValue];
                    viewController.title = stringWithNameCamera;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
               
 
            });
        });
    }];
    return YES;
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionSegmentController:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            mapView_.mapType = kGMSTypeNormal;
            break;
        case 1:
            mapView_.mapType = kGMSTypeSatellite;
            break;
        case 2:
            mapView_.mapType = kGMSTypeHybrid;
            break;
        default:
            break;
    }
    
    for (UISegmentedControl *subview in [segmentControll subviews]) {
        if ([subview isSelected]){
            [subview setTintColor:[UIColor colorWithRed:88.0/255.0 green:115.0/255.0 blue:151.0/255.0 alpha:1.0]];
        }
        else{
            [subview setTintColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
            
        }
    }
}

- (IBAction)actionPreviewSegmentController:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
            isPreview = YES;
            break;
        case 1:
            isPreview= NO;
            break;
        default:
            break;
    }
    [mapView_ clear];
    [dictWithIndexes removeAllObjects];
    [self functionLoadingTime ];
    for (UISegmentedControl *subview in [segmentControlPreview subviews]) {
        
        if ([subview isSelected]){
            [subview setTintColor:[UIColor colorWithRed:88.0/255.0 green:115.0/255.0 blue:151.0/255.0 alpha:1.0]];
        }
        else{
            [subview setTintColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
            
        }
    }
}



#pragma mark -
#pragma mark ROTATION

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.height/2.0+25, self.view.bounds.size.width/2.0)];
    }
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [viewwithActivitiInd setCenter:CGPointMake(self.view.bounds.size.height/2.0+25, self.view.bounds.size.width/2.0)];
    }
}

@end