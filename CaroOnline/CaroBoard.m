//
//  CaroBoard.m
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CaroBoard.h"

@implementation CaroBoard

/** Size of a cell
 */
static int CellSize=40;

/** Possition offset for represting cell image
 */
static float OffSetX=0;
static float OffSetY=0;

static float boundOffSetX=0;
static float boundOffSetY=-44;


/** Distance determine whether user  make a click or want to drag.
 */
static float clickBound=10;

@synthesize dragable,delegate;

/** Init Touchable Image View with an image
 *	
 */
-(id) initWithImage:(UIImage *)image Column:(int)column Row:(int)row Delegate:(id)Delegate{
	if ((self = [super initWithImage:image])) {
		//initialize here
		[self setUserInteractionEnabled:true];
		numColumn=column;
		numRow=row;
		table = [[NSMutableDictionary alloc]initWithCapacity:numColumn*numRow];
		
		dragable=true;		
		[self setFrame:CGRectMake(0, 0, numRow*CellSize, numColumn*CellSize)];
		
		if (Delegate == nil) {
			delegate=self;
		}else delegate=Delegate;
		
	}
	return self;
}

-(void) dealloc{
	//deallocating here
	
	[table release];
	table = nil;
	
	delegate=nil;
	
	[super dealloc];	
	NSLog(@"CaroBoard dealloc!");
}

/** Add SubView at Location
 *	Note: subview will be resized to CellSize
 */
-(void) addSubView:(UIView*)subview AtColumn:(int)column Row:(int)row{
	CGPoint point = [CaroBoard convertCellLocationAtColumn:column Row:row];

	if ([table objectForKey:[NSString stringWithFormat:@"(%d,%d)",(int)point.x,(int)point.y] ] != nil) {
		NSLog(@"Add Failed! There is Subview at %d,%d",column,row);
	}else{
		[subview setFrame:CGRectMake(point.x, point.y, CellSize, CellSize)];
		[table setObject:subview forKey:[NSString stringWithFormat:@"(%d,%d)",(int)point.x,(int)point.y] ];
		[self addSubview:subview];
	}
}

/** Remove SubView at Location
 */
-(void) removeSubViewAtColumn:(int)column Row:(int)row{
	CGPoint point = [CaroBoard convertCellLocationAtColumn:column Row:row];
	UIView* subview =[table objectForKey:[NSString stringWithFormat:@"(%d,%d)",(int)point.x,(int)point.y] ];
	if (subview != nil) {
		[table removeObjectForKey:[NSString stringWithFormat:@"(%d,%d)",(int)point.x,(int)point.y]];
		[subview removeFromSuperview];
	}else{
		NSLog(@"Remove Failed! Subview at %d,%d not excit",column,row);
	}

}

//****************************** CaroBoard Delegate ******************************

- (void)clickAtColumn:(int)column Row:(int)row{
	NSLog(@"Click at %d %d",column,row);
	
}

//****************************** Touch Delegate ******************************

/** Note the touch point and bring the touched view to the front 
 *
 */
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	CGPoint pt = [[touches anyObject] locationInView:self]; 

	//CGPoint cell= [CaroBoard convertCoordinatePoint:pt];
	//NSLog(@"Touch Begin at %d %d",(int)cell.x,(int)cell.y);
	
	startLocation = pt;
	totalMove = CGPointMake(0, 0);
    
	//This line is to make a small view easier to touch.
	//[[self superview] bringSubviewToFront:self];
}

/** As the user drags, move the view with the touch 
 *
 */
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
    //NSLog(@"Touches moving.");
	CGPoint pt = [[touches anyObject] locationInView:self];
	
	//Change frame to move view
	if (dragable) {
		CGRect frame = [self frame];
		frame.origin.x += pt.x - startLocation.x;
		frame.origin.y += pt.y - startLocation.y;
		//Fix drag out bound
		if(frame.origin.x>0 || frame.origin.x+self.frame.size.width<self.superview.frame.size.width+boundOffSetX)frame.origin.x -= pt.x - startLocation.x;
		if(frame.origin.y>0 || frame.origin.y+self.frame.size.height<self.superview.frame.size.height+boundOffSetY)frame.origin.y -= pt.y - startLocation.y;
		
		[self setFrame:frame];
	}
	
	//Sum move distance
	totalMove.x += abs(pt.x - startLocation.x);
	totalMove.y += abs(pt.y - startLocation.y);
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	CGPoint pt = [[touches anyObject] locationInView:self];
    CGPoint cell= [CaroBoard convertCoordinatePoint:pt];
	//NSLog(@"Touch End at %d %d",(int)cell.x,(int)cell.y);
	
	if (pow(totalMove.x,2)+pow(totalMove.y,2) < pow(clickBound,2) ) {
		//Click 
		[delegate clickAtColumn:(int)cell.x Row:(int)cell.y];
	}
	
} 

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	//NSLog(@"Touches cancelled.");

	
} 

//*********************** Class Implementation ****************************

/** Return column,row coordinate of Point(x,y)
 *	@return column and row are return as CGPoint, may need to force to int for usage.
 */
+(CGPoint)convertCoordinatePoint:(CGPoint)point{
	int x=point.x;
	int y=point.y;
	return CGPointMake( (x-x%CellSize)/CellSize, (y-y%CellSize)/CellSize );
}

/** Return x,y coordinate of column,row
 *
 */
+(CGPoint)convertCellLocationAtColumn:(int)column Row:(int)row{
	return CGPointMake(OffSetX+column*CellSize, OffSetY+row*CellSize);
}

/** Return CellSize
 *
 */
+(int)CellSize{
	return CellSize;
}

@end
