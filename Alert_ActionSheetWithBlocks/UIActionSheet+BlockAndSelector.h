//
//  UIActionSheet+BlockAndSelector.h
//  Alert_ActionSheetWithBlocks
//
//  Created by GurPreet Singh Mundi on 12/01/14.
//  Copyright (c) 2014 Gurpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ACFinishBlock_)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (BlockAndSelector)<UIActionSheetDelegate>

//-- To show Action Sheet With FinishBlocks
-(void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated FinishBlock:(ACFinishBlock_)block_;

-(void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated FinishBlock:(ACFinishBlock_)block_;

-(void)showFromTabBar:(UITabBar *)view FinishBlock:(ACFinishBlock_)block_;

-(void)showFromToolbar:(UIToolbar *)view FinishBlock:(ACFinishBlock_)block_;

-(void)showInView:(UIView *)view FinishBlock:(ACFinishBlock_)block_;

//-- Add Selector to existion button
-(void)addSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index;
//-- add new button With Selector
-(void)addButtonWithTittle:(NSString*)t_ Selecter:(SEL)s_ target:(id)target_;
@end
