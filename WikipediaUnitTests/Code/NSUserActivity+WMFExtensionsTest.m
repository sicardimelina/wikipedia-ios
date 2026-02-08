#import <XCTest/XCTest.h>
#import "NSUserActivity+WMFExtensions.h"

@interface NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test : XCTestCase
@end

@implementation NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test

- (void)testURLWithoutWikipediaSchemeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"http://www.foo.com"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testInvalidArticleURLReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testArticleURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/wiki/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString, @"https://en.wikipedia.org/wiki/Foo");
}

- (void)testExploreURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://explore"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeExplore);
}

- (void)testSavedURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://saved"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeSavedPages);
}

- (void)testSearchURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/w/index.php?search=dog"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString,
                          @"https://en.wikipedia.org/w/index.php?search=dog&title=Special:Search&fulltext=1");
}

- (void)testCoordinatesURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://coordinates?lat=52.3547498&lon=4.8339215&name=Amsterdam"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeCoordinates);
    XCTAssertEqualObjects(activity.userInfo,
      (@{
          @"WMFLatitude": @52.3547498,
          @"WMFLongitude": @4.8339215,
          @"WMFPage": @"Coordinates",
          @"WMFPlaceName": @"Amsterdam"
      }));
}

- (void)testCoordinatesURLWithoutLatitudeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://coordinates?lon=4.8339215&name=Amsterdam"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testCoordinatesURLWithoutLongitudeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://coordinates?lat=52.3547498&name=Amsterdam"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testCoordinatesURLWithoutLatitudeAndLongitudeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://coordinates?name=Amsterdam"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testCoordinatesURLWithoutPlaceName {
    NSURL *url = [NSURL URLWithString:@"wikipedia://coordinates?lat=52.3547498&lon=4.8339215"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeCoordinates);
    XCTAssertEqualObjects(activity.userInfo,
      (@{
          @"WMFLatitude": @52.3547498,
          @"WMFLongitude": @4.8339215,
          @"WMFPage": @"Coordinates"
      }));
}

@end
