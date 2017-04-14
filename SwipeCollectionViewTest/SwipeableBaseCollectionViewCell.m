//
//  SwipeableBaseCollectionViewCell.m
//  SwipeCollectionViewTest
//
//  Created by Oleksandr Pronin on 12.04.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

#import "SwipeableBaseCollectionViewCell.h"

static CGFloat const kBounceValue = 10.0f;
static CGFloat const kButtonsCount = 2.f;

@interface SwipeableBaseCollectionViewCell() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *secondButtonLeadingSpace;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *firstButtonContainerView;
@property (weak, nonatomic) IBOutlet UIView *secondButtonContainerView;

@end

@implementation SwipeableBaseCollectionViewCell

#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
}

#pragma mark - Public

- (void)openCell
{
    [self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}

- (void)closeCell
{
    [self resetConstraintContstantsToZero:true notifyDelegateDidClose:false];
}

- (void)setButtonView:(UIView *)buttonView withIndex:(NSUInteger)index
{
    UIView *containerView = nil;
    switch (index) {
        case 0:
        {
            containerView = self.firstButtonContainerView;
        }
            break;
        case 1:
        {
            containerView = self.secondButtonContainerView;
        }
            break;
            
        default:
            return;
    }
    
    for (UIView *view in buttonView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.tag = index;
            UIButton *button = (UIButton *)view;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    buttonView.translatesAutoresizingMaskIntoConstraints = false;
    [containerView addSubview:buttonView];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[buttonView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(buttonView)]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[buttonView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(buttonView)]];
}

#pragma mark - Helper

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.containerView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.containerView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {
                panningLeft = YES;
            }
            if (self.startingRightLayoutConstraintConstant == 0)
            {
                //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonsTotalWidth]);
                    if (constant == [self buttonsTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                        CGFloat overlapConstant = constant / kButtonsCount;
                        self.secondButtonLeadingSpace.constant = overlapConstant;
                    }
                }
            } else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                        CGFloat overlapConstant = constant / kButtonsCount;
                        self.secondButtonLeadingSpace.constant = overlapConstant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonsTotalWidth]);
                    if (constant == [self buttonsTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant;
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was opening
                CGFloat halfOfButtonWidth = [self buttonWidth] / 2;
                if (self.contentViewRightConstraint.constant >= halfOfButtonWidth) {
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                //Cell was closing
                CGFloat halfOfLastButton = [self buttonWidth] * (kButtonsCount - 0.5f);
                if (self.contentViewRightConstraint.constant >= halfOfLastButton) {
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //Cell was open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
        default:
            break;
    }
}

- (CGFloat)buttonWidth
{
    return [self buttonsTotalWidth] / kButtonsCount;
}

- (CGFloat)buttonsTotalWidth
{
    return self.buttonsView.bounds.size.width;
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate
{
    if (notifyDelegate) {
        [self.delegate cellDidClose:self];
    }
    
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    self.secondButtonLeadingSpace.constant = 0;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate
{
    if (notifyDelegate) {
        [self.delegate cellDidOpen:self];
    }
    
    //1
    if (self.startingRightLayoutConstraintConstant == [self buttonsTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonsTotalWidth]) {
        return;
    }
    //2
    self.contentViewLeftConstraint.constant = -[self buttonsTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonsTotalWidth] + kBounceValue;
    self.secondButtonLeadingSpace.constant = [self buttonWidth];
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        //3
        self.contentViewLeftConstraint.constant = -[self buttonsTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonsTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            //4
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.2;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

- (void)setupUI
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self addGestureRecognizer:self.panRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Actions

- (void)buttonAction:(UIButton *)sender
{
    [self.delegate actionButtonWithIndex:sender.tag forItem:self.tag];
}

@end
