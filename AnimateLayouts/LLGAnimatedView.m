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

- (void)layoutSubviews {
    [super layoutSubviews];
    
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
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self layoutIfNeeded]; // Autolayout way to animate
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

#pragma mark - Public methods

- (void)setPercentage:(float)percentage {
    
    /////////////////////////////
    // Back to first state
    self.animateConstraint.equalTo(@0);
    [self setNeedsLayout]; // Force layout to 0

    ///////////////////////////////
    // Animate the new percentage! (at some point, this calls layoutSubviews that will animate it!)
    _percentage = percentage;
    [self setNeedsLayout];
    
}

#pragma mark - Instantiations

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = UILabel.new;
        [_numberLabel setTextAlignment:NSTextAlignmentRight];
        [_numberLabel setTextColor:[UIColor whiteColor]];
        [_numberLabel setFont:[UIFont systemFontOfSize:10.0f]];
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
