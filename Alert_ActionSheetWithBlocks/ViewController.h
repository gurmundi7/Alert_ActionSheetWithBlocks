//
//  ViewController.h
//  Alert_ActionSheetWithBlocks
//
//  Created by Gurpreet Singh on 06/01/14.
//  Copyright (c) 2014 Gurpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIActionSheetDelegate>
- (IBAction)ShowAlertView:(id)sender;
- (IBAction)ShowActionSheet:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showAlert;
@end
