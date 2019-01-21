
#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import <CoreLocation/CoreLocation.h>


@interface StorageResource : NSObject {
    FMDatabase *db;
    NSString *tableName;
}
+ (id)sharedManager;


- (void)addValuesToDB:(NSArray*)array;

- (NSMutableArray*)getCamerasForRegions:(CLLocationCoordinate2D)NE sw:(CLLocationCoordinate2D)SW;

@end
