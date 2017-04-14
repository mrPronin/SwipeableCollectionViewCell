//
//  ViewController.m
//  SwipeCollectionViewTest
//
//  Created by Oleksandr Pronin on 12.04.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

#import "ViewController.h"
#import "SwipeableCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SwipeableCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableSet *cellsCurrentlyEditing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellsCurrentlyEditing = [NSMutableSet new];
    self.collectionView.multipleTouchEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = NSStringFromClass([SwipeableCollectionViewCell class]);
    SwipeableCollectionViewCell *cell = (SwipeableCollectionViewCell *)[collectionView
                                                                        dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                        forIndexPath:indexPath
                                                                        ];
    cell.delegate = self;
    cell.tag = indexPath.row;
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"Collection view cell %ld", (long)indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, 142.f);
}

#pragma mark - SwipeableCellDelegate

- (void)actionButtonWithIndex:(NSUInteger)buttonIndex forItem:(NSInteger)itemIndex
{
    NSLog(@"button %lu item: %ld", (unsigned long)buttonIndex, (long)itemIndex);
}

- (void)cellDidOpen:(UICollectionViewCell *)cell
{
    NSIndexPath *newIndexPath = [self.collectionView indexPathForCell:cell];
    if (self.cellsCurrentlyEditing.count) {
        // should close previous opened cell
        NSIndexPath *previousIndexPath = self.cellsCurrentlyEditing.anyObject;
        if ([previousIndexPath isEqual:newIndexPath]) {
            return;
        }
        SwipeableCollectionViewCell *previousCell = (SwipeableCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:previousIndexPath];
        [previousCell closeCell];
        [self.cellsCurrentlyEditing removeObject:previousIndexPath];
    }
    [self.cellsCurrentlyEditing addObject:newIndexPath];
}

- (void)cellDidClose:(UICollectionViewCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:[self.collectionView indexPathForCell:cell]];
}

@end
