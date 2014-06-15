//
//  ViewController.h
//  BlockTest
//
//  Created by chrisallick on 5/20/13.
//  Copyright (c) 2013 chrisallick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpaceBrew.h"

@interface ViewController : UIViewController<SpaceBrewDelegate> {
    SpaceBrew *sb;

    NSString *host;
    NSString *description;
    NSString *name;
    
    BOOL connected;
}

@end
