//
//  BoomView.h
//  CountDown
//
//  Created by Brandon Levasseur on 4/12/13.
//  Copyright (c) 2013 TheGamingArt. All rights reserved.
//

@interface BoomView : UIView

typedef void (^BoomViewCompletionBlock)(BOOL again);

@property (nonatomic, copy) BoomViewCompletionBlock completionBlock;
@property (strong, nonatomic) IBOutlet UILabel *displayLabel;

@end
