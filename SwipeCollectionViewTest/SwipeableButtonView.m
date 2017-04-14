//
//  SwipeableButtonView.m
//  SwipeCollectionViewTest
//
//  Created by Oleksandr Pronin on 13.04.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

#import "SwipeableButtonView.h"

@implementation SwipeableButtonView

+ (instancetype)initWithImage:(UIImage *)image
                    tintColor:(UIColor *)tintColor
              attributedTitle:(NSAttributedString *)attributedTitle
           andBackgroundColor:(UIColor *)backgroundColor
{
    NSString *nibName = NSStringFromClass(self);
    SwipeableButtonView *buttonView = (SwipeableButtonView *)[[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    if (tintColor) {
        UIImage *tintedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        buttonView.imageView.image = tintedImage;
        buttonView.imageView.tintColor = tintColor;
    } else {
        buttonView.imageView.image = image;
    }
    buttonView.titleLabel.attributedText = attributedTitle;
    buttonView.backgroundColor = backgroundColor;
    return buttonView;
}

@end
