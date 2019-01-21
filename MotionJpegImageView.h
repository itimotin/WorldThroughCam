#import <UIKit/UIKit.h>

@interface MotionJpegImageView : UIImageView {
    
@private
    NSURL *_url;
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
    NSString *_username;
    NSString *_password;
    BOOL _allowSelfSignedCertificates;
    BOOL _allowClearTextCredentials;
    
}

@property (nonatomic, readwrite, copy) NSURL *url;
@property (readonly) BOOL isPlaying;
@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *password;
@property (nonatomic, readwrite, assign) BOOL allowSelfSignedCertificates;
@property (nonatomic, readwrite, assign) BOOL allowClearTextCredentials;

- (void)play;
- (void)pause;
- (void)clear;
- (void)stop;

@end
