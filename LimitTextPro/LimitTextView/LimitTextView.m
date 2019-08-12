//
//  LimitTextView.m
//  GGTextView
//
//  Created by 丁华超 on 16/7/7.
//  Copyright (c) 2015年 ruijie. All rights reserved.
//

#import "LimitTextView.h"

@interface LimitTextView ()



@property (nonatomic,assign          ) float  chinaCharacterNum;//一个汉字占的字符数，默认为1个汉字一个字符
@property (nonatomic,assign          ) float  chinaPunctuationNum;//一个全角字符占的字符数，默认为1个汉字一个字符
@property (nonatomic,assign          ) float  emojiCharacterNum;//一个emoji表情占的字符数，默认为2个表情占1个，英文字符三个占一个
@property (nonatomic, strong         ) UILabel    *placeholderLabel;
@property (nonatomic, assign         ) float remainNumberLimited;//还能输入的字符数
@property (nonatomic, assign         ) float textNumber;//已经输入的字数
@property (nonatomic,assign          ) BOOL       isEnd;//字数达到上限，或者剩下的字符数不够再次输出要输入的文字

@property(nonatomic,assign)BOOL   noDefault;
@end
@implementation LimitTextView

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withPlaceHolder:@"请输入" withMaxNumberLimited:LONG_MAX withChinaCharacterNumber:1 withChinaPunctuationNum:1 withEmojiCharacterNum:1 withPlaceholderX:5 withPlaceholderY:8 withPlaceHolderFont:[UIFont systemFontOfSize:14]];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero withPlaceHolder:@"请输入" withMaxNumberLimited:LONG_MAX withChinaCharacterNumber:1 withChinaPunctuationNum:1 withEmojiCharacterNum:1 withPlaceholderX:5 withPlaceholderY:8 withPlaceHolderFont:[UIFont systemFontOfSize:14]];
}

-(instancetype)initWithFrame:(CGRect)frame withPlaceHolder:(NSString *)placeHolder withMaxNumberLimited:(CGFloat)maxNumber withChinaCharacterNumber:(NSInteger)chinaCharacterNumber withChinaPunctuationNum:(CGFloat)chinaPunctuationNumber withEmojiCharacterNum:(CGFloat)emojiCharacterNumber withPlaceholderX:(CGFloat)placeholderX withPlaceholderY:(CGFloat)placeholderY withPlaceHolderFont:(UIFont *)font{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.placeholderLabel];
        //self.delegate            = self;
        self.chinaCharacterNum   = chinaCharacterNumber;
        self.chinaPunctuationNum = chinaPunctuationNumber;
        self.emojiCharacterNum   = emojiCharacterNumber;
        _placeholderX            = placeholderX;
        _placeholderY            = placeholderY;
        self.textNumber          = 0;
        //self.countTextNumber = 0;
        _remainNumberLimited = maxNumber;
        _maxNumberLimited    = maxNumber;
        self.font                = font;
        self.placeholder         = placeHolder;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame withPlaceHolder:(NSString *)placeHolder withMaxNumberLimited:(CGFloat)maxNumber withChinaCharacterNumber:(NSInteger)chinaCharacterNumber withChinaPunctuationNum:(CGFloat)chinaPunctuationNumber withEmojiCharacterNum:(CGFloat)emojiCharacterNumber withPlaceholderX:(CGFloat)placeholderX withPlaceholderY:(CGFloat)placeholderY withPlaceHolderFont:(UIFont *)font withNoDefault:(BOOL)NodDefaultSet{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.placeholderLabel];
        self.noDefault = NodDefaultSet;
        //self.delegate            = self;
        self.chinaCharacterNum   = chinaCharacterNumber;
        self.chinaPunctuationNum = chinaPunctuationNumber;
        self.emojiCharacterNum   = emojiCharacterNumber;
        _placeholderX            = placeholderX;
        _placeholderY            = placeholderY;
        self.textNumber          = 0;
        //self.countTextNumber = 0;
        if (self.noDefault) {
            self.remainNumberLimited = maxNumber;
            self.maxNumberLimited    = maxNumber;
        }else{
            _remainNumberLimited = maxNumber;
            _maxNumberLimited    = maxNumber;
        }
        
        self.font                = font;
        self.placeholder         = placeHolder;
    }
    return self;
}
#pragma mark - delegate
//通过判断表层TextView的内容来实现底层TextView的显示于隐藏
-(BOOL)limitTextViewTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"shouldChange%@",textView.text);
    if(![text isEqualToString:@""]){
        [self.placeholderLabel setHidden:YES];
    }
    if(range.length==0&&range.location==0&&textView.text.length<1){
        [self.placeholderLabel setHidden:NO];
    }
    if ([text isEqualToString:@""]) {
        return YES;
    }
    
    if (self.textNumber>self.maxNumberLimited) {
        if (_remainNumberLimitBlock!=nil) {
            _remainNumberLimitBlock(-1);
        }
    }
    if (self.textNumber >= self.maxNumberLimited && text.length > 0) {
        
        return NO;
    }
    
    return YES;
}

- (void)LimitTextViewTextViewDidChange:(UITextView *)textView{
    //NSLog(@"didChange%@",textView.text);
    
    NSString *text = @"";
    //UITextRange *selectedRange = [self markedTextRange];
//    if (selectedRange) {
//        NSString *newText = [self textInRange:selectedRange];
//        text =   [self getLimitString:[textView.text substringToIndex:textView.text.length]];
//    } else {
//        text =   [self getLimitString:textView.text];
//    }
    text =   [self getLimitString:textView.text maxLimitNumber:self.maxNumberLimited];
    if (self.textNumber>self.maxNumberLimited) {
        if (_remainNumberLimitBlock!=nil) {
            _remainNumberLimitBlock(-1);
        }
    }
    if (self.isEnd|(self.textNumber >= self.maxNumberLimited)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.text = text;
        });
    }
//
    if(![self.text isEqualToString:@""]){
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];
    }
    
}
- (void)LimitTextViewTextViewSetDefault:(UITextView *)textView{
    NSString *text = @"";
    //UITextRange *selectedRange = [self markedTextRange];
    //    if (selectedRange) {
    //        NSString *newText = [self textInRange:selectedRange];
    //        text =   [self getLimitString:[textView.text substringToIndex:textView.text.length]];
    //    } else {
    //        text =   [self getLimitString:textView.text];
    //    }
    text =   [self cleanBlockReturnGetLimitString:textView.text];
    if (self.isEnd|(self.textNumber >= self.maxNumberLimited)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.text = text;
        });
    }
    //
    if(![self.text isEqualToString:@""]){
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];
    }
}

+(NSString *)cutLimitText:(NSString *)limitText count:(NSInteger)count
{
    return [[LimitTextView new] getLimitString:limitText maxLimitNumber:count];
}

#pragma mark - pri
-(NSString *)getLimitString:(NSString *)text maxLimitNumber:(NSInteger)maxLimitNumber{
    __weak LimitTextView *weakSelf     = self;
    __block float allLength              = 0;
    __block  NSMutableString *limitStr = [NSMutableString new];
    NSString *specialString            = @"����������������������";
    self.isEnd                         = NO;
    if ([text isEqualToString:@""]) {
        self.textNumber = 0 ;
        //self.countTextNumber = 0;
    }
    
   
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const char    *cString = [substring UTF8String];
        if (cString) {//防止出现不能解析的特殊符号
            if (strlen(cString)==1) {//英文下的字符与标点
                allLength++;
            }else if (strlen(cString)==2){//部分emoji表情 其他
                unichar c = [substring characterAtIndex:0];
                if (c==0x00ae|c==0x00a9) {
                    allLength+=weakSelf.emojiCharacterNum;
                    //NSLog(@"部分emoji表情");
                }else{
                    //NSLog(@"其他");
                    allLength+=weakSelf.emojiCharacterNum;
                }
                
            }else if (strlen(cString)==3) {//中文下的字符与标点，包括部分emoji表情，汉字用utf8的存储要3个字节
                unichar c = [substring characterAtIndex:0];
                if (c==0x2328|c==0x26d1|c==0x2618|c==0x2603|c==0x2602|c==0x26f7|c==0x26f8|c==0x26f4|c==0x26f0|c==0x26e9|c==0x23f1|c==0x23f2|c==0x23f0|c==0x23f3|c==0x2696|c==0x2692|c==0x26cf|c==0x26d3|c==0x2699|c==0x2694|c==0x2620|c==0x26b1|c==0x26b0|c==0x2697|c==0x26f1|c==0x2763|c==0x262e|c==0x271d|c==0x262a|c==0x2638|c==0x2721|c==0x262f|c==0x2626|c==0x26ce|c==0x269b|c==0x2622|c==0x2623|c==0x274c|c==0x2755|c==0x2753|c==0x2754|c==0x269c|c==0x274e|c==0x2705|c==0x27bf|c==0x23f8|c==0x23ef|c==0x23f9|c==0x23fa|c==0x23ea|c==0x23e9|c==0x23ee|c==0x23ed|c==0x23ec|c==0x23eb|c==0x3030|c==0x27b0|c==0x2797|c==0x2796|c==0x2795|c==0x2122|c==0x2728|c==0x2604|c==0x26c8) {
                    //NSLog(@"部分emoji表情");
                    allLength+=weakSelf.emojiCharacterNum;
                }else if (c >=0x4E00 && c <=0x9FFF){
                    allLength+=weakSelf.chinaCharacterNum;
                    //NSLog(@"汉字");
                }else{
                    allLength+=weakSelf.chinaPunctuationNum;
                }
                
            }else{//emoji表情，与部分特殊汉字      ���������������������� 是否可以显示跟系统有关系，� 9以下的就显示不出来
                //二级汉字� �� � �  � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �� � � � � � � � � � � � � � � �
                
                //NSLog(@"emoji表情字符");
                if ([specialString rangeOfString:substring].location!=NSNotFound) {
                    allLength+=weakSelf.chinaCharacterNum;
                }else{
                    allLength+=weakSelf.emojiCharacterNum;
                }
            }
            
           // weakSelf.countTextNumber = allLength;
            weakSelf.textNumber = allLength;
            if (allLength>maxLimitNumber) {
                weakSelf.isEnd = YES;
                *stop = YES;
            }else{
                [limitStr appendString:substring];
              //  weakSelf.textNumber = allLength;
            }
        }
    }];
    
    _remainNumberLimited = maxLimitNumber-self.textNumber;
    
    if (_remainNumberLimitBlock!=nil) {
        _remainNumberLimitBlock(floor(_remainNumberLimited));
    }
    return limitStr;
}


-(NSString *)cleanBlockReturnGetLimitString:(NSString *)text{
    __weak LimitTextView *weakSelf     = self;
    __block float allLength              = 0;
    __block  NSMutableString *limitStr = [NSMutableString new];
    NSString *specialString            = @"����������������������";
    self.isEnd                         = NO;
    if ([text isEqualToString:@""]) {
        self.textNumber = 0 ;
        //self.countTextNumber = 0;
    }
    
    
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const char    *cString = [substring UTF8String];
        if (cString) {//防止出现不能解析的特殊符号
            if (strlen(cString)==1) {//英文下的字符与标点
                allLength++;
            }else if (strlen(cString)==2){//部分emoji表情 其他
                unichar c = [substring characterAtIndex:0];
                if (c==0x00ae|c==0x00a9) {
                    allLength+=weakSelf.emojiCharacterNum;
                    //NSLog(@"部分emoji表情");
                }else{
                    //NSLog(@"其他");
                    allLength+=weakSelf.emojiCharacterNum;
                }
                
            }else if (strlen(cString)==3) {//中文下的字符与标点，包括部分emoji表情，汉字用utf8的存储要3个字节
                unichar c = [substring characterAtIndex:0];
                if (c==0x2328|c==0x26d1|c==0x2618|c==0x2603|c==0x2602|c==0x26f7|c==0x26f8|c==0x26f4|c==0x26f0|c==0x26e9|c==0x23f1|c==0x23f2|c==0x23f0|c==0x23f3|c==0x2696|c==0x2692|c==0x26cf|c==0x26d3|c==0x2699|c==0x2694|c==0x2620|c==0x26b1|c==0x26b0|c==0x2697|c==0x26f1|c==0x2763|c==0x262e|c==0x271d|c==0x262a|c==0x2638|c==0x2721|c==0x262f|c==0x2626|c==0x26ce|c==0x269b|c==0x2622|c==0x2623|c==0x274c|c==0x2755|c==0x2753|c==0x2754|c==0x269c|c==0x274e|c==0x2705|c==0x27bf|c==0x23f8|c==0x23ef|c==0x23f9|c==0x23fa|c==0x23ea|c==0x23e9|c==0x23ee|c==0x23ed|c==0x23ec|c==0x23eb|c==0x3030|c==0x27b0|c==0x2797|c==0x2796|c==0x2795|c==0x2122|c==0x2728|c==0x2604|c==0x26c8) {
                    //NSLog(@"部分emoji表情");
                    allLength+=weakSelf.emojiCharacterNum;
                }else if (c >=0x4E00 && c <=0x9FFF){
                    allLength+=weakSelf.chinaCharacterNum;
                    //NSLog(@"汉字");
                }else{
                    allLength+=weakSelf.chinaPunctuationNum;
                }
                
            }else{//emoji表情，与部分特殊汉字      ���������������������� 是否可以显示跟系统有关系，� 9以下的就显示不出来
                //二级汉字� �� � �  � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �� � � � � � � � � � � � � � � �
                
                //NSLog(@"emoji表情字符");
                if ([specialString rangeOfString:substring].location!=NSNotFound) {
                    allLength+=weakSelf.chinaCharacterNum;
                }else{
                    allLength+=weakSelf.emojiCharacterNum;
                }
            }
            
            // weakSelf.countTextNumber = allLength;
            weakSelf.textNumber = allLength;
            if (allLength>weakSelf.maxNumberLimited) {
                weakSelf.isEnd = YES;
                *stop = YES;
            }else{
                [limitStr appendString:substring];
                //  weakSelf.textNumber = allLength;
            }
        }
    }];
    
    _remainNumberLimited = _maxNumberLimited-self.textNumber;
    return limitStr;
}




- (void)drawRect:(CGRect)rect
{
    
        if (_placeholderLabel == nil )
        {
            _placeholderLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(self.placeholderX,self.placeholderY,self.bounds.size.width - 16,0)];
            _placeholderLabel.lineBreakMode   = NSLineBreakByWordWrapping;
            _placeholderLabel.numberOfLines   = 0;
            _placeholderLabel.font            = self.font;
            _placeholderLabel.backgroundColor = [UIColor clearColor];
            _placeholderLabel.textColor       = self.placeholderColor;
            //_placeholderLabel.alpha = 0;
            if (self.text.length>0) {
                [_placeholderLabel setHidden:YES];
            }

            _placeholderLabel.tag             = 999;
            _placeholderLabel.textAlignment   = self.placeholderTextAlignment?self.placeholderTextAlignment:NSTextAlignmentLeft;
            [self addSubview:_placeholderLabel];
        }
        
        _placeholderLabel.text = self.placeholder;
        [_placeholderLabel sizeToFit];
        _placeholderLabel.frame = CGRectMake(_placeholderLabel.frame.origin.x, _placeholderLabel.frame.origin.y, self.bounds.size.width - 16, _placeholderLabel.frame.size.height);
        [self sendSubviewToBack:_placeholderLabel];
    
//    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
//    {
//        [[self viewWithTag:999] setAlpha:1];
//    }
//    
    [super drawRect:rect];
}

#pragma setter getter
-(void)setMaxNumberLimited:(NSUInteger)maxNumberLimited{
    if (self.noDefault) {
        _maxNumberLimited = maxNumberLimited;
        _remainNumberLimited = maxNumberLimited;
    }else{
        _maxNumberLimited = maxNumberLimited;
        _remainNumberLimited = maxNumberLimited;
    }
    
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self.placeholderLabel setText:placeholder];
    
}

-(void)setPlaceholderTextAlignment:(NSTextAlignment)placeholderTextAlignment{
    _placeholderTextAlignment = placeholderTextAlignment;
    self.placeholderLabel.textAlignment = placeholderTextAlignment;
}
-(void)setRemainNumberLimitBlock:(GGTextViewLimitBlock)remainNumberLimitBlock{
    
    if (remainNumberLimitBlock) {
        _remainNumberLimitBlock = remainNumberLimitBlock;
    }
}


-(void)dealloc{
    
    NSLog(@"========limittextview dealloc");
}
@end
