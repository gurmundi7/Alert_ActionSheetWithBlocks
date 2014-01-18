//
//  ViewController.m
//  Alert_ActionSheetWithBlocks
//
//  Created by Gurpreet Singh on 06/01/14.
//  Copyright (c) 2014 Gurpreet Singh. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertView+BlockAndSelector.h"
#import "UIActionSheet+BlockAndSelector.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)showActionSheetWithBlockAndSelector
{
    UIActionSheet * ac = [[UIActionSheet alloc] initWithTitle:@"Test" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"Other Button", nil];
    [ac addButtonWithTittle:@"Selector[Alert]" Selecter:@selector(QuickAlertView) target:self];
    [ac addSelecter:@selector(test) target:self forButtonAtIndex:2];
    [ac showInView:self.view FinishBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSLog(@"%d",buttonIndex);
    }];
}
-(void)QuickAlertView
{
    [UIAlertView AlertViewWithTittle:@"Quick" message:@"AlertView" cancelButton:@"Cancel" otherButtonTitles:@[@"newAlertViewWithBlock",@"newAlertViewWithSingleTextField",@"newAlertViewWithTextFields"] ComplitionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self newAlertViewWithBlock];
        }
        else if (buttonIndex == 2)
        {
            [self newAlertViewWithSingleTextField];
        }else if (buttonIndex == 3)
        {
            [self newAlertViewWithTextFields];
        }
    }];
}
-(void)newAlertViewWithTextFields
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"AlertView+Block" message:@"WithBlocks" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert showWithUserNamePasswordBlock:^(UIAlertView *alertView, NSInteger buttonIndex, NSString *userName, NSString *Password) {
        NSLog(@"UserName = %@, Password = %@",userName,Password);
    }];
}
-(void)newAlertViewWithBlock
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"AlertView+Block" message:@"WithBlocks" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"newAlertViewWithTextFields",@"newAlertViewWithSingleTextField", nil];
    [alert showWithFinishBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self newAlertViewWithTextFields];
        }
        else if (buttonIndex == 1)
        {
            [self newAlertViewWithSingleTextField];
        }
    }];
}
-(void)newAlertViewWithSingleTextField
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"AlertView+Block+Selector" message:@"With Blocks & Selectors" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alert addButtonWithTittle:@"SEL" Selecter:@selector(AlertViewSelector:) target:self];
    [alert addSelecter:@selector(AlertViewSelector:) target:self forButtonAtIndex:0];
    [alert showWithTextFieldBlock:^(UIAlertView *alertView, NSInteger buttonIndex, NSString *text) {
        NSLog(@"%@",text);
    } secure:NO];
}
-(void)test
{
    NSLog(@"test");
}
-(void)AlertViewSelector:(NSDictionary*)obj
{
    //-- this will return text field text in dic
   NSLog(@"Selector  %@,%@",obj[kFirstTextFieldKey],obj[kSecondTextFieldKey]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ShowActionSheet:(id)sender
{    [self showActionSheetWithBlockAndSelector];
}

- (IBAction)ShowAlertView:(id)sender {
    [self QuickAlertView];
}
@end
