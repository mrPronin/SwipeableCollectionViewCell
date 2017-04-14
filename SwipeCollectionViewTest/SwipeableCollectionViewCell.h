//
//  SwipeableCollectionViewCell.h
//  SwipeCollectionViewTest
//
//  Created by Oleksandr Pronin on 13.04.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeableBaseCollectionViewCell.h"

@interface SwipeableCollectionViewCell : SwipeableBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
