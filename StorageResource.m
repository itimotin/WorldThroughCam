#import "StorageResource.h"

@implementation StorageResource

static StorageResource  *sharedMyManager = nil;

+ (id)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}

- (NSMutableArray*)getCamerasForRegions:(CLLocationCoordinate2D)NE sw:(CLLocationCoordinate2D)SW {
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *rs;
    if (SW.longitude > NE.longitude) {
        rs = [db executeQuery:@"select * from Cameras where latitude<? AND latitude>? AND longitude>? AND longitude<?; ",@(NE.latitude),@(SW.latitude),@(SW.longitude),@(NE.longitude+360)];
    }else{
        rs = [db executeQuery:@"select * from Cameras where latitude<? AND latitude>? AND longitude>? AND longitude<?; ",@(NE.latitude),@(SW.latitude),@(SW.longitude),@(NE.longitude)];
    }
    while ([rs next]){
        [array addObject:[rs resultDict]];
    }
    return array;
}

- (void)addValuesToDB:(NSArray*)array{
    for (NSDictionary *dict in array) {
        NSString *nameCamera = [dict objectForKey:@"name"];
        NSString *city = [dict objectForKey:@"city"];
        NSString *country = [dict objectForKey:@"country"];
        NSNumber *lat = [dict objectForKey:@"lat"];
        NSNumber *longitude = [dict objectForKey:@"long"];
        NSNumber *cId = [dict objectForKey:@"id"];
        [db executeUpdate:@" insert into Cameras VALUES(?,?,?,?,?,?);",cId,nameCamera,city,country,lat,longitude];
    }
}


- (void)checkAndInitDatabase{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory
					  stringByAppendingPathComponent:@".icon.gif"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//		[[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"icon" ofType:@"sqlite"] toPath:path error:nil];
        [[NSFileManager defaultManager] createFileAtPath:[documentsDirectory stringByAppendingPathComponent:@".icon.gif"] contents:nil attributes:nil];
	}
	NSLog(@"path is %@",path);
	db = [[FMDatabase alloc] initWithPath:path];
	[db setLogsErrors:TRUE];
	if (![db open]) {
        
	}
    else
    {
        NSLog(@"oooooooohooo. DB Open....\n db path = %@",path);
        if (![db tableExists:@"Cameras"])
        {
            [db executeUpdate:@" CREATE TABLE  'Cameras' ('id' INTEGER PRIMARY KEY NOT NULL,'name' TEXT,'city' TEXT,'country' TEXT,'latitude' NUMBER,'longitude' NUMBER);",nil];
        }
    }
}


-(id) init {
    self = [super init];
    if (self != nil) {
		[self checkAndInitDatabase];
    }
    return self;
}


@end
