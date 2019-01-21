//
//  TableViewController.h
//  ThroughtCam
//
//  Created by iVanea! on 5/14/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camera.h"
@class TableViewController;
@class Camera;

@protocol TableViewControllerDelegate <NSObject>

- (void)tableViewControllerDidCancel:(TableViewController *)controller;
- (void)tableViewController:(TableViewController *)controller didAddCamera:(Camera *)camera;

@end

@interface TableViewController : UITableViewController<UITextFieldDelegate, UIPickerViewAccessibilityDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {

    IBOutlet UITableView *tableViewGrouped;
}
@property (strong, nonatomic) IBOutlet UITextField *textFieldNameCam;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNumberCam;
@property (strong, nonatomic) IBOutlet UITextField *textFieldIpCam;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPort;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUser;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPass;
@property (strong, nonatomic) IBOutlet UIButton *buttonManufacture;
- (IBAction)actionManufactury:(id)sender;


@property (nonatomic, weak) id <TableViewControllerDelegate> delegate;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
