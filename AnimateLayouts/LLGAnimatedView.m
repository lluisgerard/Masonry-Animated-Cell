//
//  LLGAnimatedView.m
//  AnimateLayouts
//
//  Created by Lluis Gerard on 10/01/14.
//  Copyright (c) 2014 Lluis Gerard. All rights reserved.
//

#import "LLGAnimatedView.h"

#import "Masonry.h"

@interface LLGAnimatedView ()
@property (strong, nonatomic) UIView*           viewThatGrows;
@property (strong, nonatomic) id<MASConstraint> animateConstraint;
@property (assign, nonatomic) dispatch_once_t   onceToken;
@property (strong, nonatomic) UILabel*          numberLabel;
@end

@implementation LLGAnimatedView


#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // Customize
    self.backgroundColor = [UIColor blackColor];

    // Add views
    [self addSubview:self.viewThatGrows];
    [self addSubview:self.numberLabel];
    
    // Constraints
    [self.viewThatGrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        self.animateConstraint = make.width.equalTo(@0);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewThatGrows);
        make.left.equalTo(self.viewThatGrows).offset(5).priorityHigh();
        make.right.equalTo(self.viewThatGrows).offset(-5).priorityLow();
        make.bottom.equalTo(self.viewThatGrows);
    }];
    
    return self;
}

#pragma mark - Public methods

- (void)setPercentage:(float)percentage {
    
    _percentage = percentage;
    
    /////////////////////////////
    // Back to first state
    self.animateConstraint.equalTo(@0);
    [self layoutIfNeeded];

    /////////////////////////////
    // Block with the animation
    void(^growBlock)() = ^() {
        
        if (self.frame.size.width == 0) {
            NSLog(@"Warning :: Frame size can't be zero");
            return;
        };

        float max = 100; // 100 is the maximum number for a percentage
        float value = _percentage;
        float grade = max / value; // Calculate the grade (divide)
        
        // Show value on label
        self.numberLabel.text = [NSString stringWithFormat:@"%i%%", (int)value];

        // Zero means that we don't need to animate (we are done)
        if (grade == 0) return;

        // For greater numbers animate using view width
        float width = self.frame.size.width / grade;
        self.animateConstraint.equalTo(@(width));
        [UIView animateWithDuration:1.0f
                              delay:0.0f
             usingSpringWithDamping:0.4f
              initialSpringVelocity:0.9f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self layoutIfNeeded]; // Autolayout way to animate
                         } completion:^(BOOL finished) {

                         }];
    };
    
    /////////////////////////////////////////////////////////////
    // Always but the first time we just trigger the animation
    if (_onceToken != 0) growBlock();
    
    /////////////////////////////////////////////////////////////////////////////////
    // Just for the first time (without the dispatch_after you can't see the animation)
    dispatch_once(&_onceToken, ^{
        NSLog(@"First instantiation!");
        double delayInSeconds = 0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            growBlock();
        });
    });

}

#pragma mark - Instantiations

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = UILabel.new;
        [_numberLabel setTextAlignment:NSTextAlignmentRight];
        [_numberLabel setTextColor:[UIColor whiteColor]];
        [_numberLabel setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    }
    return _numberLabel;
}

- (UIView *)viewThatGrows {
    if (!_viewThatGrows) {
        _viewThatGrows = UIView.new;
        _viewThatGrows.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:241.0f/255.0f blue:71.0f/255.0f alpha:1.0f];
    }
    return _viewThatGrows;
}

@end
