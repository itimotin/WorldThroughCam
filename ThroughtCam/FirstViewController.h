//
//  FirstViewController.h
//  ThroughtCam
//
//  Created by iVanea! on 5/3/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "VideoViewController.h"
#import "DecryptManager.h"

FOUNDATION_EXPORT NSString *const pathImage;
FOUNDATION_EXPORT NSString *const pathVideo;
FOUNDATION_EXPORT NSString *const pathInfo;
FOUNDATION_EXPORT NSString *const pathAll;
FOUNDATION_EXPORT NSString *const pathPhotos;


@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate, VideoViewControllerDelegate>
{
    IBOutlet UISearchBar *searchBarC;
    
    UITableView *tableViewWithCams;
    
    UIView *viewwithActivitiInd;
    UIActivityIndicatorView *spinner;
    
    NSMutableArray *arrayAll;
    NSMutableArray *arrayForFirstCams;
    
    IBOutlet UISegmentedControl *segmentControll;
    
    Reachability* internetReach;
    Reachability* wifiReach;
    BOOL isConnectionToWiFi;
    BOOL update;
    BOOL isLandscape, isAllocated;
    BOOL isSegmentSelected, boolChangeContains;
    NSInteger isSegmentNumber;
    NSInteger cameraIndexOnRow, indexRowforCamera;
    DecryptManager *decript;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarC;


- (IBAction)actionSegmentControll:(id)sender;

@property (nonatomic, strong) NSMutableArray *arrayWithDict;

- (void)functionAddAll;
- (void)functionWiFi;
- (void)functionTableDelegate;
- (void)functionAddTenCams;
- (NSMutableArray*)functionConnectToServerForSearching:(NSString *)searchStr;
- (void)functionIndicatorLoading;
- (void)functionHDCams;
- (void)functionUpdate;
- (void)functionShowLatest;

@end
