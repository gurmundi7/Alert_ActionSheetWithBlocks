//
//  ActionSheet&AlertViewBlocks.h
//  Alert_ActionSheetWithBlocks
//
//  Created by Gurpreet Singh on 06/01/14.
//  Copyright (c) 2014 Gurpreet Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFirstTextFieldKey  @"_userName"
#define kSecondTextFieldKey @"_Password"

typedef void (^FinishBlock)(NSInteger buttonIndex);
typedef void (^TextFieldBlock)(NSInteger buttonIndex, NSString* text);
typedef void (^UserNamePasswordBlock)(NSInteger buttonIndex, NSString* userName, NSString* Password);

@interface ActionSheet_AlertViewBlocks : NSObject<UIAlertViewDelegate, UIActionSheetDelegate>

+(void)alertViewWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(FinishBlock)block_;
-(void)AlertViewWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(FinishBlock)block_;
-(void)AlertView_TextFieldPlain_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock)block_;
-(void)AlertView_TextFieldSecure_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock)block_;
-(void)AlertView_UsenNamePassword_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(UserNamePasswordBlock)block_;

-(void)addButtonWithTittle:(NSString*)t_ Selecter:(SEL)s_ target:(id)target_ ;
-(void)addSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index;
-(void)ShowAlertView;

+(instancetype)sharedInstance;

@property (nonatomic, retain) NSMutableArray* ButtonSelectors;

@end

