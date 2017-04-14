//
//  SwipeableCollectionViewCell.m
//  SwipeCollectionViewTest
//
//  Created by Oleksandr Pronin on 13.04.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

#import "SwipeableCollectionViewCell.h"
#import "SwipeableButtonView.h"

@implementation SwipeableCollectionViewCell

- (void)setupUI
{
    [super setupUI];
    
    UIColor *firstButtonTintColor = [UIColor whiteColor];
    NSMutableAttributedString *firstButtonTitle = [[NSMutableAttributedString alloc] initWithString:@"Account"];
    NSDictionary *firstButtonAttributes = @{
                                            NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                            NSForegroundColorAttributeName: firstButtonTintColor
                                            };
    [firstButtonTitle
     addAttributes:firstButtonAttributes
     range:NSMakeRange(0, firstButtonTitle.length)
     ];
    SwipeableButtonView *firstButtonView = [SwipeableButtonView
                                            initWithImage:[UIImage imageNamed:@"ic_account_balance"]
                                            tintColor:firstButtonTintColor
                                            attributedTitle:firstButtonTitle
                                            andBackgroundColor:UIColorFromRGB(0x15AA94)
                                            ];
    [self setButtonView:firstButtonView withIndex:0];
    
    UIColor *secondButtonTintColor = UIColorFromRGB(0x5A99BB);
    NSMutableAttributedString *seconddButtonTitle = [[NSMutableAttributedString alloc] initWithString:@"Bookmark"];
    NSDictionary *secondButtonAttributes = @{
                                             NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                             NSForegroundColorAttributeName: secondButtonTintColor
                                             };
    [seconddButtonTitle
     addAttributes:secondButtonAttributes
     range:NSMakeRange(0, seconddButtonTitle.length)
     ];
    SwipeableButtonView *secondButtonView = [SwipeableButtonView
                                             initWithImage:[UIImage imageNamed:@"ic_bookmark_border"]
                                             tintColor:secondButtonTintColor
                                             attributedTitle:seconddButtonTitle
                                             andBackgroundColor:UIColorFromRGB(0xE2EBF0)
                                             ];
    [self setButtonView:secondButtonView withIndex:1];
}

@end
