//
//  BoomView.m
//  CountDown
//
//  Created by Brandon Levasseur on 4/12/13.
//  Copyright (c) 2013 TheGamingArt. All rights reserved.
//

#import "BoomView.h"

@implementation BoomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"BoomView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (IBAction)removeView
{
    NSLog(@"Remove");
    if (self.completionBlock != nil) {
        
        [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeTranslation(self.frame.origin.x, self.frame.origin.y - self.superview.frame.size.height);
            self.alpha = 0; // also fade to transparent
        }completion:^(BOOL finished)
         {
             if (finished) {
                 [self removeFromSuperview];
             }
         }];

        self.completionBlock(YES);
        
    }
}

- (id)boomView
{
    BoomView *boomView = [[[NSBundle mainBundle] loadNibNamed:@"BoomView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([boomView isKindOfClass:[BoomView class]])
        return boomView;
    else
        return nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
