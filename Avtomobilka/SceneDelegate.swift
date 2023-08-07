//
//  SceneDelegate.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 02.08.2023.
//

import SwiftUI

class GlobalModel: ObservableObject {
    
    @Published var safeArea: (top: CGFloat, bottom: CGFloat)
    
    init() {
        self.safeArea = (0, 0)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        


        let globalModel = GlobalModel()
        let contentView = MainView(globalModel: globalModel)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            
            self.window = window
            window.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }

}

