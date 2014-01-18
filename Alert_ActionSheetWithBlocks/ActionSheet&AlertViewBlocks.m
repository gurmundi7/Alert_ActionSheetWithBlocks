//
//  ActionSheet&AlertViewBlocks.m
//  Alert_ActionSheetWithBlocks
//
//  Created by Gurpreet Singh on 06/01/14.
//  Copyright (c) 2014 Gurpreet Singh. All rights reserved.
//
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#import "ActionSheet&AlertViewBlocks.h"


@interface AlertViewSelector : NSObject

@property NSInteger Index;
@property SEL selector;
@property id target;

+(id)NewAlertViewSelectorWithSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index;
@end

@implementation AlertViewSelector
+(id)NewAlertViewSelectorWithSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index{
   return [[self alloc] initWithSelecter:s_ target:target_ forButtonAtIndex:index];
}
-(id)initWithSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index{
    self = [super init];
    if(self){
        self.selector = s_;
        self.target   = target_;
        self.Index    = index;
    }
    return self;
}
-(void)fireNow{
    if(self.target && self.selector)
        if([self.target respondsToSelector:self.selector]){
            SuppressPerformSelectorLeakWarning([self.target performSelector:self.selector];);
        }
}
-(void)fireNowWithObject:(NSDictionary*)obj_
{
    if(self.target && self.selector)
        if([self.target respondsToSelector:self.selector]){
            SuppressPerformSelectorLeakWarning([self.target performSelector:self.selector withObject:obj_];);
        }
}
@end

@interface ActionSheet_AlertViewBlocks ()

@end
@implementation ActionSheet_AlertViewBlocks{
    FinishBlock _finishBlock;
    TextFieldBlock _txtFldBlck;
    UserNamePasswordBlock _usrPassBlck;
    UIAlertView* alertview;
    NSMutableDictionary* objDic ;
}

@synthesize ButtonSelectors;

+(instancetype)sharedInstance{
    static ActionSheet_AlertViewBlocks *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}
-(id)init{
    self = [super init];
    if (self) {
        if(!objDic)
            objDic = [[NSMutableDictionary alloc] initWithObjects:@[@"",@""] forKeys:@[kFirstTextFieldKey,kSecondTextFieldKey]];
        if(!ButtonSelectors)
            ButtonSelectors = [[NSMutableArray alloc] init];
    }
    return self;
}
+(void)alertViewWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(FinishBlock)block_{
    [[self sharedInstance] AlertViewWithTittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles ComplitionBlock:block_];
}
-(void)AlertViewWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(FinishBlock)block_{
    _finishBlock = block_;
    [self AlertViewWithStyle:UIAlertViewStyleDefault Tittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles];
    
}
-(void)AlertViewWithStyle:(UIAlertViewStyle)st_ Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles{
    alertview = [[UIAlertView alloc] initWithTitle:t_ message:m_ delegate:self cancelButtonTitle:cb_ otherButtonTitles:nil];
    alertview.alertViewStyle = st_;
    
    for (NSString* btn in otherButtonTitles)
        [alertview addButtonWithTitle:btn];

    [ButtonSelectors removeAllObjects];
}
-(void)AlertView_TextFieldPlain_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock)block_{
    _txtFldBlck = block_;
    [self AlertViewWithStyle:UIAlertViewStylePlainTextInput Tittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles];
}
-(void)AlertView_TextFieldSecure_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock)block_{
    _txtFldBlck = block_;
    [self AlertViewWithStyle:UIAlertViewStyleSecureTextInput Tittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles];
}
-(void)AlertView_UsenNamePassword_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(UserNamePasswordBlock)block_{
    _usrPassBlck = block_;
    [self AlertViewWithStyle:UIAlertViewStyleLoginAndPasswordInput Tittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.alertViewStyle != UIAlertViewStyleDefault){
        UITextField *FirstTextField = [alertView textFieldAtIndex:0];
        if(FirstTextField)
            [objDic setObject:FirstTextField.text forKey:kFirstTextFieldKey];
    }
    if(alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput){
        UITextField *PassTextField  = [alertView textFieldAtIndex:1];
        if(PassTextField)
            [objDic setObject:PassTextField.text forKey:kSecondTextFieldKey];
    }
    
    if(ButtonSelectors.count  > 0){
        for (AlertViewSelector* btnSel in ButtonSelectors) {
            if(btnSel.Index == buttonIndex){
                [btnSel fireNowWithObject:objDic];
                _txtFldBlck = nil;
                _usrPassBlck = nil;
                _finishBlock = Nil;
                alertview    = nil;
                return;
            }
        }
    }
    if(alertView.alertViewStyle == UIAlertViewStyleDefault){
        if(_finishBlock)
            _finishBlock(buttonIndex);
    }else if(alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput){
        if(_usrPassBlck)
            _usrPassBlck(buttonIndex, objDic[kFirstTextFieldKey], objDic[kSecondTextFieldKey]);
    }else if(alertView.alertViewStyle == UIAlertViewStylePlainTextInput ||
             alertView.alertViewStyle == UIAlertViewStyleSecureTextInput){
        if(_txtFldBlck)
            _txtFldBlck(buttonIndex, objDic[kFirstTextFieldKey]);
    }
    
    _finishBlock = nil;
    _txtFldBlck  = nil;
    _usrPassBlck = nil;
    alertview    = nil;
    [ButtonSelectors removeAllObjects];
}
-(void)addSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index{
    NSAssert(alertview, @"Firest create an instance of alertview by using +/- alertViewWithTittle: message: cancelButton: otherButtonTitles: ComplitionBlock:");
    NSAssert(alertview.numberOfButtons > index, @"Button at index %d for alertview not found. Total number of buttons are %d",index,alertview.numberOfButtons);
    
    [self.ButtonSelectors addObject:[AlertViewSelector NewAlertViewSelectorWithSelecter:s_ target:target_ forButtonAtIndex:index]];
}
-(void)addButtonWithTittle:(NSString*)t_ Selecter:(SEL)s_ target:(id)target_{
    NSAssert(alertview, @"Firest create an instance of alertview by using +/- alertViewWithTittle: message: cancelButton: otherButtonTitles: ComplitionBlock:");
    [self addSelecter:s_ target:target_ forButtonAtIndex:[alertview addButtonWithTitle:t_]];
}
-(void)ShowAlertView{
    NSAssert(alertview, @"Firest create an instance of alertview by using +/- alertViewWithTittle: message: cancelButton: otherButtonTitles: ComplitionBlock:");
    
    [alertview show];
}
@end
