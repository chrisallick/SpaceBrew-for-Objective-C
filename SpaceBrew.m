//
//  SpaceBrew.m
//  BlockTest
//
//  Created by chrisallick on 6/14/14.
//  Copyright (c) 2014 chrisallick. All rights reserved.
//

#import "SpaceBrew.h"

@implementation SpaceBrew

@synthesize spaceBrewDelegate;

-(id) initWithHost:(NSString *)_host andName:(NSString *)_name andDescription:(NSString *)_description {
    self = [super init];
    if (self) {
        connected = NO;
        
        host = _host;
        name = _name;
        description = _description;

        NSMutableDictionary *configs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        name, @"name",
                                        description,@"description",
                                        nil];
        
        NSMutableDictionary *publish = [[NSMutableDictionary alloc] init];
        [publish setObject:[[NSMutableArray alloc] init] forKey:@"messages"];
        
        [configs setObject:publish forKey:@"publish"];
        
        NSMutableDictionary *subscribe = [[NSMutableDictionary alloc] init];
        [subscribe setObject:[[NSMutableArray alloc] init] forKey:@"messages"];
        
        [configs setObject:subscribe forKey:@"subscribe"];
        
        config = [NSMutableDictionary dictionaryWithObject:configs forKey:@"config"];
    }
    return self;
}

#pragma mark- SpaceBrew

-(void) connect {
    [self _reconnect];
}

-(void) updateConfig {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:config
                                                       options:0
                                                         error:nil];
    NSString *configJSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    [webSocket send:configJSONString];
}

-(void) printConfig {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:config
                                                       options:0
                                                         error:nil];
    NSString *configJSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", configJSONString);
}

-(void) addStringPublisherWithName:(NSString *)_name andDefaultValue:(NSString *)_value {
    NSMutableDictionary *puber = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  _name,@"name",
                                  @"string",@"type",
                                  _value,@"value",
                                  nil];
    
    [[[[config objectForKey:@"config"] objectForKey:@"publish"] objectForKey:@"messages"] addObject:puber];
    
    if( connected ) {
        [self updateConfig];
    }
}

-(void) addStringSubscriberWithName:(NSString *)_name andDefaultValue:(NSString *)_value {
    NSMutableDictionary *suber = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  _name,@"name",
                                  @"string",@"type",
                                  nil];
    
    [[[[config objectForKey:@"config"] objectForKey:@"subscribe"] objectForKey:@"messages"] addObject:suber];
    
    if( connected ) {
        [self updateConfig];
    }
}

-(void) sendToRoute:(NSString *)_name withValue:(NSString *)_value {
    NSDictionary *msg = @{ @"message":@{@"clientName":name, @"name":_name, @"type":@"string", @"value":_value}};

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msg
                                                       options:0
                                                         error:nil];
    NSString *msgJSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    if( connected ) {
        [webSocket send:msgJSONString];
    }
}

#pragma mark- WebSocket

- (void)_reconnect {
    connected = NO;
    webSocket.delegate = nil;
    [webSocket close];
    webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", host]]]];
    
    webSocket.delegate = self;
    
    [webSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)_webSocket {
    connected = YES;
    
    [self updateConfig];
}

- (void)webSocket:(SRWebSocket *)_webSocket didFailWithError:(NSError *)error {
    connected = NO;
    webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [spaceBrewDelegate onStringMessage:[[dataDictionary objectForKey:@"message"] valueForKey:@"value"] withName:[[dataDictionary objectForKey:@"message"] valueForKey:@"name"]];
}

- (void)webSocket:(SRWebSocket *)_webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    connected = NO;
    webSocket = nil;
}

@end
