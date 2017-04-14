//
//  SwipeableButtonView.h
//  SwipeCollectionViewTest
//
//  Created by Oleksandr Pronin on 13.04.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeableButtonView : UIView

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)initWithImage:(UIImage *)image
         tintColor:(UIColor *)tintColor
       attributedTitle:(NSAttributedString *)attributedTitle
           andBackgroundColor:(UIColor *)backgroundColor;

@end
