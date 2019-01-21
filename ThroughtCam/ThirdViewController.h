//
//  ThirdViewController.h
//  ThroughtCam
//
//  Created by iVanea! on 5/15/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TableViewController.h"
#import "DecryptManager.h"

FOUNDATION_EXPORT NSString *const pathType;



@interface ThirdViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TableViewControllerDelegate,UIAlertViewDelegate>{

    IBOutlet UITableView *tableViewMyCams;
    DecryptManager *decript;
}
@end
