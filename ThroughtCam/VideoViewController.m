//
//  VideoViewController.m
//  ThroughtCam
//
//  Created by iVanea! on 5/3/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import "VideoViewController.h"
#import "ASyncURLConnection.h"
#import <QuartzCore/QuartzCore.h>
#import "VideoPlayerViewController.h"


@interface VideoViewController (){
    UIBarButtonItem *buttonResize;
    VideoPlayerViewController *player;
}
@property (nonatomic, retain) VideoPlayerViewController *myPlayerViewController;

@end

@implementation VideoViewController
@synthesize myPlayerViewController = _myPlayerViewController;

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
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    buttonResize = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_resize-1.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(functionResize:)];
    [self.navigationItem setRightBarButtonItem:buttonResize animated:NO];
    
    _imageView = [[MotionJpegImageView alloc]init];
    [_imageView.layer setCornerRadius:10.0];
    viewStatistic.layer.cornerRadius = 10.0;
                                 
    scroolView = [[UIScrollView alloc] init];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    scroolView.delegate = self;
    scroolView.scrollEnabled = YES;
    [self.view addSubview:scroolView];
    [self.view insertSubview:viewStatistic aboveSubview:scroolView];
    [self.view insertSubview: viewStatistic aboveSubview:player.view];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (IS_IPAD) {
        self.view.frame = scroolView.frame = CGRectMake(0, 0, 768, 911);
        if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
            _imageView.frame = player.view.frame = CGRectMake(0, 0, 768, 600);
            [spinner setCenter:CGPointMake(384.0f, 384.0f)];
            scroolView.frame = CGRectMake(0, 0, 768, self.view.frame.size.height);
        }
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
            [spinner setCenter:CGPointMake(512.0f, 384.0f)];
            
            _imageView.center = CGPointMake(384.0f, 512.0f);
            [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
            _imageView.frame = player.view.frame = CGRectMake(0, 0, 1024, 768);
            [scroolView setFrame:CGRectMake(0, 0, 1024, 768)];
            viewStatistic.hidden = YES;
        }
    }else{
        if (isFourInch) {
            self.view.frame = scroolView.frame = CGRectMake(0, 0, 320, 568);
            if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 320, 284);
                [spinner setCenter:CGPointMake(160.0f, 160.0f)];
                scroolView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            }
            if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
                [spinner setCenter:CGPointMake(284.0f, 160.0f)];
                
                _imageView.center = CGPointMake(160, 284);
                [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 568, 350);
                [scroolView setFrame:CGRectMake(0, 0, 568, 320)];
                viewStatistic.hidden = YES;
            }
        }else{
            self.view.frame = scroolView.frame = CGRectMake(0, 0, 320, 480);
            if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 320, 240);
                [spinner setCenter:CGPointMake(160.0f, 160.0f)];
                scroolView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            }
            
            if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
                [spinner setCenter:CGPointMake(240.0f, 120.0f)];
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 480, 350);
                scroolView.frame = CGRectMake(0, 0, self.view.frame.size.height, 320);
                viewStatistic.hidden = YES;
            }
            
        }
    }
    
    [scroolView addSubview:spinner];
    [scroolView addSubview:_imageView];
    [scroolView addSubview:player.view];
    [spinner startAnimating];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}



- (void)functionRefresh
{
    NSURL *url = [NSURL URLWithString:linkSave];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
        _imageView.frame = player.view.frame = CGRectMake(0, 0, 320, 240);
    }
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
        _imageView.frame = player.view.frame = CGRectMake(0, 0, 480, 350);
        viewStatistic.hidden = YES;
    }
    
    if ([linkSave rangeOfString:@".m3u8"].location!=NSNotFound) {
        player = [[VideoPlayerViewController alloc] init];
        player.URL = url;
       
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
             player.view.frame = CGRectMake(0, 0, 320, 240);
        }
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
            player.view.frame = CGRectMake(0, 0, 480, 350);
        }
        [scroolView addSubview:player.view];
        self.myPlayerViewController = player;
        
    }
    else{

    _imageView.url = url;
    [scroolView addSubview:_imageView];
    [self.view addSubview:viewStatistic];
        [self.view insertSubview:viewStatistic aboveSubview:scroolView];
    [scroolView isZooming];
    
    [_imageView play];
    
    }

    
}


- (IBAction)functionResize:(id)sender{
    if (allSize) {
        [buttonResize setImage:[UIImage imageNamed:@"btn_resize-1.png"]];
        [spinner stopAnimating];                                                                                                                            
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {
            if (IS_IPAD) {
                [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 768, 600);
                [scroolView setFrame:CGRectMake(0, 0, 768, 990)];
            }else{
                if (isFourInch) {
                    [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                    _imageView.frame = player.view.frame = CGRectMake(0, 0, 320, 240);
                    [scroolView setFrame:CGRectMake(0, 0, 320, 568)];
                }else{
                    _imageView.frame = player.view.frame = CGRectMake(0, 0, 320, 240);
                    [spinner setCenter:CGPointMake(160.0f, 160.0f)];
                    scroolView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
                    [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                }
            }
            viewStatistic.hidden = NO;
        }
        
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
            if (IS_IPAD) {
                _imageView.center = CGPointMake(384, 512);
                [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 1024, 768);
                [scroolView setFrame:CGRectMake(0, 0, 1024, 768)];
            }else{
                if (isFourInch) {
                    _imageView.center = CGPointMake(150, 284);
                    [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                    _imageView.frame = player.view.frame = CGRectMake(0, 0, 568, 350);
                    [scroolView setFrame:CGRectMake(0, 0, 568, 320)];
                }else{
                    _imageView.frame = player.view.frame = CGRectMake(0, 0, 480, 350 );
                    [spinner setCenter:CGPointMake(240.0f, 120.0f)];
                    scroolView.frame = CGRectMake(0, 0, self.view.frame.size.width, 320);
                    [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                }
            }
        }
    }else{
        if (_imageView.image.size.width >= _imageView.frame.size.width || [linkSave rangeOfString:@".m3u8"].location!=NSNotFound) {
            [buttonResize setImage:[UIImage imageNamed:@"btn_resize_-1.png"]];
            [scroolView setContentSize:_imageView.image.size];
            
            if ([linkSave rangeOfString:@".m3u8"].location!=NSNotFound) {
                [scroolView setContentSize:CGSizeMake(1280, 720)];
                player.view.frame = CGRectMake(0, 0, 1280, 720);
            }else{
                _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
            }
            viewStatistic.hidden = YES;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Denied" message:@"Video cannot be resized, because its quality is worse." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil,  nil];
            alert.delegate = self;
            [alert show];
        }
    }
    allSize = !allSize;
}

- (void)functionSendVideoString:(NSString *)strLink Name:(NSString *)strName Location:(NSString *)strLocation Id:(NSString *)strId Like:(NSInteger)like Dislike:(NSInteger)dislike Stars:(float)stars
{
    linkSave = strLink;

    [self functionRefresh];
    
    labelNameCam.text = strName;
    labelCityOrState.text = strLocation;
    NSString *stringAccuracyLikes, *stringAccuracyDislikes;
    stringAccuracyLikes = @"Likes";
    stringAccuracyDislikes = @"Dislikes";
    
    if (like < 2) {
        stringAccuracyLikes = @"Like";
    }
    if (dislike < 2) {
        stringAccuracyDislikes = @"Dislike";
    }
    
    labelLikeOrDislike.text = [NSString stringWithFormat:@"%d %@/ %d %@",like,stringAccuracyLikes, dislike, stringAccuracyDislikes];
    
    
    //stars
    lik= like; dislik = dislike;
    if (like > 0 && dislike > 0) {
        progressRatio = like/dislike;
        if (progressRatio > 1) {
            progressRatio = 1-(double)dislike/like;
        }
    }else{
        if (like > 0 ) {
            progressRatio = 1;
        }
        if (dislike > 0) {
            progressRatio = 0;
        }
        
        if (like == 0 && dislike == 0) {
            progressRatio = 0.5;
            progressLike.hidden = YES;
            progessDead.hidden = NO;
        }
    }
   
    colorStar.frame = CGRectMake(colorStar.frame.origin.x, colorStar.frame.origin.y, 102*stars, 20);
    idCam = strId.integerValue;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSInteger coefPressedStatistic = [userDef integerForKey:[NSString stringWithFormat:@"statistic%d", idCam]];
    switch (coefPressedStatistic) {
        case 0:
            [buttonDown setImage:[UIImage imageNamed:@"dislike_"] forState:UIControlStateNormal];
            [buttonUP  setImage:[UIImage imageNamed:@"like_"] forState:UIControlStateNormal];
            break;
        case 1:
            [buttonDown setImage:[UIImage imageNamed:@"dislike_"] forState:UIControlStateNormal];
            [buttonUP  setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            break;
        case 2:
            [buttonDown setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
            [buttonUP  setImage:[UIImage imageNamed:@"like_"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    if (strId == 0 && [strLocation isEqual:@"-1"] && like == -1 && dislike == -1 && stars == -1) {
        [viewStatistic removeFromSuperview];
    }
    buttonDown.opaque = YES;

}

#pragma mark -
#pragma mark FUNCTIONS-ALERT

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self viewDidLoad];
    }
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    [progressLike setProgress:progressRatio animated:YES];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // video player
}

- (void) viewWillDisappear:(BOOL)animated{
    //NSLog(@"disappear");
    [spinner stopAnimating];
    [_imageView pause];
    [_imageView stop];
    [_imageView clear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    progessDead = nil;
    [super viewDidUnload];
}


#pragma mark -
#pragma mark ROTATION

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [buttonResize setImage:[UIImage imageNamed:@"btn_resize-1.png"]];
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ) {

        if (IS_IPAD) {
            [spinner setCenter:CGPointMake(self.view.frame.size.height/2+20, self.view.frame.size.width/2)];
            _imageView.center = CGPointMake(384.0f, 455.0f);
            [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
            _imageView.frame = player.view.frame = CGRectMake(0, 0, 1024, 768);
            [scroolView setFrame:CGRectMake(0, 0, 1024, 768)];
        }else{
            if (isFourInch) {
                _imageView.center = CGPointMake(150, 284);
                [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 568, 350);
                [scroolView setFrame:CGRectMake(0, 0, 568, 320)];
                [spinner setCenter:CGPointMake(self.view.frame.size.height/2+20, self.view.frame.size.width/2)];
            }else{
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 320, 240);
                [spinner setCenter:CGPointMake(160.0f, 160.0f)];
                scroolView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
                [scroolView setContentSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.width)];
            }
        }
        viewStatistic.hidden = NO;
    }
    
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
        if (IS_IPAD) {
            [spinner setCenter:CGPointMake(self.view.frame.size.height/2+20, self.view.frame.size.width/2 - 200)];
            _imageView.center = CGPointMake(384, 384);
            [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
            _imageView.frame = player.view.frame = CGRectMake(0, 0, 768, 600);
            [scroolView setFrame:CGRectMake(0, 0, 768, self.view.frame.size.height)];
        }else{
            if (isFourInch) {
                _imageView.center = CGPointMake(160.0, 160);
                [scroolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 320, 240);
                [scroolView setFrame:CGRectMake(0, 0, 320, 568)];
                [spinner setCenter:CGPointMake(self.view.frame.size.height/2+20, self.view.frame.size.width/2 - 200)];
            }else{
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 480, 350 );
                [spinner setCenter:CGPointMake(240.0f, 120.0f)];
                scroolView.frame = CGRectMake(0, 0, self.view.frame.size.width, 320);
                [scroolView setContentSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.width)];
            }
        }
    }

	if(toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        if (IS_IPAD) {
            
        }else{
            if (isFourInch) {
                
            }else{
                _imageView.frame = player.view.frame = CGRectMake(0, 0, 320, 240);
                [spinner setCenter:CGPointMake(160.0f, 160.0f)];
                scroolView.frame = CGRectMake(0, 0, 320, 568);
            }
        }
        viewStatistic.hidden = NO;
    
    }
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
	   toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        if (IS_IPAD) {
            
        }else{
            if (isFourInch) {
                
            }else{
                 _imageView.frame = player.view.frame = CGRectMake(0, 0, 480, 350 );
                [spinner setCenter:CGPointMake(240.0f, 120.0f)];
                scroolView.frame = CGRectMake(0, 0, 568, 320);
            }
        }
        viewStatistic.hidden = YES;
    }

}

#pragma mark -
#pragma mark ACTION

- (IBAction)actionUpDown:(id)sender {
    NSLog(@"UP DOWN ");
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    UIButton *button = (UIButton *)sender;
    NSData *dat = [userDef objectForKey:@"arrLike"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (dat!=NULL) {
        arr = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
    }
    NSInteger wasModificatedCoeficient  = [userDef integerForKey:[NSString stringWithFormat:@"statistic%d", idCam]];
    if (wasModificatedCoeficient == 0) {
    switch (button.tag) {
            case 1:
            {
                [userDef setInteger:1 forKey:[NSString stringWithFormat:@"statistic%d", idCam]];
                [buttonDown setImage:[UIImage imageNamed:@"dislike_"] forState:UIControlStateNormal];
                [buttonUP  setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                lik++;
                
                
                [arr addObject:@(idCam)];
                NSData *dataArr = [NSKeyedArchiver archivedDataWithRootObject:arr];
                [userDef setObject:dataArr forKey:@"arrLike"];
                
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cyberia.net.in/cameras/indexNew.php?up_id=%d",idCam]]];
                //NSLog(@"%@",data);
                
            }
                break;
            
            case 2:
            {
                [userDef setInteger:2 forKey:[NSString stringWithFormat:@"statistic%d", idCam]];
                [buttonDown setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                [buttonUP  setImage:[UIImage imageNamed:@"like_"] forState:UIControlStateNormal];
                dislik++;
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cyberia.net.in/cameras/indexNew.php?down_id=%d",idCam]]];
                //NSLog(@"%@",data);
                
            }
                break;
            default:
                break;
        }
    }
    else{
        switch (button.tag) {
            case 1:
            {
                if (wasModificatedCoeficient == 2) {
                    [userDef setInteger:1 forKey:[NSString stringWithFormat:@"statistic%d", idCam]];
                    [buttonDown setImage:[UIImage imageNamed:@"dislike_"] forState:UIControlStateNormal];
                    [buttonUP  setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cyberia.net.in/cameras/indexNew.php?forup_id=%d",idCam]]];
                    //NSLog(@"%@",data);
                    lik++;
                    dislik--;
                  
                        
                    [arr addObject:@(idCam)];
                    NSData *dataArr = [NSKeyedArchiver archivedDataWithRootObject:arr];
                    [userDef setObject:dataArr forKey:@"arrLike"];
                    
                }else
                {
                    [userDef setInteger:0 forKey:[NSString stringWithFormat:@"statistic%d", idCam]];
                    [buttonDown setImage:[UIImage imageNamed:@"dislike_"] forState:UIControlStateNormal];
                    [buttonUP  setImage:[UIImage imageNamed:@"like_"] forState:UIControlStateNormal];
                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cyberia.net.in/cameras/indexNew.php?noup_id=%d",idCam]]];
                    //NSLog(@"%@",data);
                    lik--;

                    [arr removeObject:@(idCam)];
                    NSData *dataArr = [NSKeyedArchiver archivedDataWithRootObject:arr];
                    [userDef setObject:dataArr forKey:@"arrLike"];
                    
                }
            }
                break;
                
            case 2:
            {
                if (wasModificatedCoeficient == 1) {
                    [userDef setInteger:2 forKey:[NSString stringWithFormat:@"statistic%d", idCam]];
                    [buttonDown setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                    [buttonUP  setImage:[UIImage imageNamed:@"like_"] forState:UIControlStateNormal];                
                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cyberia.net.in/cameras/indexNew.php?fordown_id=%d",idCam]]];
                    //NSLog(@"%@",data);
                    lik--;
                    dislik++;
                    
                    [arr removeObject:@(idCam)];
                    NSData *dataArr = [NSKeyedArchiver archivedDataWithRootObject:arr];
                    [userDef setObject:dataArr forKey:@"arrLike"];
                    
                }else
                {
                    [userDef setInteger:0 forKey:[NSString stringWithFormat:@"statistic%d", idCam]];
                    [buttonDown setImage:[UIImage imageNamed:@"dislike_"] forState:UIControlStateNormal];
                    [buttonUP  setImage:[UIImage imageNamed:@"like_"] forState:UIControlStateNormal];
                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cyberia.net.in/cameras/indexNew.php?nodown_id=%d",idCam]]];
                    //NSLog(@"%@",data);
                    dislik--;
                }
            }
                break;
            default:
                break;
        }
    }


        
    NSString *stringAccuracyLikes, *stringAccuracyDislikes;
    stringAccuracyLikes = @"Likes";
    stringAccuracyDislikes = @"Dislikes";
    
    if (lik < 2) {
        stringAccuracyLikes = @"Like";
    }
    if (dislik < 2) {
        stringAccuracyDislikes = @"Dislike";
    }
    [userDef synchronize];
    labelLikeOrDislike.text = [NSString stringWithFormat:@"%d %@/ %d %@",lik,stringAccuracyLikes, dislik, stringAccuracyDislikes];
    
    [self.delegate like];
    [spinner startAnimating];
    [self.view setUserInteractionEnabled:NO];
    [self functionConnectToServer:^(NSMutableArray *res){


    }];
    [spinner stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    if (lik > 0 && dislik > 0) {
        progressRatio = lik/dislik;
        if (progressRatio > 1) {
            progressRatio = 1-(double)dislik/lik;
            progressLike.hidden = NO;
            progessDead.hidden = YES;
        }
    }else{
        if (lik > 0 ) {
            progressRatio = 1;
        }
        if (dislik > 0) {
            progressRatio = 0;
        }
        progressLike.hidden = NO;
        progessDead.hidden = YES;
        if (lik == 0 && dislik == 0) {
            progressRatio = 0.5;
            progressLike.hidden = YES;
            progessDead.hidden = NO;
        }
    }
    [progressLike setProgress:progressRatio animated:YES];
}


- (void)functionConnectToServer:(void(^) (NSMutableArray* res))result
{
        [AsyncURLConnection request:@"http://cyberia.net.in/cameras/indexNew.php?all" completeBlock:^(NSData *data, NSString *url) {
            
            [data writeToFile:[documents stringByAppendingPathComponent:@"Cameras.plist"] atomically:YES];
            
        } errorBlock:^(NSError *error) {
            //NSLog(@"erro downoading : %@",[error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No server connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
            
        }];
}
@end

