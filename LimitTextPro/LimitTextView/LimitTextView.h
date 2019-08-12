//
//  LimitTextView.h
//  GGTextView
//
//  Created by 丁华超 on 16/7/7.
//  Copyright (c) 2015年 ruijie. All rights reserved.
//

/*使用
 1 创建
 self.textView = [[LimitTextView alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 140)];
 [self.textView setMaxNumberLimited:20];
 [self.view addSubview:self.textView];
 self.textView.text = @"01234567890123456789sss";//在调用- (void)LimitTextViewTextViewDidChange:(UITextView *)textView之前初始化
 self.textView.delegate = self;
 
 2 回调
 self.textView.remainNumberLimitBlock = ^(NSInteger number){
 
 weakSelf.textLabel.text = [NSString stringWithFormat:@"%ld/%ld",number,weakSelf.textView.maxNumberLimited/3];
 
 };
 [self.textView LimitTextViewTextViewDidChange:self.textView];//需要卸载回调的block之后
 
 
 3  回调方法不要写在self里面，防止调用self的view里面注册回调
 
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
 
 BOOL shouChange =  [self.textView limitTextViewTextView:textView shouldChangeTextInRange:range replacementText:text];
 NSLog(@"shouldChangeTextInRange");
 return shouChange;
 }
 - (void)textViewDidChange:(UITextView *)textView{
 
 [self.textView LimitTextViewTextViewDidChange:textView];
 NSLog(@"textViewDidChange");
 }
 
 */
#import <UIKit/UIKit.h>
typedef void(^GGTextViewLimitBlock)(NSInteger remainNumber);

//#define PLACEHOLDERFONTSIZE 13

@interface LimitTextView : UITextView

@property (nonatomic,assign          ) CGFloat              placeholderX;
@property (nonatomic,assign          ) CGFloat              placeholderY;

@property (nonatomic,assign          ) NSUInteger           maxNumberLimited;//设置输入的最大字符数

@property (nonatomic,copy            ) NSString             *placeholder;
@property (nonatomic,strong          ) UIColor              *placeholderColor;

@property (nonatomic,assign          ) NSTextAlignment      placeholderTextAlignment;

@property (nonatomic,copy            ) GGTextViewLimitBlock remainNumberLimitBlock;//剩余字数的回调


-(BOOL)limitTextViewTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)LimitTextViewTextViewDidChange:(UITextView *)textView;

- (void)LimitTextViewTextViewSetDefault:(UITextView *)textView;

/**
 *  返回一个可以字数限制的textview对象
 *
 *  @param frame                  frame
 *  @param placeHolder            placeHolder
 *  @param maxNumber              限制字数
 *  @param chinaCharacterNumber   一个汉字占用的字节数
 *  @param chinaPunctuationNumber 一个全角字符占用的字节数
 *  @param emojiCharacterNumber   一个emoji表情占用的字节数
 *  @param placeholderX           placeHolder的posX坐标
 *  @param placeholderY           placeHolder的posY坐标
 *  @param font                   self的字体大小
 *
 *  @return 返回一个可以字数限制的textview对象
 */

-(instancetype)initWithFrame:(CGRect)frame withPlaceHolder:(NSString *)placeHolder withMaxNumberLimited:(CGFloat)maxNumber withChinaCharacterNumber:(NSInteger)chinaCharacterNumber withChinaPunctuationNum:(CGFloat)chinaPunctuationNumber withEmojiCharacterNum:(CGFloat)emojiCharacterNumber withPlaceholderX:(CGFloat)placeholderX withPlaceholderY:(CGFloat)placeholderY withPlaceHolderFont:(UIFont *)font;

-(instancetype)initWithFrame:(CGRect)frame withPlaceHolder:(NSString *)placeHolder withMaxNumberLimited:(CGFloat)maxNumber withChinaCharacterNumber:(NSInteger)chinaCharacterNumber withChinaPunctuationNum:(CGFloat)chinaPunctuationNumber withEmojiCharacterNum:(CGFloat)emojiCharacterNumber withPlaceholderX:(CGFloat)placeholderX withPlaceholderY:(CGFloat)placeholderY withPlaceHolderFont:(UIFont *)font withNoDefault:(BOOL)NodDefaultSet;



/**
 获取被截断后的字符

 @param limitText 要被截取的字符串
 @param count 限制字符数
 @return 被截取后的字符数
 */
+(NSString *)cutLimitText:(NSString *)limitText count:(NSInteger)count;
@end
