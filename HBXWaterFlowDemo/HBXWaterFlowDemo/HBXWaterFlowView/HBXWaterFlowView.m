//
//  HBXWaterFlowView.m
//  HBXWaterFlowDemo
//
//  Created by 黄保贤 on 16/6/13.
//  Copyright © 2016年 黄保贤. All rights reserved.
//

#import "HBXWaterFlowView.h"
#import "HBXWaterFlowViewCell.h"

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
@property (nonatomic, strong) NSMutableDictionary *displayCells;
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
/**
 *  清空之前所有数据
 *
 *  @param CGFloat <#CGFloat description#>
 *
 *  @return <#return value description#>
 */
- (void)reloadData {
    [self.displayCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayCells removeAllObjects];
    [self.cellFrmaes removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    //cell的总数
    NSInteger numberCells = [self.dataSource numberOfCellInWaterflowView:self];
    
    
    //总列数
    NSInteger numberOfColumns = [self.dataSource numberOfColumsInWaterFlow:self];
    
    //间距
    
    CGFloat topM = [self marginForType:HBXWaterFlowMarginTypeTop];
    CGFloat bottomM = [self marginForType:HBXWaterFlowMarginTypeBotton];
    CGFloat leftM = [self marginForType:HBXWaterFlowMarginTypeLeft];
    CGFloat rightM = [self marginForType:HBXWaterFlowMarginTypeRight];
    CGFloat ColumnM = [self marginForType:HBXWaterFlowMarginTypeColumn];
    CGFloat rowM = [self marginForType:HBXWaterFlowMarginTypeRow];
    
    CGFloat cellWidth = [self cellWidth];
    
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i = 0; i < numberOfColumns; i++) {
        maxYOfColumns[i] = 0.f;
    }
    
    for (int i = 0; i < numberCells; i++) {
        //cell处在第几列
        NSInteger cellColumn = 0;
        
        CGFloat maxOfCellColumn = maxYOfColumns[cellColumn];
        
        for (int j = 1; j < numberOfColumns; j++) {
            if (maxYOfColumns[j] < maxOfCellColumn) {
                cellColumn = j;
                maxOfCellColumn = maxYOfColumns[j];
            }
        }
        
        CGFloat cellH = [self heightAtIndex:i];
        
        CGFloat cellX = leftM + cellColumn * (cellWidth + ColumnM);
        
        CGFloat cellY = 0;
        
        if (maxOfCellColumn == 0.0) {
            cellY = topM;
        }else {
            cellY = maxOfCellColumn + rowM;
        }
        
        CGRect cellframe = CGRectMake(cellX, cellY, cellWidth, cellH);
        [self.cellFrmaes addObject:[NSValue valueWithCGRect:cellframe]];
    }
    
    //设置content
    
    CGFloat contentH = maxYOfColumns[0];
    
    for (int j = 0; j < numberOfColumns ; j++) {
        if (maxYOfColumns[j] > contentH) {
            contentH = maxYOfColumns[j];
        }
    }
    
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
}


- (CGFloat)cellWidth {
    NSInteger numberOfColumns = [self numberOsColumns];
    CGFloat leftM = [self marginForType:HBXWaterFlowMarginTypeLeft];
    CGFloat rightM = [self marginForType:HBXWaterFlowMarginTypeRight];
    CGFloat columnsM = [self marginForType:HBXWaterFlowMarginTypeColumn];
    return self.bounds.size.width - leftM - rightM - (numberOfColumns - 1)*columnsM/numberOfColumns;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger numberofCells = self.cellFrmaes.count;
    for (int i = 0; i < numberofCells; i++) {
        CGRect frame = [self.cellFrmaes[i] CGRectValue];
        
        HBXWaterFlowViewCell *cell = self.displayCells[@(i)];
        if ([self isInScreen:frame]) {
            if (cell == nil) {
                cell = [self.dataSource waterflowView:self cellAtIndex:i];
                cell.frame = frame;[self addSubview:cell];
                self.displayCells[@(i)] = cell;
            }
        } else {
            if (cell) {
                [cell removeFromSuperview];
                [self.displayCells removeObjectForKey:@(i)];
                [self.reusableCells addObject:cell];
            }
        }
    }
}


- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    __block HBXWaterFlowViewCell *reusableCell = nil;
    
    [self.reusableCells enumerateObjectsUsingBlock:^(HBXWaterFlowViewCell   * _Nonnull cell, BOOL * _Nonnull stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    if (reusableCell) {
        [self.reusableCells removeObject:reusableCell];
    }
    return reusableCell;
}


/**
 *  判断试图是否在屏幕上
 */

- (BOOL)isInScreen:(CGRect)frame {
    return  (CGRectGetMaxY(frame) > self.contentOffset.y) &&
    (CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height);

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

/**
 *  index对应的高度
 */
-  (CGFloat)heightAtIndex:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(waterflow:heightAtIndex:)]) {
        return [self.delegate waterflow:self heightAtIndex:index];
    }else {
        return HBXWaterflowViewDefaultCellH;
    }
}

#pragma mark - touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (![self.delegate respondsToSelector:@selector(waterflow:didSelectedAtIndex:)]) return;
    // 获得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber *selectIndex = nil;
    [self.displayCells enumerateKeysAndObjectsUsingBlock:^(id key, HBXWaterFlowViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    if (selectIndex) {
        [self.delegate waterflow:self didSelectedAtIndex:selectIndex.unsignedIntegerValue];
    }
}


#pragma mark - getter
- (NSMutableArray *)cellFrmaes {
    if (!_cellFrmaes) {
        _cellFrmaes = [[NSMutableArray alloc] init];
    }
    return _cellFrmaes;
}

- (NSMutableDictionary *)displayCells {
    if (!_displayCells) {
        _displayCells = [[NSMutableDictionary alloc] init];
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
