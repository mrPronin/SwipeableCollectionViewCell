//
//  SwipeableBaseCollectionViewCell.h
//  SwipeCollectionViewTest
//
//  Created by Oleksandr Pronin on 12.04.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeableButtonView.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@protocol SwipeableCellDelegate <NSObject>

- (void)actionButtonWithIndex:(NSUInteger)buttonIndex forItem:(NSInteger)itemIndex;

- (void)cellDidOpen:(UICollectionViewCell *)cell;
- (void)cellDidClose:(UICollectionViewCell *)cell;

@end

@interface SwipeableBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;

- (void)openCell;
- (void)closeCell;

- (void)setupUI;

- (void)setButtonView:(UIView *)buttonView withIndex:(NSUInteger)index;

@end
