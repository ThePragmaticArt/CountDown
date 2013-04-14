//
//  BoomView.m
//  CountDown
//
//  Created by Brandon Levasseur on 4/12/13.
//  Copyright (c) 2013 TheGamingArt. All rights reserved.
//

#import "BoomView.h"
#import <QuartzCore/QuartzCore.h>

@interface BoomView (){
    
    UIColor *_lightColor;
    UIColor *_endColor;
    CGRect _coloredBoxRect;
    CGRect _paperRect;

    
}
@property (strong, nonatomic) IBOutlet UIButton *againButton;

@end

#define SIZE_RATIO 1
#define LEFT_MARGIN 0
void drawGlossAndGradient(CGContextRef context, CGRect rect, UIColor *startColor,UIColor *endColor);


void drawLinearGradient(CGContextRef context, CGRect rect, UIColor *startColor, UIColor  *endColor);

@implementation BoomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"BoomView" owner:nil options:nil] lastObject];
        
        
        UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        // Set the background for any states you plan to use
        [self.againButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self.againButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;

        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

        _lightColor = [UIColor colorWithRed:0.71f green:0.71f blue:0.71f alpha:1.0];
        _endColor = [UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.0];
    }
    return self;
}

-(void)didMoveToSuperview{
    CGRect frame = self.frame;
    frame.origin.y = self.frame.origin.y + self.frame.size.height;
    self.frame = frame;
    [self animateView];

}


-(void)animateView
{

    
    [UIView setAnimationDelegate:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.transform = CGAffineTransformMakeTranslation (0, -self.superview.frame.size.height);
    [UIView commitAnimations];
    
    
    CABasicAnimation *bounceAnimation =
    [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounceAnimation.duration = 0.2;
    bounceAnimation.fromValue = [NSNumber numberWithInt:0];
    bounceAnimation.toValue = [NSNumber numberWithInt:20];
    bounceAnimation.repeatCount = 2;
    bounceAnimation.autoreverses = YES;
    bounceAnimation.fillMode = kCAFillModeForwards;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.additive = YES;
    [self.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.alpha = 1.0;
    [UIView commitAnimations];
    

}

- (IBAction)removeView
{
    NSLog(@"Remove");
    

    

        self.againButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);   
    

    
    if (self.completionBlock != nil) {

        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                self.completionBlock(YES);
                [self removeFromSuperview];
            }];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            self.transform = CGAffineTransformMakeTranslation (self.frame.origin.x, self.frame.origin.y + self.superview.frame.size.height);
            [UIView commitAnimations];
            [CATransaction commit];

        }];
        [UIView setAnimationDelegate:self];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        
        CABasicAnimation *bounceAnimation =
        [CABasicAnimation animationWithKeyPath:@"position.y"];
        bounceAnimation.duration = 0.2;
        bounceAnimation.fromValue = [NSNumber numberWithInt:self.frame.origin.y];
        bounceAnimation.toValue = [NSNumber numberWithInt:self.frame.origin.y + 40];
        bounceAnimation.repeatCount = 2;
        bounceAnimation.autoreverses = YES;
        bounceAnimation.fillMode = kCAFillModeForwards;
        bounceAnimation.removedOnCompletion = NO;
        bounceAnimation.additive = YES;
        [self.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
        [UIView commitAnimations];
        [CATransaction commit];
        
    }
}


- (void)drawRect:(CGRect)rect
{

    
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

    UIColor *shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    
    
    CGContextSetFillColorWithColor(context, whiteColor.CGColor);
    CGContextFillRect(context, _paperRect);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor.CGColor);
    CGContextSetFillColorWithColor(context, _lightColor.CGColor);
    CGContextFillRect(context, _coloredBoxRect);
    CGContextRestoreGState(context);
    
    drawGlossAndGradient(context, _coloredBoxRect, _lightColor, _endColor);
    
    // Draw stroke
    CGContextSetStrokeColorWithColor(context, _endColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, rectFor1PxStroke(_coloredBoxRect));
    
    
    if ([self.againButton state] == UIControlStateNormal) {
        
    self.againButton.layer.cornerRadius = 8.0f;
    self.againButton.layer.masksToBounds = NO;
    self.againButton.layer.borderWidth = 1.0f;
    
    self.againButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.againButton.layer.shadowOpacity = 0.8;
    self.againButton.layer.shadowRadius = 3.0f;
    self.againButton.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    }
    

}


void drawGlossAndGradient(CGContextRef context, CGRect rect, UIColor *startColor, UIColor *endColor) {
    
    drawLinearGradient(context, rect, startColor, endColor);
    
    UIColor *glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35];
    UIColor *glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    
    drawLinearGradient(context, topHalf, glossColor1, glossColor2);
    
}

void drawLinearGradient(CGContextRef context, CGRect rect, UIColor *startColor, UIColor *endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
}

CGRect rectFor1PxStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

-(void)layoutSubviews{ //called when view changes size
    
    CGFloat coloredBoxMargin = 0.0;
    CGFloat coloredBoxHeight = self.frame.size.height;
    _coloredBoxRect = CGRectMake(coloredBoxMargin, coloredBoxMargin, (self.bounds.size.width-coloredBoxMargin*2) * SIZE_RATIO,coloredBoxHeight);
    
    CGFloat paperMargin = 9.0;
    _paperRect = CGRectMake(paperMargin, CGRectGetMaxY(_coloredBoxRect), (self.bounds.size.width-paperMargin*2) * SIZE_RATIO, self.bounds.size.height-CGRectGetMaxY(_coloredBoxRect));
    
    self.frame = _coloredBoxRect;
    
    CGRect frame = self.frame;
    frame.origin.x += LEFT_MARGIN;
    self.frame = frame;
    
    
}





@end
