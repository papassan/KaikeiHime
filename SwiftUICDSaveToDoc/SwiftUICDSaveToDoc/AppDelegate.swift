//
//  AppDelegate.swift
//  SwiftUICDSaveToDoc
//
//  Created by 福田 敏一 on 2019/12/07.
//  Copyright © 2019 株式会社パパスサン. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { print("17-1・AD・通過")
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration { print("24-2・AD・通過")
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { print("30・AD・通過")
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack
    // ⭐️ 2018/06/06
    // アプリ内に保存してある「mamassan.xcdatamodeld」を読込む為の初期化作業です
    lazy var persistentContainer: NSPersistentContainer = { print("39-2-persistentContainer・AD・通過")
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SwiftUICDSaveToDoc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() { print("68-saveContext・AD・通過")
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
// ⭐️ 2019/5/3・ここから・保存に必要なコードです
    lazy var managedObjectContext: NSManagedObjectContext = { print("83-4-managedObjectContext・AD・通過")
                    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
                    let coordinator = self.persistentStoreCoordinator
                    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                    managedObjectContext.persistentStoreCoordinator = coordinator
print("88-14・AppDelegate・通過・managedObjectContext -> \(managedObjectContext)\n")
                return managedObjectContext
            }()
// ⭐️ 2019/5/3・iOS 10以前のクラス
        lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = { print("92-5-persistentStoreCoordinator・AD・通過")
            // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
            // Create the coordinator and store
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let url = applicationDocumentsDirectory.appendingPathComponent("SwiftUICDSave.sqlite")
print("97-11・AppDelegate・通過・url -> \(url!)\n")//urlはディレクトリーなし
            // パスを作成
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/SQlite3"
            do {
                // ディレクトリが存在するかどうかの判定
                if !FileManager.default.fileExists(atPath: path) {
                    // ディレクトリが無い場合ディレクトリを作成する
                    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false , attributes: nil)
                }
            } catch {
                // エラー処理
            }
            // 保存先のパスを作成
            let savePath = path + "/SwiftUICDSave.sqlite"
print("111-12・AppDelegate・通過・savePath -> \(savePath)\n")
            // 「パス」を「ファイルURL」に変換
            let urlURL = URL(fileURLWithPath: savePath)
print("114-13・AppDelegate・通過・urlURL -> \(urlURL)\n")
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: urlURL, options: nil)
            } catch {
                // エラー処理
            }
            return coordinator
        }()

// ⭐️ 2019/5/3・iOS 10以前のクラス
    lazy var managedObjectModel: NSManagedObjectModel = { print("124-6-managedObjectModel・AD・通過")
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
// 2019/05/03・.mondとは ? momdファイルは実際にはすべてのバージョンモデルを含むコンテナ
        let modelURL = Bundle.main.url(forResource: "SwiftUICDSaveToDoc", withExtension: "momd")!
print("128-7・AppDelegate・通過・modelURL -> \(modelURL)\n")
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
// ⭐️ ファイルを保存するために使用するディレクトリ
    lazy var applicationDocumentsDirectory: NSURL = { print("132-8-applicationDocumentsDirectory・AD・通過")
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.test.ConfigurationTest" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
print("135-9・AppDelegate・通過・urls by AppDelegate -> \(urls)\n")
print("136-10・AppDelegate・通過・urls.count by AppDelegate -> \(urls.count)\n")
        return urls[urls.count-1] as NSURL
    }()

}

