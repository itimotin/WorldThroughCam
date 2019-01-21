//
//  TableViewController.m
//  ThroughtCam
//
//  Created by iVanea! on 5/14/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController (){
    NSMutableDictionary *arrayCamProfiles;
    NSMutableArray *array_index;
    NSArray *arr;
}
@property(nonatomic) BOOL showsSelectionIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
- (IBAction)actionDonePicker:(id)sender;
@end

@implementation TableViewController
@synthesize delegate, buttonDone;
@synthesize textFieldNameCam, textFieldNumberCam, textFieldIpCam, textFieldPort, buttonManufacture, textFieldPass, textFieldUser;

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

    
    
    textFieldNumberCam.delegate = self;
    textFieldNameCam.delegate = self;
    textFieldPort.delegate = self;
    textFieldIpCam.delegate = self;
    textFieldUser.delegate = textFieldPass.delegate = self;
    
    buttonDone.enabled = NO;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ListCams" ofType:@"plist"];
    NSMutableDictionary *listArray = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    array_index =[[NSMutableArray alloc]init];

   
    
    arrayCamProfiles = [listArray objectForKey:@"Camera Profiles"];
    for (NSString *str in arrayCamProfiles) {
        [array_index addObject:str];
    }
    arr = [array_index sortedArrayUsingSelector:
                   @selector(localizedCaseInsensitiveCompare:)];//ordonam crescator alphabetic
    ////NSLog(@"%@", arr);
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		[self.textFieldNameCam becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    tableViewGrouped.scrollEnabled = YES;
    buttonManufacture.enabled = YES;
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIView class]] && view.tag == 1000) {
            
            CGPoint newCenter = CGPointMake(160.0 ,self.view.frame.size.height+125);
            [UIView animateWithDuration: 1.0
                                  delay: 0.2
                                options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                             animations:^{view.center = newCenter ; }
                             completion:^(BOOL finished) {  }
             ];
            
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if ([textFieldNumberCam.text length]!=0 && textFieldNameCam.text.length!=0 && textFieldPort.text.length!=0 && textFieldIpCam.text.length!=0&&buttonManufacture.titleLabel.text.length!=0) {
        buttonDone.enabled = YES;
    }else{
        buttonDone.enabled=NO;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arr.count;
 }


- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{

}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arr objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    [thePickerView selectRow:row inComponent:0 animated:YES];
    [buttonManufacture setTitle:[arr objectAtIndex:row] forState:UIControlStateNormal];
    [buttonManufacture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonManufacture.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    //NSLog(@"button %@",buttonManufacture.titleLabel.text);
    if ([textFieldNumberCam.text length]!=0 && textFieldNameCam.text.length!=0 && textFieldPort.text.length!=0 && textFieldIpCam.text.length!=0&&buttonManufacture.titleLabel.text.length!=0) {
        buttonDone.enabled = YES;
    }else{
        buttonDone.enabled=NO;
    }      
}

- (IBAction)cancel:(id)sender
{
	[self.delegate tableViewControllerDidCancel:self];
}


- (IBAction)done:(id)sender{
    Camera *cam = [[Camera alloc] init];
	cam.nameCam = self.textFieldNameCam.text;
    cam.numberCam = self.textFieldNumberCam.text;
    cam.typeCam = buttonManufacture.titleLabel.text;
    //NSLog(@"%@",buttonManufacture.titleLabel.text);

    cam.user = self.textFieldUser.text;
    cam.pass = self.textFieldPass.text;
    cam.ipCam = self.textFieldIpCam.text;
    cam.portCam = self.textFieldPort.text;
    
	[self.delegate tableViewController:self didAddCamera:cam];
}

- (IBAction)actionManufactury:(id)sender {
    [textFieldIpCam resignFirstResponder];
    [textFieldPass resignFirstResponder];
    [textFieldUser resignFirstResponder];
    [textFieldPort resignFirstResponder];
    [textFieldNameCam resignFirstResponder];
    [textFieldNumberCam resignFirstResponder];
    
    for (UITableViewCell *cell in self.view.subviews) {
        if ([cell isKindOfClass:[UITableViewCell class]]){
            for (UITextField *textField in cell.subviews) {
                if ([textField isKindOfClass:[UITextField class]]) {
                    //NSLog(@"da este field");
                    [textField resignFirstResponder];
                }
            }
        }
    }
    
    
    tableViewGrouped.scrollEnabled = NO;
    buttonManufacture.enabled = NO;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 568, 320, 250)];
    if (IS_IPAD) {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            view.frame = CGRectMake(0, 1024, 768, 250);
        }
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            view.frame = CGRectMake(0, 768, 1024, 250);
        }
    }else{
        if (isFourInch) {
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                view.frame = CGRectMake(0, 320, 568, 250);
            }
        }else{
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                view.frame = CGRectMake(0, 320, 480, 250);
            }
        }
    }
    view.backgroundColor = [UIColor colorWithRed:88.0/255.0 green:115.0/255.0 blue:151.0/255.0 alpha:1.0];
    view.tag = 1000;
    
    UIPickerView *pickerWithNames = [[UIPickerView alloc]init];
    pickerWithNames.delegate = self;
    [pickerWithNames setFrame:CGRectMake(0, 40, 320, 216)];
    
    if (IS_IPAD) {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            pickerWithNames.frame = CGRectMake(0, 40, 768, 216);
        }
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            pickerWithNames.frame = CGRectMake(0, 40, 1024, 216);
        }
    }else{
        if (isFourInch) {
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                pickerWithNames.frame = CGRectMake(0, 40, 568, 216);
            }
        }else{
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                pickerWithNames.frame = CGRectMake(0, 40, 480, 216);
            }
        }
    }
    
    pickerWithNames.autoresizingMask =UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [pickerWithNames setTag:999];
    pickerWithNames.showsSelectionIndicator = YES;
    
    CGPoint newCenter = CGPointMake(160.0 ,self.view.frame.size.height-125);
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
   
    if (IS_IPAD) {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            navBar.frame = CGRectMake(0, 0, 768, 42);
            newCenter = CGPointMake(384.0 ,self.view.frame.size.height-125);
        }
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            navBar.frame = CGRectMake(0, 0, 1024, 42);
            newCenter = CGPointMake(512.0f ,self.view.frame.size.height-125);
        }
    }else{
        if (isFourInch) {
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                navBar.frame = CGRectMake(0, 0, 568, 42);
                newCenter = CGPointMake(284.0 ,self.view.frame.size.height-125);
            }
        }else{
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                navBar.frame = CGRectMake(0, 0, 480, 42);
                newCenter = CGPointMake(240.0 ,self.view.frame.size.height-125);
            }
        }
    }
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItem animated:NO];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(actionDonePicker:)];
    navItem.rightBarButtonItem = doneButton;  
    
    navBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [view addSubview:navBar];

    [view addSubview:pickerWithNames];
    [self.view addSubview:view];
    
    [UIView animateWithDuration: 0.5
                        delay: 0.0
                        options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{view.center = newCenter ; }
                     completion:^(BOOL finished) {  }
     ];
    
}



- (IBAction)actionDonePicker:(id)sender {
    
    tableViewGrouped.scrollEnabled = YES;
    buttonManufacture.enabled = YES;

    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIView class]] && view.tag == 1000) {
    
             CGPoint newCenter = CGPointMake(self.view.frame.size.width/2 ,self.view.frame.size.height+125);
            [UIView animateWithDuration: 0.5
                                  delay: 0.0
                                options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                             animations:^{view.center = newCenter ; }
                             completion:^(BOOL finished) {  }
             ];

        }
    }
    
}



- (void)viewDidUnload {
    [self setTextFieldNameCam:nil];
    [self setTextFieldNumberCam:nil];
    [self setTextFieldIpCam:nil];
    [self setTextFieldPort:nil];
    [self setButtonManufacture:nil];
    tableViewGrouped = nil;
    [self setTextFieldUser:nil];
    [self setTextFieldPass:nil];
    [self setButtonDone:nil];
    [super viewDidUnload];
}

@end
