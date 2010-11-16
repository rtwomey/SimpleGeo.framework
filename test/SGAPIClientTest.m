//
//  SGAPIClientTest.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "SGAPIClient.h"


NSString * const TEST_URL_PREFIX = @"http://localhost:4567/";


@interface SGAPIClientTest : GHAsyncTestCase <SGAPIClientDelegate> { }
@end


@implementation SGAPIClientTest

- (BOOL)shouldRunOnMainThread
{
    return NO;
}

- (NSString *)consumerKey
{
    return @"";
}

- (NSString *)consumerSecret
{
    return @"";
}

- (void)testCreateWithDefaultURL
{
    NSURL *url = [NSURL URLWithString:SIMPLEGEO_URL_PREFIX];
    GHTestLog(@"SimpleGeo URL prefix: %@", SIMPLEGEO_URL_PREFIX);
    SGAPIClient *client = [SGAPIClient clientWithDelegate:self];

    GHAssertEqualObjects([client url], url, @"URLs don't match.");
}

- (void)testCreateWithURL
{
    NSURL *url = [NSURL URLWithString:TEST_URL_PREFIX];
    SGAPIClient *client = [SGAPIClient clientWithDelegate:self URL:url];

    GHAssertEqualObjects([client url], url, @"URLs don't match.");
}

- (void)testGetFeatureWithId
{
    [self prepare];

    NSURL *url = [NSURL URLWithString:TEST_URL_PREFIX];
    SGAPIClient *client = [SGAPIClient clientWithDelegate:self URL:url];

    [client getFeatureWithId:@"foo"];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void)didLoadFeature:(SGFeature *)feature withId:(NSString *)featureId
{
    GHTestLog(@"Feature was loaded: %@", [feature description]);

    GHAssertEqualObjects(featureId, @"foo", nil);

    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString:@"37.77241"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString:@"-122.40593"];

    GHAssertEqualObjects([[feature geometry] latitude], latitude, nil);
    GHAssertEqualObjects([[feature geometry] longitude], longitude, nil);

    GHAssertEqualObjects([[feature properties] objectForKey:@"name"], @"SimpleGeo San Francisco", nil);

    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetFeatureWithId)];
}

@end
