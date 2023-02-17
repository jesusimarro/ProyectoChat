//
//  AppDelegate.swift
//  ProyectoChat
//
//  Created by estech on 3/2/23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    //Establecer conexión con ViewController
    var viewController: ViewController?

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerForPushNotifications()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permiso concedido: \(granted)")
            
            guard granted else { return }
            
            self.getNotificationsSettings()
        }
        
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Accept", options: [.foreground])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Decline", options: [.foreground])
        
        let meetingInviteCategory = UNNotificationCategory(identifier: "MEETING_INVITATION", actions: [acceptAction, declineAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
    }
    
    func getNotificationsSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map{ data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()

        print("device token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let aps = userInfo["aps"] as? [String:AnyObject] else {
            completionHandler(.failed)
            return
        }
        print(aps)
        
        if let pushBadgeNumber: Int = aps["badge"] as? Int {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BadgeChanged"), object: nil)
            UIApplication.shared.applicationIconBadgeNumber = pushBadgeNumber
        }
        
        let alert = aps["alert"] as! [String:AnyObject]
        
        //Añadir los mensajes recibidos al array
        let alertBody = aps as! String
        viewController?.mensajes.append(["rec", alertBody])
        viewController?.tableView.reloadData()
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let aps = userInfo["aps"] as? [String:AnyObject] {
            switch response.actionIdentifier {
            case "ACCEPT_ACTION":
                //El usuario ha aceptado
                break
            case "DECLINE_ACTION":
                //El usuario ha rechazado
                break
            default:
                break
            }
            completionHandler()
        }

   }

}
