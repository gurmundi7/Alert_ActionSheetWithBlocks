//
//  UIAlertView+BlockAndSelector.m
//  Alert_ActionSheetWithBlocks
//
//  Created by GurPreet Singh Mundi on 12/01/14.
//  Copyright (c) 2014 Gurpreet Singh. All rights reserved.
//

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#import "UIAlertView+BlockAndSelector.h"
#import <objc/runtime.h>

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
@interface AVManager : NSObject
+(instancetype)SharedInstance;
@property(nonatomic, retain)NSMutableArray* objects;
@end
@implementation AVManager

+(instancetype)SharedInstance
{
static AVManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[AVManager alloc] init];
    });
    return shared;
}
-(id)init{
    self = [super init];
    if (self) {
            self.objects = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
/*
 * Runtime association key.
 */
static NSString *kFinishBlockKey = @"kFinishBlockKey";
static NSString *kTextFieldBlockKey = @"kTextFieldBlockKey";
static NSString *kUserNamePasswordBlockKey = @"kUserNamePasswordBlockKey";

static NSString *kButtonSelectorArrayKey = @"kButtonSelectorArrayKey";
static NSString *kObjectToPassKey = @"kFObjectToPassKey";

@implementation UIAlertView (BlockAndSelector)
@dynamic ButtonSelectors;

+(void)AlertViewWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(FinishBlock_)block_{
   UIAlertView* alertView = [[UIAlertView alloc] initWithTittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles];
    [alertView showWithFinishBlock:block_];
}
-(id)initWithTittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles{
    self = [self initWithTitle:t_ message:m_ delegate:self cancelButtonTitle:cb_ otherButtonTitles:nil];
    self.ButtonSelectors = [[NSMutableArray alloc] init];
    
    for (NSString* btn in otherButtonTitles)
        [self addButtonWithTitle:btn];
    
    return self;
}
+(void)AlertViewWithTextFieldPlain_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock_)block_{
    UIAlertView* alertView =  [[UIAlertView alloc] initWithTittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles];
    [alertView showWithTextFieldBlock:block_ secure:NO];
}
+(void)AlertViewWithTextFieldSecure_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(TextFieldBlock_)block_{
    UIAlertView* alertView =  [[UIAlertView alloc] initWithTittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles];
    [alertView showWithTextFieldBlock:block_ secure:YES];
}
+(void)AlertView_UsenNamePassword_Tittle:(NSString*)t_ message:(NSString*)m_ cancelButton:(NSString*)cb_ otherButtonTitles:(NSArray *)otherButtonTitles ComplitionBlock:(UserNamePasswordBlock_)block_{
    UIAlertView* alertView =  [[UIAlertView alloc] initWithTittle:t_ message:m_ cancelButton:cb_ otherButtonTitles:otherButtonTitles];
    [alertView showWithUserNamePasswordBlock:block_];
}

-(void)setButtonSelectors:(NSMutableArray *)ButtonSelectors{
    [AVManager SharedInstance].objects = ButtonSelectors;
}
-(NSMutableArray *)ButtonSelectors{
    return [AVManager SharedInstance].objects;
}
-(void)setAssociatedObject:(id)object forKey:(NSString*)key{
    objc_setAssociatedObject(self, (__bridge const void *)(key), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)getAssociatedObject:(NSString*)key{
   return objc_getAssociatedObject(self, (__bridge const void *)(key));
}
-(void)showWithFinishBlock:(FinishBlock_)block_
{
    [self setAssociatedObject:block_ forKey:kFinishBlockKey];
    [self setAssociatedObject:nil    forKey:kTextFieldBlockKey];
    [self setAssociatedObject:nil    forKey:kUserNamePasswordBlockKey];
    
    self.alertViewStyle = UIAlertViewStyleDefault;
    
    [self setDelegate:self];
    [self show];
}
-(void)showWithTextFieldBlock:(TextFieldBlock_)block_ secure:(BOOL)isSecure
{
    [self setAssociatedObject:nil    forKey:kFinishBlockKey];
    [self setAssociatedObject:block_ forKey:kTextFieldBlockKey];
    [self setAssociatedObject:nil    forKey:kUserNamePasswordBlockKey];
    
    if(isSecure)
        self.alertViewStyle = UIAlertViewStyleSecureTextInput;
    else
        self.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [self setDelegate:self];
    [self show];
}
-(void)showWithUserNamePasswordBlock:(UserNamePasswordBlock_)block_
{
    
    [self setAssociatedObject:nil    forKey:kFinishBlockKey];
    [self setAssociatedObject:nil    forKey:kTextFieldBlockKey];
    [self setAssociatedObject:block_ forKey:kUserNamePasswordBlockKey];
    
    self.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [self setDelegate:self];
    [self show];
}
/*
 * Sent to the delegate when the user clicks a button on an alert view.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    FinishBlock_ _finishBlock = [self getAssociatedObject:kFinishBlockKey];
    TextFieldBlock_ _txtFldBlck = [self getAssociatedObject:kTextFieldBlockKey];
    UserNamePasswordBlock_ _usrPassBlck = [self getAssociatedObject:kUserNamePasswordBlockKey];
    
    UITextField *FirstTextField = Nil;
    if(alertView.alertViewStyle != UIAlertViewStyleDefault)
        FirstTextField = [alertView textFieldAtIndex:0];
    
    UITextField *PassTextField = Nil;
    if(alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput)
        PassTextField = [alertView textFieldAtIndex:1];

    
    if(self.ButtonSelectors.count  > 0){
        for (AlertViewSelector* btnSel in self.ButtonSelectors) {
            if(btnSel.Index == buttonIndex){
                [btnSel fireNowWithObject:@{kFirstTextFieldKey: (FirstTextField.text)? FirstTextField.text:@"", kSecondTextFieldKey: (PassTextField.text)?PassTextField.text:@""}];
                _txtFldBlck = nil;
                _usrPassBlck = nil;
                _finishBlock = Nil;
                return;
            }
        }
    }
    if(alertView.alertViewStyle == UIAlertViewStyleDefault){
        if(_finishBlock)
            _finishBlock(self, buttonIndex);
    }else if(alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput){
        if(_usrPassBlck)
            _usrPassBlck(self, buttonIndex, FirstTextField.text, PassTextField.text);
    }else if(alertView.alertViewStyle == UIAlertViewStylePlainTextInput ||
             alertView.alertViewStyle == UIAlertViewStyleSecureTextInput){
        if(_txtFldBlck)
            _txtFldBlck(self, buttonIndex, FirstTextField.text);
    }
    
    _finishBlock = nil;
    _txtFldBlck  = nil;
    _usrPassBlck = nil;

    [self.ButtonSelectors removeAllObjects];
}
-(void)addSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index{
    NSAssert([target_ respondsToSelector:s_], @"Selector not found [%@ %@]",NSStringFromClass([target_ class]), NSStringFromSelector(s_));
    NSAssert(self.numberOfButtons > index, @"Button at index %d for alertview not found. Total number of buttons are %d",index,self.numberOfButtons);
    
    if(!self.ButtonSelectors)
        self.ButtonSelectors = [[NSMutableArray alloc] init];
    
    [self.ButtonSelectors addObject:[AlertViewSelector NewAlertViewSelectorWithSelecter:s_ target:target_ forButtonAtIndex:index]];
}
-(void)addButtonWithTittle:(NSString*)t_ Selecter:(SEL)s_ target:(id)target_{
    NSAssert(t_, @"Tittle must not be nil.");
    [self addSelecter:s_ target:target_ forButtonAtIndex:[self addButtonWithTitle:t_]];
}
@end
