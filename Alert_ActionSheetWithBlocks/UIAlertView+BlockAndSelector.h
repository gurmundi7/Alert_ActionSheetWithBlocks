/*
 * Copyright (c) 12/01/14 Gurpreet Singh Mundi (@Gurmundi7)
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//
//  UIAlertView+BlockAndSelector.h
//  Alert_ActionSheetWithBlocks
//
//  Created by GurPreet Singh Mundi on 12/01/14.
//  Copyright (c) 2014 Gurpreet Singh. All rights reserved.
//

#define kFirstTextFieldKey  @"_userName"
#define kSecondTextFieldKey @"_Password"

#import <UIKit/UIKit.h>

typedef void (^FinishBlock_)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void (^TextFieldBlock_)(UIAlertView *alertView, NSInteger buttonIndex, NSString* text);
typedef void (^UserNamePasswordBlock_)(UIAlertView *alertView, NSInteger buttonIndex, NSString* userName, NSString* Password);

@interface UIAlertView (BlockAndSelector)

@property (nonatomic, retain) NSMutableArray* ButtonSelectors;

//-- Some Quick Access methods
+ (void) AlertViewWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(FinishBlock_)block_;
+ (void) AlertViewWithTextFieldPlain_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock_)block_;
+ (void) AlertViewWithTextFieldSecure_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock_)block_;
+ (void) AlertView_UsenNamePassword_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(UserNamePasswordBlock_)block_;

//-- And Extra Methos to pass Array for other buttons
- (id) initWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles;

//-- Method to add new button With Selector
- (void) addButtonWithTittle:(NSString*)t_ Selecter:(SEL)s_ target:(id)target_ ;
//-- add Selector for existing button of alert View
- (void) addSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index;


//-- Methods to show alertView With Blocks
//-- Simple Alert View
- (void) showWithFinishBlock:(FinishBlock_)block_;
//-- AlertView with TextField [simple or secure]
- (void) showWithTextFieldBlock:(TextFieldBlock_)block_ secure:(BOOL)isSecure;
//-- AlertView with two textfields username & password
- (void) showWithUserNamePasswordBlock:(UserNamePasswordBlock_)block_;
@end
