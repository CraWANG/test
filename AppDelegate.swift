//
//  AppDelegate.swift
//  Aquarium
//
//  Created by 冬薰苑 on 15/10/13.
//  Copyright © 2015年 冬薰苑. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let tokenKey = "deviceToken"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let statTracker = BaiduMobStat.defaultStat()
        statTracker.enableExceptionLog = true
        statTracker.enableDebugOn = false
        statTracker.startWithAppId("8d7a3d1856")
        
        UserManager.shareInstance().initApi()
        UMFeedback.setAppkey(UM.UMAppKey)
        UMFeedback.setLogEnabled(false)
        MobClick.startWithAppkey(UM.UMAppKey, reportPolicy: BATCH, channelId: nil)
        MobClick.setLogEnabled(false)
        MobClick.setCrashReportEnabled(true)
        // 本地提醒
        if Alarm.isAuthorized {
            Alarm.applicationDidFinishiLaunching(launchOptions)
        } else {
            Alarm.getAuthorize()
            Alarm.applicationDidFinishiLaunching(launchOptions)
        }
        
        if (launchOptions != nil ) {
            self.makePush(launchOptions!)
        } else {
            self.makePush(nil)
        }
        
        return true
    }
    
    //信鸽推送
    func makePush(launchOptions:[NSObject: AnyObject]?) {
        
        XGPush.startApp(2200156525, appKey: "I7QP561NNP2C")
        
        let successCallback : () ->Void =  {
            
            //未注册
            if !XGPush.isUnRegisterStatus() {
                
                    let notificationType = UIUserNotificationType([.Alert,.Badge,.Sound])
                    let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
                    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                    UIApplication.sharedApplication().registerForRemoteNotifications()
            }
        }
        
        XGPush.initForReregister(successCallback)
        //设置角标为0
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        XGPush.handleLaunching(launchOptions)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        completionHandler()
    }
    
    //注册设备
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let str = XGPush.registerDevice(deviceToken)
        NSUserDefaults.standardUserDefaults().setObject(str, forKey: AppDelegate.tokenKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    //注册设备失败
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
            XGPush.handleReceiveNotification(userInfo)
    }
    
    //MARK: - 本地通知相关
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        Alarm.applicationReciveLocalNotification(notification)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        Alarm.applicationDidBecomeActive()
    }
    
}

