//
//  AppDelegate.swift
//  0_0 - Empty Template (Swift)
//
//  URL: https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDatePicker_Class/index.html#//apple_ref/occ/cl/UIDatePicker
//  URL: http://sourcefreeze.com/ios-datepicker-tutorial-uidatepicker-using-swift/
//  URL: http://www.brianjcoleman.com/tutorial-nsdate-in-swift/
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds);
        
        self.window?.backgroundColor = UIColor.whiteColor();
        
        let viewController:ViewController = ViewController();
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.window?.rootViewController = viewController;
        
        self.window?.makeKeyAndVisible();
        
        print("AppDelegate.application():          Application launch complete");
        
        return true;
    }

    func applicationWillResignActive(application: UIApplication) {
        return;
    }

    func applicationDidEnterBackground(application: UIApplication) {
        return;
    }

    func applicationWillEnterForeground(application: UIApplication) {
        return;
    }

    func applicationDidBecomeActive(application: UIApplication) {
        return;
    }

    func applicationWillTerminate(application: UIApplication) {
        return;
    }
}

