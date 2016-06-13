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
- (NSInteger)numberOfCellInWaterflowView:(HBXWaterFlowView *)waterflow;
/*
 *  返回waterFlowViewCell
 */
- (HBXWaterFlowViewCell *)waterflowView:(HBXWaterFlowView *)waterFlow  cellAtIndex:(NSInteger)index;

@optional
/*
 *  一共有多少列
 */

- (NSInteger)numberOfColumsInWaterFlow:(HBXWaterFlowView *)waterflow;

@end


@protocol HBXWaterflowDelegate <NSObject>

@optional

/*
 *  返回每个cell的高度
 */
- (CGFloat)waterflow:(HBXWaterFlowView *)waterflow  heightAtIndex:(NSInteger)index;
/*
 *  选中index位置的cell
 */
- (void)waterflow:(HBXWaterFlowView *)waterflow didSelectedAtIndex:(NSInteger)index;
/*
 *  返回间距
 */
- (CGFloat)waterFlow:(HBXWaterFlowView *)water  marginForType:(HBXWaterFlowMarginType)type;


@end



@interface HBXWaterFlowView : UIScrollView

@property (nonatomic, assign) id<HBXWaterFlowDataSource> dataSource;
@property (nonatomic, assign) id<HBXWaterflowDelegate> delegate;

- (void)reloadData;
- (CGFloat)cellWidth;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;



@end
