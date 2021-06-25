//
//  main.m
//  FlixFind
//
//  Created by Bruke Wossenseged on 6/23/21.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
git     return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
