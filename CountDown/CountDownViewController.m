//
//  CountDownViewController.m
//  CountDown
//
//  Created by Brandon Levasseur on 4/12/13.
//  Copyright (c) 2013 TheGamingArt. All rights reserved.
//

#import "CountDownViewController.h"
#import "BoomView.h"
#import <QuartzCore/QuartzCore.h>

#define timeToCountDownFrom 10
#define maxScaleForLabel 2

@interface CountDownViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *labelAnimation;

@end

@implementation CountDownViewController
{
    NSDate *_startDate;
    double _scale;
}

#pragma mark - textField delegate functions

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"YES");
    if ([textField.text isEqualToString:@"1234"]) {
        [self endCountDown];
        BoomView *boomView = [[BoomView alloc] init];
        [boomView setCompletionBlock:^(BOOL again)
         {
             if (again) {
                 [self initiateCountDown];
             }
         }];

        boomView.displayLabel.text = @"Launch Aborted";
        [self.view addSubview:boomView];
    }
    
    [self clearAbortInfo];
    return YES;
}




#pragma mark -  Animations for label

-(void)fadeLabelInAndOut
{

    CAKeyframeAnimation *fadeInAndOut = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [fadeInAndOut setValues:@[@1.0, @0.5]];
    [fadeInAndOut setAutoreverses:YES];
    [fadeInAndOut setDuration:0.5];
    [fadeInAndOut setRepeatCount:HUGE_VALF];
    [self.timerLabel.layer addAnimation:fadeInAndOut forKey:@"fadeInAndOut"];
    
    
    

}

-(void)scaleLabel
{

    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval elaspsedTime = [currentDate timeIntervalSinceDate:_startDate];
    NSTimeInterval delta = timeToCountDownFrom - elaspsedTime;
//    // Create the keyframe animation object
//    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    // Set the animation's delegate to self so that we can add callbacks if we want
//    scaleAnimation.delegate = self;
    // Create the transform; we'll scale x and y by 1.5, leaving z alone
    // since this is a 2D animation.
    _scale = (_scale + (_scale/delta));
    CATransform3D transform = CATransform3DMakeScale(_scale, _scale, 1); // Scale in x and y
//    // Add the keyframes.  Note we have to start and end with CATransformIdentity,
//    // so that the label starts from and returns to its non-transformed state.
//    [scaleAnimation setValues:@[[NSValue valueWithCATransform3D:CATransform3DIdentity],[NSValue valueWithCATransform3D:transform],[NSValue valueWithCATransform3D:CATransform3DIdentity]]];
//    // set the duration of the animation
//    [scaleAnimation setDuration: .5];
//    //[scaleAnimation setRepeatCount:HUGE_VALF];
//    // animate your label layer = rock and roll!
//    [self.timerLabel.layer addAnimation:scaleAnimation forKey:@"scaleText"];
//    
    [UIView animateWithDuration:0.5f animations:^{
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            scaleAnimation.delegate = self;
        [scaleAnimation setValues:@[[NSValue valueWithCATransform3D:CATransform3DIdentity],[NSValue valueWithCATransform3D:transform]/*,[NSValue valueWithCATransform3D:CATransform3DIdentity]*/]];
        [self.timerLabel.layer addAnimation:scaleAnimation forKey:@"scaleText"];
    }completion:^(BOOL finished){
//            [self rockLabel];
    }];
    

    
    
   
}

-(void)rockLabel
{
#pragma mark - spinning animation for label
    NSDate *currentDate = [NSDate date];
    NSTimeInterval elaspsedTime = [currentDate timeIntervalSinceDate:_startDate];

    NSTimeInterval delta = timeToCountDownFrom - elaspsedTime;
//    double randomAngle = arc4random_uniform(delta);
    
    //Create a basic animation
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"]; //noted in the API under Core Animation Extensions To Key-Value Coding
    [spin setDelegate:self]; //this is so the message animationDidStop:finished can be sent to the delegate when the animation finished?
    //fromValue is implied as the current location of the layer
    [spin setFromValue:@(-M_PI_4 / delta  * arc4random_uniform(2))];
    [spin setToValue:@(M_PI_4 / delta * arc4random_uniform(2))]; //transform.rotation is noted in radians format within the documentation. This means that 2*PI radians is a full rotation... 0 radians is no rotation
    [spin setDuration:0.0];
//    [spin setAutoreverses:YES];
//    [spin setRepeatCount:HUGE_VALF];
    
    
    //Kick off the animation by adding it to the layer
    [self.timerLabel.layer addAnimation:spin forKey:@"spinAnimation"]; //keep in mind that this key is NOT the key path, it is simply a human-readable name for this animation...

}

-(void)clearAbortInfo
{
    self.codeTextView.text = @"";
    [self.codeTextView resignFirstResponder];
}

#pragma mark - Coundown functions

-(void)initiateCountDown
{
    _scale = maxScaleForLabel;
    _startDate = [NSDate date];
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    self.labelAnimation = [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(scaleLabel) userInfo:nil repeats:YES];
    //[self rockLabel];
    [self fadeLabelInAndOut];
    
    
}


-(void)countDown
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval elaspsedTime = [currentDate timeIntervalSinceDate:_startDate];
    
    NSTimeInterval delta = timeToCountDownFrom - elaspsedTime;
    
    if (delta <= 0) {
        [self countedDownAllTheWay];
        self.timerLabel.text = @"Boom!";
        return;
    }
    

    
    self.timerLabel.text = [NSString stringWithFormat:@"Self Destruct In: %f", delta];
}

-(void)endCountDown
{
    [self.timer invalidate];
    [self.labelAnimation invalidate];
    self.timerLabel.text = @"Abort!";
}


-(void)countedDownAllTheWay
{
    [self endCountDown]; //Have to invalidate here, otherwise the clock keeps ticking over
    [self clearAbortInfo];
    BoomView *boomView = [[BoomView alloc] init];
    [self.view addSubview:boomView];
    
   // NSLog(@"SuperView : %@", boomView.superview);
    [boomView setCompletionBlock:^(BOOL again)
     {
         if (again) {
             

             [self initiateCountDown];
             
         }
     }];
    
    
    }


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(initiateCountDown) userInfo:nil repeats:YES];
    [self initiateCountDown];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [[NSTimer alloc]init];
    }
    return _timer;
}






@end
