//
//  CaroBoard.h
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>






@protocol CaroBoardDelegate <NSObject>

/** Handle Touch event Click on CaroBoard
 *	
 */
- (void)clickAtColumn:(int)column Row:(int)row;

@end




@interface CaroBoard : UIImageView { 
    CGPoint startLocation;
	CGPoint totalMove;
	int numRow;
	int numColumn;
	NSMutableDictionary * table;
	
}

@property (nonatomic) Boolean dragable;
@property (nonatomic,assign)id delegate;

/** Init Touchable Image View with an image
 *	
 */
-(id) initWithImage:(UIImage *)image Column:(int)column Row:(int)row Delegate:(id)Delegate;

/** Add SubView at Location
 *	Note: subview will be resized to CellSize
 */
-(void) addSubView:(UIView*)subview AtColumn:(int)column Row:(int)row;

/** Remove SubView at Location
 */
-(void) removeSubViewAtColumn:(int)column Row:(int)row;


//*********************** Class Implementation ****************************

/** Return column,row coordinate of Point(x,y)
 *	@return column and row are return as CGPoint, may need to force to int for usage.
 */
+(CGPoint)convertCoordinatePoint:(CGPoint)point;

/** Return x,y coordinate of column,row
 *
 */
+(CGPoint)convertCellLocationAtColumn:(int)column Row:(int)row;

/** Return CellSize
 *
 */
+(int)CellSize;


@end
