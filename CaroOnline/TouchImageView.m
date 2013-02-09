//
//  TouchImageView.m
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchImageView.h"

@implementation TouchImageView

/** Init Touchable Image View
 *	
 */
-(id) init{
	if ((self = [super init])) {
		//initialize here
		[self setUserInteractionEnabled:true];
	}
	return self;
}

/** Init Touchable Image View with an image
 *	
 */
-(id) initWithImage:(UIImage *)image{
	if ((self = [super initWithImage:image])) {
		//initialize here
		[self setUserInteractionEnabled:true];
	}
	return self;
}

-(void) dealloc{
	//deallocating here
	
	[super dealloc];	
}

/** Note the touch point and bring the touched view to the front 
 *
 */
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    NSLog(@"Touches Began.");
	CGPoint pt = [[touches anyObject] locationInView:self]; 
    startLocation = pt;
    //NSLog(@"Touch Began at %f %f",pt.x,pt.y);
    
    [[self superview] bringSubviewToFront:self];
}

/** As the user drags, move the flower with the touch 
 *
 */
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
    NSLog(@"Touches moving.");
	CGPoint pt = [[touches anyObject] locationInView:self];
	CGRect frame = [self frame];
	frame.origin.x += pt.x - startLocation.x;
	frame.origin.y += pt.y - startLocation.y;
	[self setFrame:frame];
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

{
	
	NSLog(@"Touches ended.");
	
} 

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event

{
	
	NSLog(@"Touches cancelled.");
	
} 

@end
