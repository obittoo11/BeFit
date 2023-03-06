//
//  BeFitApp.swift
//  BeFit
//
//  Created by Sahib Anand on 05/01/23.
//

import SwiftUI
import Firebase
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var dataManager = DataManager()


  var body: some Scene {
    WindowGroup {
      NavigationView {
          ContentView(email: .constant(""), password: .constant(""))
            .environmentObject(dataManager)
          
      }
    }
  }
}
