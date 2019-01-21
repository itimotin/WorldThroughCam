//
//  ThirdViewController.m
//  ThroughtCam
//
//  Created by iVanea! on 5/15/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import "ThirdViewController.h"
#import "Camera.h"
#import "AsyncImageView.h"
#import "ASyncURLConnection.h"
#import "CameraCell.h"
#import "VideoViewController.h"
#import "JSONKit.h"
#import "Reachability.h"
NSString *const pathType = @"http://cyberia.net.in/cameras/indexNew.php?typeCamera=";
@interface ThirdViewController (){
    Reachability* internetReach;
    Reachability* wifiReach;
    BOOL isConnectionToWiFi;
}

@end

@implementation ThirdViewController

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
    tableViewMyCams.delegate = self;
    if (IS_IPAD) {
        
    }
    else{
        if (isFourInch) {
            tableViewMyCams.frame = CGRectMake(10, 10, 300, 548);
        }else{
            tableViewMyCams.frame = CGRectMake(10, 10, 300, 460);
        }
    }
    decript = [DecryptManager sharedManager];
    [tableViewMyCams.layer setCornerRadius:10];
    
    
}


-(IBAction)barButtonAddPressed:(id)sender{
    //NSLog(@"add");
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"MY.plist"];
    
    NSMutableArray *plistDict = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
    return plistDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CameraCell *cell = (CameraCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 82.0f, 54.0f)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = 1000;
    [cell addSubview:imageView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"MY.plist"];
    
    NSMutableArray *plistDict = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
    
    NSDictionary *dict = [plistDict objectAtIndex:indexPath.row];
    cell.labelName.text = [dict objectForKey:@"name"];
    
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    //load image
    imageView.imageURL = [NSURL URLWithString:[dict objectForKey:@"img"]];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddCam"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		TableViewController *tableController = [[navigationController viewControllers] objectAtIndex:0];
		tableController.delegate = self;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"MY.plist"];
    
    NSMutableArray *plistDict = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
    
    NSDictionary *dict = [plistDict objectAtIndex:indexPath.row];
    
    NSString *strNameVideo = [dict objectForKey:@"name"];
    NSString *strUrlVideo = [dict objectForKey:@"video"];
    
    //NSLog(@"Aista e Video %@", strUrlVideo);
    if (strUrlVideo.length == 0) {
        strUrlVideo = @"http://216.168.105.248:12122/axis-cgi/mjpg/video.cgi?camera=1";
    }
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
    VideoViewController *viewController = (VideoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"VideoController"];
    //    viewController = [[VideoViewController alloc]init];
    [viewController view]; // load view
    [viewController functionSendVideoString:strUrlVideo Name:strNameVideo Location:@"-1" Id:0 Like:-1 Dislike:-1 Stars:-1];
    viewController.title = strNameVideo;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"MY.plist"];
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
        [arr removeObjectAtIndex:indexPath.row];
        
        [arr writeToFile:fullPath atomically:YES];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)functionConnectToServer:(NSString*)camType inThisArray:(void(^) (NSMutableArray* res))result
{
    NSString *clearPathCamType = [camType stringByReplacingOccurrencesOfString:@" " withString:@"%20"];// aceasta trebuie pentru a inlatura spatiile din link
    
    NSString *link = [NSString stringWithFormat:@"%@%@", pathType, clearPathCamType];
    //NSLog(@"LINK %@",link);
    [AsyncURLConnection request:link completeBlock:^(NSData *data, NSString *url) {
        result([data objectFromJSONData]);
        //            [[StorageResource sharedManager] addValuesToDB:[data objectFromJSONData]];
        
    } errorBlock:^(NSError *error) {
        //NSLog(@"erro downoading : %@",[error description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No server connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableViewControllerDidCancel:(TableViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}



- (void)tableViewController:(TableViewController *)controller didAddCamera:(Camera *)camera
{
    //partea mea
    [self functionWiFi];
    //NSLog(@"type camera %@", camera.typeCam);
    if (![self isInternetConnection]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error Wi-fi connection, please check your Wi-Fi connection." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert show];
    }else{
        __block NSMutableArray *mArrayWithParamsOnSite;
        [self functionConnectToServer:camera.typeCam inThisArray:^(NSMutableArray *res) {
            mArrayWithParamsOnSite = res;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                     (unsigned long)NULL), ^(void) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSMutableDictionary *dictPOnSite = [[mArrayWithParamsOnSite objectAtIndex:0] mutableCopy];
       
                    NSString *stringImage = [decript decryptString:[dictPOnSite objectForKey:@"img"] key:KEY];
                    NSString *stringVideo = [decript decryptString:[dictPOnSite objectForKey:@"video"] key:KEY];
     
                    //edit
                    NSString *stringUser;
                    if (camera.user.length == 0 ) {
                        stringUser =@"1";
                    }else{stringUser= camera.user;}
                    NSString *stringPass;
                    if (camera.pass.length == 0 ) {
                        stringPass =@"1";
                    }else{stringPass = camera.pass;}
                    
                    stringImage = [stringImage stringByReplacingOccurrencesOfString:@"${base}"
                                                                         withString:@"http://"];
                    stringImage = [stringImage stringByReplacingOccurrencesOfString:@"${host}"
                                                                         withString:camera.ipCam];
                    stringImage = [stringImage stringByReplacingOccurrencesOfString:@"${port}"
                                                                         withString:camera.portCam];
                    stringImage = [stringImage stringByReplacingOccurrencesOfString:@"${cameranumber}"
                                                                         withString:camera.numberCam];
                    stringImage = [stringImage stringByReplacingOccurrencesOfString:@"${base64user}"
                                                                         withString:stringUser];
                    stringImage = [stringImage stringByReplacingOccurrencesOfString:@"${base64pass}"
                                                                         withString:stringPass];
                    //video
                    stringVideo = [stringVideo stringByReplacingOccurrencesOfString:@"${base}"
                                                                         withString:@"http://"];
                    stringVideo = [stringVideo stringByReplacingOccurrencesOfString:@"${host}"
                                                                         withString:camera.ipCam];
                    stringVideo = [stringVideo stringByReplacingOccurrencesOfString:@"${port}"
                                                                         withString:camera.portCam];
                    stringVideo = [stringVideo stringByReplacingOccurrencesOfString:@"${cameranumber}"
                                                                         withString:camera.numberCam];
                    stringVideo = [stringVideo stringByReplacingOccurrencesOfString:@"${base64user}"
                                                                         withString:stringUser];
                    stringVideo = [stringVideo stringByReplacingOccurrencesOfString:@"${base64pass}"
                                                                         withString:stringPass];
                    //NSLog(@"IMG : %@ \n Video : %@ \n========================= ",stringImage, stringVideo);//edited
                    
                    
                    [dictPOnSite setObject:stringImage forKey:@"img"];
                    [dictPOnSite setObject:stringVideo forKey:@"video"];
                    [dictPOnSite setObject:camera.nameCam forKey:@"name"];
                    
             
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
                    NSString *documentsDir = [paths objectAtIndex:0];
                    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"MY.plist"];
                    NSMutableArray *dict = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
                    if (dict.count == 0 && dict == NULL) {
                        //NSLog(@"da");
                        dict = [[NSMutableArray alloc] init];
                    }
                    
                    [dict addObject:dictPOnSite];
                    
                    
                    
                    [dict writeToFile: fullPath  atomically:YES];
                    
                    ///////////////////////////////////////////////////////////////
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[dict count] - 1 inSection:0];
                    [tableViewMyCams insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    /////////////////////////////////////////

                });
            });
        }];
    }
}
#pragma mark -
#pragma mark WiFi CONNECTION

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
                //NSLog(@"Access Not Available");
                isConnectionToWiFi = NO;
                connectionRequired= NO;
                break;
            }
                
            case ReachableViaWWAN:
            {
                //NSLog(@"Reachable WWAN");
                isConnectionToWiFi = YES;
                break;
            }
            case ReachableViaWiFi:
            {
                //NSLog(@"Reachable WiFi");
                isConnectionToWiFi = YES;
                break;
            }
        }
        if(connectionRequired)
        {
            //NSLog(@"True Connection");
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


@end
