

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        return true
    }



    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith userAcceptedCloudKitSharedWith: CKShareMetadata) {
        print("Accepted CloudKit sharing from: \(userAcceptedCloudKitSharedWith.ownerIdentity.nameComponents?.givenName)")
    }

}

