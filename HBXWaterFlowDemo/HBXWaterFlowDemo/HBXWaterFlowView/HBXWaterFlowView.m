//
//  HBXWaterFlowView.m
//  HBXWaterFlowDemo
//
//  Created by 黄保贤 on 16/6/13.
//  Copyright © 2016年 黄保贤. All rights reserved.
//

#import "HBXWaterFlowView.h"

#define HBXWaterflowViewDefaultCellH 70
#define HBXWaterflowViewDefaultMargin 8
#define HBXWaterflowViewDefaultNumberOfColumns 3

@interface HBXWaterFlowView ()

/**
 *  所以cell的frame数据
 */
@property (nonatomic, strong) NSMutableArray *cellFrmaes;
/**
 *  正在展示的cell
 */
@property (nonatomic, strong) NSMutableArray *displayCells;
/**
 *  缓存池，用set，存放离开的cell
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;


@end

/**
 *
 */

@implementation HBXWaterFlowView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;

}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self reloadData];
}

- (CGFloat)cellWidth {
    NSInteger numberOfColumns = [self numberOsColumns];
    CGFloat leftM = [self marginForType:HBXWaterFlowMarginTypeLeft];
    CGFloat rightM = [self marginForType:HBXWaterFlowMarginTypeRight];
    CGFloat columnsM = [self marginForType:HBXWaterFlowMarginTypeColumn];
    return self.bounds.size.width - leftM - rightM - (numberOfColumns - 1)*columnsM/numberOfColumns;
}


/**
 *  总列数
 */
- (NSInteger)numberOsColumns {
    if ([self.dataSource respondsToSelector:@selector(numberOfColumsInWaterFlow:)]) {
        return [self.dataSource numberOfColumsInWaterFlow:self];
    }else {
        return HBXWaterflowViewDefaultNumberOfColumns;
    }

}
/**
 *  间距
 */
- (CGFloat)marginForType:(HBXWaterFlowMarginType)waterflowMargin {
    if ([self.delegate respondsToSelector:@selector(waterFlow:marginForType:)]) {
        return [self.delegate waterFlow:self marginForType:waterflowMargin];
    }
     return  HBXWaterflowViewDefaultNumberOfColumns;
}





#pragma mark - getter
- (NSMutableArray *)cellFrmaes {
    if (!_cellFrmaes) {
        _cellFrmaes = [[NSMutableArray alloc] init];
    }
    return _cellFrmaes;
}

- (NSMutableArray *)displayCells {
    if (!_displayCells) {
        _displayCells = [[NSMutableArray alloc] init];
    }
    return _displayCells;

}

- (NSMutableSet *)reusableCells {
    if (!_reusableCells) {
        _reusableCells = [[NSMutableSet alloc] init];
    }
    return _reusableCells;

}




@end
