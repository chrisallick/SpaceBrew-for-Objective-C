//
//  ViewController.m
//  BlockTest
//
//  Created by chrisallick on 5/20/13.
//  Copyright (c) 2013 chrisallick. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    host = @"ws://sandbox.spacebrew.cc:9000";
    description = @"Basic SpaceBrew iOS example app. Pure Objective-C";
    name = @"iBrew";
    
    sb = [[SpaceBrew alloc] initWithHost:host andName:name andDescription:description];
    [sb setSpaceBrewDelegate:self];

    [sb addStringPublisherWithName:@"button_pub" andDefaultValue:@"cool"];
    [sb addStringSubscriberWithName:@"button_sub" andDefaultValue:@"cool" ];

    [sb connect];
    
//    [sb printConfig];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAdjustsImageWhenHighlighted:NO];
    [button setFrame:CGRectMake(30.0, 30.0, 100.0, 30.0)];
    [button setTag:0];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchDragExit];
    [self.view addSubview:button];
    
//    NSMutableDictionary *events = [[NSMutableDictionary alloc] init];

//    [events setObject:[^{
//        NSLog(@"void block in dictionary no params");
//    } copy] forKey:@"boom"];
//    
//    [events setObject:[^(NSString *msg){
//        NSLog(@"void block in dictionary with string param: %@", msg);
//    } copy] forKey:@"boom2"];
//    
//    void (^myStringBlock)() = ^(NSString *msg) {
//        NSLog(@"void block that takes string: %@", msg);
//    };
//    
//    void (^myVoidBlock)() = ^{
//        NSLog(@"void block with no params");
//    };
//    
//    [self execute:@"awesome" withVoidBlock:^{
//        NSLog(@"not passing pointer to block");
//    }];
//    
//    [self execute:@"cool!" withVoidBlock:myVoidBlock];
//    [self execute:@"cool!" withStringBlock:myStringBlock];
//    
//    
//    NSString *e = @"boom";
//    NSString *m = @"cool!";
//    
//    [self execute:m withVoidBlock:[events objectForKey:e]];
//    [self execute:@"cool!" withStringBlock:[events objectForKey:@"boom2"]];
}

#pragma mark- Events

-(void) onStringMessage:(NSString *)message withName:(NSString *)_name {
    if( [_name isEqualToString:@"button_sub"] ) {
        NSLog(@"received registered: %@ with type: %@", message, _name);
    } else {
        NSLog(@"received un-registered: %@ with type: %@", message, _name);
    }
}

#pragma mark- UI Events

-(void)onTouchUp:(UIButton *)sender {
    [UIView beginAnimations:@"animationOn" context:NULL];
    [UIView setAnimationDuration:.150];
    [sender setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
}

-(void)onTouchDown:(UIButton *)sender {
    [UIView beginAnimations:@"animationOn" context:NULL];
    [UIView setAnimationDuration:.150];
    [sender setTransform:CGAffineTransformMakeScale(0.85, 0.85)];
    [UIView commitAnimations];
}

-(void)onTap:(UIButton *)sender {
    [UIView animateWithDuration: 0.150
                          delay: 0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         [sender setTransform:CGAffineTransformIdentity];
                     }
                     completion:^(BOOL finished) {
                         if( [sender tag] == 0 ) {
                             [sb sendToRoute:@"button_pub" withValue:@"dope"];
                         }
                     }];
}

//-(void)execute:(NSString *)msg withVoidBlock:(void (^)(void))block {
//    block();
//}
//
//-(void)execute:(NSString *)msg withStringBlock:(void (^)(NSString *))block {
//    block(msg);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
