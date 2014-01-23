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


ActionSheet-AlertView-Blocks-Selectors
======================================

UIActionSheet, UIAlertView with blocks And selctors

This is category for UIAlertview & UIActionSheet

You Can use these classes to use UIAlertView/ UIActionSheet with Finish Blocks
& this also allows you to add selectors for particular button for both.
You Can Also add multiple selectors for different Buttons.

It also allow you use some quick methods to show alert view

+ (void) AlertViewWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(FinishBlock_)block_;
+ (void) AlertViewWithTextFieldPlain_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock_)block_;
+ (void) AlertViewWithTextFieldSecure_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock_)block_;
+ (void) AlertView_UsenNamePassword_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(UserNamePasswordBlock_)block_;


Other wise use your normal code to show alertView. for eg.

 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"AlertView+Block" message:@"WithBlocks" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"newAlertViewWithTextFields",@"newAlertViewWithSingleTextField", nil];
    [alert showWithFinishBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
        }
        else if (buttonIndex == 1)
        {
        }
    }];

It provide some methods to show 

//-- Methods to show alertView With Blocks
//-- Simple Alert View
- (void) showWithFinishBlock:(FinishBlock_)block_;
//-- AlertView with TextField [simple or secure]
- (void) showWithTextFieldBlock:(TextFieldBlock_)block_ secure:(BOOL)isSecure;
//-- AlertView with two textfields username & password


For Action sheet use these methods to show action sheet

//-- To show Action Sheet With FinishBlocks
-(void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated FinishBlock:(ACFinishBlock_)block_;

-(void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated FinishBlock:(ACFinishBlock_)block_;

-(void)showFromTabBar:(UITabBar *)view FinishBlock:(ACFinishBlock_)block_;

-(void)showFromToolbar:(UIToolbar *)view FinishBlock:(ACFinishBlock_)block_;

-(void)showInView:(UIView *)view FinishBlock:(ACFinishBlock_)block

To add selector for button use following methods for both action sheet and alert view

//-- Add Selector to existion button
-(void)addSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index;
//-- add new button With Selector
-(void)addButtonWithTittle:(NSString*)t_ Selecter:(SEL)s_ target:(id)target_;


