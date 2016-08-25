//
//  UIButton+countDown.m
//  countdown
//
//  Created by WooY on 16/1/12.
//  Copyright © 2016年 WooY. All rights reserved.
//

#import "UIButton+countDown.h"
#import <objc/runtime.h>

@implementation UIButton (countDown)
static char strAddrKey = 'a';


- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color{

    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = [UIColor redColor];
                [self setTitle:title forState:0];
                self.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeOut % 60;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:0];
                self.backgroundColor =[UIColor grayColor];
                self.userInteractionEnabled = NO;
                
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);

}

-(void)canSelectButton
{
    self.enabled = YES;
    [self setBackgroundImage:[UIImage imageNamed:@"登陆注册按钮"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}
-(void)canNotSelectButton
{
    self.enabled = NO;
    [self setBackgroundImage:[UIImage imageNamed:@"登陆按钮框"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

}
- (NSString *)tag_id
{
    return objc_getAssociatedObject(self,&strAddrKey);
}
- (void)setTag_id:(NSString *)tag_id
{
    objc_setAssociatedObject(self, &strAddrKey, tag_id, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
