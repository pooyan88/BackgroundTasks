//
//  AppDelegate.swift
//  BackgroundTasksExample
//
//  Created by Pooyan J on 6/12/1403 AP.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    let taskID = "test.BackgroundTasksExample.backgroundTask"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //Register Task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskID, using: nil) { task in
            guard let task = task as? BGAppRefreshTask else { return }
            self.registerTask(task: task)
        }
        let count = UserDefaults.standard.integer(forKey: "background_task_count")
        print("task ran \(count) times")
        scheduled()
        //SubmitTask
        //handle tasks when its run
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


}

//e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"test.BackgroundTasksExample.backgroundTask"]


// MARK: Background Tasks Functions
extension AppDelegate {

    func registerTask(task: BGAppRefreshTask) {
        let count = UserDefaults.standard.integer(forKey: "background_task_count")
        UserDefaults.standard.setValue(count+1, forKey: "background_task_count")
    }

    func scheduled() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskID)
        BGTaskScheduler.shared.getPendingTaskRequests { tasks in
            print("\(tasks.count) is pending ....")
            
            guard tasks.isEmpty else {
                print("there is uncompleted tasks")
                return
            }

            do {
                let newTask = BGAppRefreshTaskRequest(identifier: self.taskID)
                newTask.earliestBeginDate = Date().addingTimeInterval(86000 * 3)
                try BGTaskScheduler.shared.submit(newTask)
                print("scheduled")
            } catch {
                print("error on submitting => \(error)")
            }
        }
    }
}
