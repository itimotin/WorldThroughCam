//
//  FourViewController.m
//  ThroughtCam
//
//  Created by 1111 on 6/5/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import "FourViewController.h"
#import "JSONKit.h"
#import "VideoViewController.h"
#import "AsyncImageView.h"
#import "ASyncURLConnection.h"



@interface FourViewController (){
    NSMutableArray *arrayAll;
    IBOutlet UITableView *tableViewLikes;

}

@end

@implementation FourViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (IS_IPAD){
    }else{
        if (isFourInch) {
            tableViewLikes.frame = CGRectMake(0, 0, 320, 400);
        }else{
            tableViewLikes.frame = CGRectMake(0, 0, 320, 400);
        }
    }
    [tableViewLikes setClipsToBounds:NO];
    decript = [DecryptManager sharedManager];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    tableViewLikes.userInteractionEnabled = NO;
	// Do any additional setup after loading the view.
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSData *dat = [userDef objectForKey:@"arrLike"];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    if (arr != NULL || arr.count != 0) {
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
        arrayAll = newArray;
        [tableViewLikes reloadData];        
        tableViewLikes.userInteractionEnabled = YES;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"You don't have liked cameras." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert show];
        tableViewLikes.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayAll.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        //create new cell
    int i = 10;
    if (IS_IPAD) {
        i = 45;
    }
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"] ;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //common settings
        cell.selectionStyle = UITableViewCellSelectionStyleGray; // cind tap pe cell schimba culoarea
		cell.indentationWidth = 76.0f;
		cell.indentationLevel = 1;
		//add AsyncImageView to cell
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(i+10.0f, 10.0f, 82.0f, 54.0f)];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		imageView.tag = IMAGE_VIEW_TAG;
		[cell addSubview:imageView];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(i+100.0f, 10.0f, 150.0f, 20.0f)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.tag = TAGLabelName;
        lblName.contentMode = UIViewContentModeScaleAspectFill;
		lblName.clipsToBounds = YES;
        [cell addSubview:lblName];
        
        UILabel *lblCity = [[UILabel alloc] initWithFrame:CGRectMake(i+100.0f, 25.0f, 150.0f, 20.0f)];
        lblCity.backgroundColor = [UIColor clearColor];
        lblCity.tag = TAGLabelCountry;
        lblCity.contentMode = UIViewContentModeScaleAspectFill;
		lblCity.clipsToBounds = YES;
        [cell addSubview:lblCity];
        
        UILabel *lblLikes = [[UILabel alloc] initWithFrame:CGRectMake(i+200.0f, 40.0f, 120.0f, 20.0f)];
        lblLikes.backgroundColor = [UIColor clearColor];
        lblLikes.tag = TAGLabelLike;
        lblLikes.contentMode = UIViewContentModeScaleAspectFill;
		lblLikes.clipsToBounds = YES;
        [cell addSubview:lblLikes];

        UIView *viewForStars = [[UIView alloc]initWithFrame:CGRectMake(i+110.0, 45.0, 51, 10)];
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

    NSDictionary *dict = [arrayAll objectAtIndex:indexPath.row];
    NSNumber *stars = [dict objectForKey:@"stars"];
    viewColor.frame = CGRectMake(viewColor.frame.origin.x, viewColor.frame.origin.y, stars.floatValue*50.8, 9.8);
    
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
	
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    //load image
    imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cyberia.net.in/cameras/thumbs/%d.jpg",idPhoto.intValue]];
    return cell;
}


- (void)functionGiveVideoWithId:(NSInteger)index when:(void(^) (NSMutableArray* res))result
{
    NSString *link = [NSString stringWithFormat:@"http://cyberia.net.in/cameras/indexNew.php?id=%d", index];
    
    [AsyncURLConnection request:link completeBlock:^(NSData *data, NSString *url) {
        result([data objectFromJSONData]);
    } errorBlock:^(NSError *error) {
        NSLog(@"erro downoading : %@",[error description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No server connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [arrayAll objectAtIndex:indexPath.row];
    NSString *idPhoto = [dict objectForKey:@"id"];
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
                
                
                if (IS_IPAD) {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
                    
                    VideoViewController *viewController = (VideoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"VideoController"];
                    [viewController view];//load View
                    [viewController functionSendVideoString:strUrlVideo Name:stringWithNameCamera Location:stringLocation Id:idPhoto Like:like.integerValue Dislike:dislike.integerValue Stars:star.floatValue];
                    viewController.title = stringWithNameCamera;
                    [self.navigationController pushViewController:viewController animated:YES];
                }else{
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
                    VideoViewController *viewController = (VideoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"VideoController"];
                    [viewController view];//load View
                    [viewController functionSendVideoString:strUrlVideo Name:stringWithNameCamera Location:stringLocation Id:idPhoto Like:like.integerValue Dislike:dislike.integerValue Stars:star.floatValue];
                    viewController.title = stringWithNameCamera;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
            });
        });
    }];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)viewDidUnload {
    tableViewLikes = nil;
    tableViewLikes = nil;
    [super viewDidUnload];
}
@end
