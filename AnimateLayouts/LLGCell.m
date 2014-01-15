//
//  LLGCell.m
//  AnimateLayouts
//
//  Created by Lluis Gerard on 10/01/14.
//  Copyright (c) 2014 Lluis Gerard. All rights reserved.
//

#import "LLGCell.h"

#import "LLGAnimatedView.h"

#import "Masonry.h"

@interface LLGCell ()
@property (strong, nonatomic) LLGAnimatedView* animatedView;
@end

@implementation LLGCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    // Customize the cell
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    // Add Views
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.animatedView];
    
    // Constraints
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 15, 10, 10);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(padding.top);
        make.left.equalTo(self).offset(padding.left);
        make.right.equalTo(self).offset(-padding.right);
    }];
    
    [self.animatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(padding.top);
        make.left.equalTo(self).offset(padding.left);
        make.right.equalTo(self).offset(-padding.right);
        make.bottom.equalTo(self).offset(-padding.bottom);
    }];
    
    return self;
}

#pragma mark - Public methods

// Here I usually set the model's class but we only have percentage here :)
- (void)setPercentage:(float)percentage {
    
    _percentage = percentage;

    // Set the percentage to the child view (that triggers the animation)
    [self.animatedView setPercentage:_percentage];

}

#pragma mark - Instantiations

- (UILabel *)titleLabel {
    if (!_titleLabel) _titleLabel = UILabel.new;
    [_titleLabel setTextColor:[UIColor darkGrayColor]];
    return _titleLabel;
}

- (LLGAnimatedView *)animatedView {
    if (!_animatedView) _animatedView = LLGAnimatedView.new;
    return _animatedView;
}

@end
