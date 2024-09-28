//
//  mydreamsApp.swift
//  mydreams
//
//  Created by Bahadır Sengun on 28.08.2024.
//

import SwiftUI
import FirebaseCore
import OneSignalFramework
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       // Remove this method to stop OneSignal Debugging
       OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        
       // OneSignal initialization
       OneSignal.initialize("7cecb358-b37f-4270-b09d-07a5388394c0", withLaunchOptions: launchOptions)

       // requestPermission will show the native iOS notification permission prompt.
       // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
       OneSignal.Notifications.requestPermission({ accepted in
         print("User accepted notifications: \(accepted)")
       }, fallbackToSettings: true)

       // Login your customer with externalId
       // OneSignal.login("EXTERNAL_ID")
        
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Apply the dark mode setting at app launch
        applyDarkModeSetting()
            
       return true
    }
    
    func applyDarkModeSetting() {
        // Get the stored dark mode setting and apply it
        let storedDarkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = storedDarkModeEnabled ? .dark : .light
            }
        }
    }
}

@main
struct mydreamsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AuthVC()
                .onAppear {
                    // Apply dark mode setting when the app appears
                    delegate.applyDarkModeSetting()
            }
        }
    }
}
