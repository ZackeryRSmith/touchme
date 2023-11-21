#if defined(__APPLE__) || defined(__MACH__)
#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#endif

// poor not all apple devices have TouchID
int isAvailable() {
#if defined(__APPLE__) || defined(__MACH__)
    // dynamic loading to check for frameworks
    Class laContextClass = NSClassFromString(@"LAContext");

    if (!laContextClass)
        return 0;

    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;

    BOOL canEvaluatePolicy = [context
        canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    error:&error];
    if (!canEvaluatePolicy) {
        // error checking TouchID availability
        return 0;
    }

    if (canEvaluatePolicy) {
        // TouchID is supported on the device
        return 1;
    }
#endif
    return 0;
}

int touchId(char *reason) {
#if defined(__APPLE__) || defined(__MACH__)
    // dynamic loading to check for frameworks
    Class laContextClass = NSClassFromString(@"LAContext");

    if (!laContextClass)
        return 0;

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

        // free memory
        myContext = nil;

        if (success) {
            // user authenticated successfully
            return 1;
        }
    }
#endif
    return 0;
}
