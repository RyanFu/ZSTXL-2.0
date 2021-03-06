//
//  LeveyTabBar.h
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 SlyFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeveyTabBarDelegate;

@interface LeveyTabBar : UIView
{
	UIImageView *_backgroundView;
	id<LeveyTabBarDelegate> _delegate;
	NSMutableArray *_buttons;
}
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, assign) id<LeveyTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIImageView *animatedView;
@property (nonatomic, assign) NSInteger fontSize;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray titleArray:(NSArray *)titleArray;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

@end
@protocol LeveyTabBarDelegate<NSObject>
@optional
- (BOOL)tabBar:(LeveyTabBar *)tabBar shouldSelectIndex:(NSInteger)index;
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index; 
@end
