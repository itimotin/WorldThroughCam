//
//  SecondViewController.h
//  ThroughtCam
//
//  Created by iVanea! on 5/3/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "StorageResource.h"
#import "DecryptManager.h"
@class FirstViewController;

@interface SecondViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate>{
    IBOutlet UISegmentedControl *segmentControll;
    IBOutlet UISegmentedControl *segmentControlPreview;
    BOOL isPreview;
    __weak IBOutlet UIView *mapTargetView;
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    GMSCameraPosition* camera;
    UIView *viewwithActivitiInd;
    UIActivityIndicatorView *spinner;
    NSMutableArray *arr;
    NSTimer *timer;
    Byte count;
    NSMutableDictionary *dictWithIndexes;
    Boolean isViewDidApear;
    BOOL skipThisMarker;
    DecryptManager *decript;
}
- (void)functionLoadingTime;
- (void)addMarkerInBounds:(GMSCoordinateBounds *)bounds dict:(NSDictionary *)dict;
- (IBAction)actionSegmentController:(id)sender;
- (IBAction)actionPreviewSegmentController:(id)sender;
- (void)functionIndicatorLoading;

@end
