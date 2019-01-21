//
//  VideoViewController.h
//  ThroughtCam
//
//  Created by iVanea! on 5/3/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionJpegImageView.h"
#import <QuartzCore/QuartzCore.h>

@protocol VideoViewControllerDelegate <NSObject>

- (void)like;

@end


@interface VideoViewController : UIViewController<UIScrollViewAccessibilityDelegate, UIScrollViewDelegate, UIAlertViewDelegate>{
    NSString *linkSave;
    MotionJpegImageView *_imageView;
    UIActivityIndicatorView *spinner;
    UIButton *btn; // for resize
    UIScrollView *scroolView;
    BOOL allSize;
    IBOutlet UIView *viewStatistic;
    
    IBOutlet UILabel *labelNameCam;
    IBOutlet UILabel *labelCityOrState;
    IBOutlet UILabel *labelLikeOrDislike;
    
    IBOutlet UIProgressView *progressLike;
    
    IBOutlet UIButton *buttonUP;
    IBOutlet UIButton *buttonDown;

    IBOutlet UIView *colorStar;
    
    __weak IBOutlet UIProgressView *progessDead;
    double progressRatio;
    NSInteger idCam, lik, dislik;
}

@property (nonatomic, weak) id <VideoViewControllerDelegate> delegate;

- (IBAction)actionUpDown:(id)sender;

- (void)functionRefresh;
- (void)functionSendVideoString:(NSString *)strLink Name:(NSString*)strName Location:(NSString*)strLocation Id:(NSString*)strId Like:(NSInteger)like Dislike:(NSInteger)dislike Stars:(float) stars;
@end
