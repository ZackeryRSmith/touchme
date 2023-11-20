#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

int touchId(char *reason) {
    @autoreleasepool {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *myLocalizedReasonString =
            [NSString stringWithCString:reason encoding:NSASCIIStringEncoding];
        __block BOOL success = NO;
        __block BOOL done = NO;

        if ([myContext canEvaluatePolicy:
                           LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                   error:&authError]) {
            dispatch_async(dispatch_get_main_queue(), ^{
              [myContext evaluatePolicy:
                             LAPolicyDeviceOwnerAuthenticationWithBiometrics
                        localizedReason:myLocalizedReasonString
                                  reply:^(BOOL authSuccess, NSError *error) {
                                    success = authSuccess;
                                    done = YES;
                                  }];
            });

            // run the main run loop until authentication is done
            while (!done) {
                [[NSRunLoop mainRunLoop]
                    runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            }
        }

        if (success) {
            // user authenticated successfully
            return 1;
        } else {
            // user did not authenticate successfully
            return 0;
        }
    }

    // default false
    return 0;
}
