//
//  SpaceBrew.h
//  BlockTest
//
//  Created by chrisallick on 6/14/14.
//  Copyright (c) 2014 chrisallick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@protocol SpaceBrewDelegate

-(void) onStringMessage:(NSString *)message withName:(NSString *)name;

@end

@interface SpaceBrew : NSObject <SRWebSocketDelegate> {
    SRWebSocket *webSocket;
    
    NSString *host;
    NSString *description;
    NSString *name;
    
    NSMutableDictionary *config;
    
    BOOL connected;
    
    __weak id <SpaceBrewDelegate> spaceBrewDelegate;
}

@property (nonatomic, weak) id <SpaceBrewDelegate> spaceBrewDelegate;

-(id) initWithHost:(NSString *)host andName:(NSString *)name andDescription:(NSString *)description;

-(void) addStringSubscriberWithName:(NSString *)_name andDefaultValue:(NSString *)_value;
-(void) addStringPublisherWithName:(NSString *)_name andDefaultValue:(NSString *)_value;

-(void) connect;
-(void) sendToRoute:(NSString *)name withValue:(NSString *)value;
-(void) printConfig;

@end
