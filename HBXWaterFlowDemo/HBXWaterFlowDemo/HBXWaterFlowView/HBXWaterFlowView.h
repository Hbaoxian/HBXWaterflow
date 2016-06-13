//
//  HBXWaterFlowView.h
//  HBXWaterFlowDemo
//
//  Created by 黄保贤 on 16/6/13.
//  Copyright © 2016年 黄保贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBXWaterFlowView, HBXWaterFlowViewCell;



typedef enum {
    HBXWaterFlowMarginTypeTop,
    HBXWaterFlowMarginTypeBotton,
    HBXWaterFlowMarginTypeLeft,
    HBXWaterFlowMarginTypeRight,
    HBXWaterFlowMarginTypeColumn,
    HBXWaterFlowMarginTypeRow

} HBXWaterFlowMarginType;


@protocol HBXWaterFlowDataSource <NSObject>

@required
/*
 *  数据源
 */
- (NSInteger)numberOfCellInWaterFlowView:(HBXWaterFlowView *)waterFlow;
/*
 *  返回waterFlowViewCell
 */
- (HBXWaterFlowViewCell *)waterFLowView:(HBXWaterFlowView *)waterFlow  cellAtIndex:(NSInteger)index;






@end





@interface HBXWaterFlowView : UIScrollView

@end
