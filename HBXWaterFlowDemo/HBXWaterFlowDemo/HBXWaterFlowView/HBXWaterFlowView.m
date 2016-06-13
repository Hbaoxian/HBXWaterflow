//
//  HBXWaterFlowView.m
//  HBXWaterFlowDemo
//
//  Created by 黄保贤 on 16/6/13.
//  Copyright © 2016年 黄保贤. All rights reserved.
//

#import "HBXWaterFlowView.h"

#define HMWaterflowViewDefaultCellH 70
#define HMWaterflowViewDefaultMargin 8
#define HMWaterflowViewDefaultNumberOfColumns 3

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
