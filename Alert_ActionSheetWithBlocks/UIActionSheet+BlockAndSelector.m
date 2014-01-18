//
//  UIActionSheet+BlockAndSelector.m
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


#import "UIActionSheet+BlockAndSelector.h"
#import <objc/runtime.h>

@interface ACSelector : NSObject

@property NSInteger Index;
@property SEL selector;
@property id target;

+(id)NewACSelectorWithSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index;
@end

@implementation ACSelector
+(id)NewACSelectorWithSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index{
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
    [self fireNowWithObject:nil];
}
-(void)fireNowWithObject:(NSDictionary*)obj_
{
    if(self.target && self.selector)
        if([self.target respondsToSelector:self.selector]){
            SuppressPerformSelectorLeakWarning([self.target performSelector:self.selector withObject:obj_];);
        }
}
@end
@interface ACManager : NSObject
+(instancetype)SharedInstance;
@property(nonatomic, retain)NSMutableArray* objects;
@end
@implementation ACManager

+(instancetype)SharedInstance
{
    static ACManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ACManager alloc] init];
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

static NSString *kFinishBlockKey = @"kACFinishBlockKey";

@implementation UIActionSheet (BlockAndSelector)
-(void)setAssociatedObject:(id)object forKey:(NSString*)key{
    objc_setAssociatedObject(self, (__bridge const void *)(key), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)getAssociatedObject:(NSString*)key{
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}
-(void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated FinishBlock:(ACFinishBlock_)block_
{
    [self setAssociatedObject:block_ forKey:kFinishBlockKey];
    [self setDelegate:self];
    [self showFromBarButtonItem:item animated:YES];
}
-(void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated FinishBlock:(ACFinishBlock_)block_
{
    [self setAssociatedObject:block_ forKey:kFinishBlockKey];
    [self setDelegate:self];
    [self showFromRect:rect inView:view animated:animated];
}
-(void)showFromTabBar:(UITabBar *)view FinishBlock:(ACFinishBlock_)block_
{
    [self setAssociatedObject:block_ forKey:kFinishBlockKey];
    [self setDelegate:self];
    [self showFromTabBar:view];
}
-(void)showFromToolbar:(UIToolbar *)view FinishBlock:(ACFinishBlock_)block_
{
    [self setAssociatedObject:block_ forKey:kFinishBlockKey];
    [self setDelegate:self];
    [self showFromToolbar:view];
}
-(void)showInView:(UIView *)view FinishBlock:(ACFinishBlock_)block_
{
    [self setAssociatedObject:block_ forKey:kFinishBlockKey];
    [self setDelegate:self];
    [self showInView:view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.ButtonSelectors.count  > 0){
        for (ACSelector* btnSel in self.ButtonSelectors) {
            if(btnSel.Index == buttonIndex){
                [btnSel fireNow];
                return;
            }
        }
    }
    
    ACFinishBlock_ block = [self getAssociatedObject:kFinishBlockKey];
    block(actionSheet,buttonIndex);
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.ButtonSelectors removeAllObjects];
}
-(void)addSelecter:(SEL)s_ target:(id)target_ forButtonAtIndex:(NSInteger)index{
    NSAssert([target_ respondsToSelector:s_], @"Selector not found [%@ %@]",NSStringFromClass([target_ class]), NSStringFromSelector(s_));
    NSAssert(self.numberOfButtons > index, @"Button at index %d for ActionSheet not found. Total number of buttons are %d",index,self.numberOfButtons);
    
    if(!self.ButtonSelectors)
        self.ButtonSelectors = [[NSMutableArray alloc] init];
    
    for (ACSelector* btnSel in self.ButtonSelectors)
    {
        NSLog(@"%d == %d",btnSel.Index,index);
            NSAssert(btnSel.Index != index, @"Selector for button at indes=x %d already exist. [Button %@]",index,NSStringFromSelector([btnSel selector]));
    }
    [self.ButtonSelectors addObject:[ACSelector NewACSelectorWithSelecter:s_ target:target_ forButtonAtIndex:index]];
}
-(void)addButtonWithTittle:(NSString*)t_ Selecter:(SEL)s_ target:(id)target_{
    NSAssert(t_, @"Tittle must not be nil.");
    [self addSelecter:s_ target:target_ forButtonAtIndex:[self addButtonWithTitle:t_]];
}
-(void)setButtonSelectors:(NSMutableArray *)ButtonSelectors{
    [ACManager SharedInstance].objects = ButtonSelectors;
}
-(NSMutableArray *)ButtonSelectors{
    return [ACManager SharedInstance].objects;
}
@end
