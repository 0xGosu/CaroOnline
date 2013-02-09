//
//  CaroOfflineViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaroBoard.h"
#import "CaroGameLogic.h"

@interface CaroOfflineViewController : UIViewController <CaroBoardDelegate>{
	UIImage* imageX; 
	UIImage* imageO;
}

/** Init a view that can play a caro game on it
 *	Provide resources by Images.
 */
- (id)initWithCaroBoard:(UIImage*)BoardImage imageX:(UIImage*)imgX imageO:(UIImage*)imgO;

@property (nonatomic, retain) CaroBoard * board;
@property (nonatomic, retain) CaroGameLogic * gameControl;

@property (nonatomic) int player;

@end
