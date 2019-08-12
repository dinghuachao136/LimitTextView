//
//  ViewController.m
//  LimitTextPro
//
//  Created by dhc on 2019/8/12.
//  Copyright © 2019 dhc. All rights reserved.
//

#import "ViewController.h"
#import "LimitTextView/LimitTextView.h"
#import "ReactiveCocoa.h"

@interface ViewController ()<UITextViewDelegate>

@property(nonatomic,strong)LimitTextView *limitText;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.limitText];
    self.limitText.frame = CGRectMake(10, 100, 200, 100);
    self.limitText.backgroundColor = [UIColor redColor];
    __weak typeof(self) weakSelf = self;
    [[self.limitText rac_textSignal] subscribeNext:^(NSString *x) {
        [weakSelf.limitText LimitTextViewTextViewDidChange:self.limitText];
        [weakSelf.limitText.undoManager removeAllActions];
    }];
    self.limitText.remainNumberLimitBlock = ^(NSInteger number){
        
        NSLog(@"==========%ld",number);
        if (number==-1) {
           
        }else{
           
        }
    };
    
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSString *otherString = @"➋➌➍➎➏➐➑➒";//适配九宫格键盘
//    if (![StringManager isInputRuleNotBlank:text]&&!([otherString rangeOfString:text].location != NSNotFound)) {
//        return NO;
//    }
    LimitTextView *currentView = (LimitTextView *)textView;
    [currentView limitTextViewTextView:textView shouldChangeTextInRange:range replacementText:text];
    
    if ([text isEqualToString:@"\n"]) {
        if ([textView isEqual:self.limitText]) {
            //[self hideKeyboard:nil];
        }
    }
    
    return YES;
}

-(LimitTextView *)limitText{
    if (!_limitText) {
        _limitText                        = [[LimitTextView alloc] init];
        
        _limitText.textColor              = [UIColor blackColor];
        _limitText.textAlignment          = NSTextAlignmentCenter;
        _limitText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //_limitText.font                   = [FontManager getDefalutFontMedium:15.f];
        [_limitText setMaxNumberLimited:40];
        //        placeholder 设置一定要在placeholder 之前
        _limitText.placeholderColor       = [UIColor grayColor];
        _limitText.placeholderTextAlignment=NSTextAlignmentCenter;
        //placeholder 设置一定要在TextColor 之后
        _limitText.placeholderX           = 8;
        _limitText.placeholderY           = 5;
        _limitText.returnKeyType          = UIReturnKeyDone;
        _limitText.scrollEnabled          = NO;
        _limitText.textContainerInset     = UIEdgeInsetsMake(5, 0, 5, 0);
        _limitText.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, 0, 0);
        [_limitText setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_limitText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _limitText.delegate               = self;
        
    }
    return _limitText;
}
@end
