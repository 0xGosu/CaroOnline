//
//  CaroGameLogic.h
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CaroGameLogic : NSObject 


/** Make a new game
 *	
 */
-(void) newGame;


/** Check a step of player P
 *	@return =0 no issue, if return <0, not succesfully!.
 */
-(int) checkPlayer:(uint)p willMakeStepAtColumn:(int)x Row:(int)y;

/** Make a step for player P
 *	@return id of Winer (0 = no one win)
 */
 -(int) player:(uint)p makeStepAtColumn:(int)x Row:(int)y;


@end
