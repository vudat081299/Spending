//
//  TabBarController.swift
//  Social Messaging
//
//  Created by Vũ Quý Đạt  on 10/04/2021.
//

import UIKit

struct ViewControllerManager {
    let title: String
    let iconNormal: String
    let selectedIcon: String
    let viewController: UINavigationController
    
    
    
    // MARK: - Data.
    static var viewControllers: [ViewControllerManager] = {
        let array = [
//            ViewControllerManager(title: "Spending", iconNormal: "message", selectedIcon: "message.fill", viewController: UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")))
        ]
        var dataList: [ViewControllerManager] = []
//        array.forEach {
//            $0.viewController.topViewController?.title = $0.title
//            $0.viewController.tabBarItem.image = UIImage(systemName: $0.iconNormal)
//            $0.viewController.tabBarItem.selectedImage = UIImage(systemName: $0.selectedIcon)
//            $0.viewController.navigationBar.prefersLargeTitles = true
//            $0.viewController.navigationBar.sizeToFit()
//            $0.viewController.navigationItem.largeTitleDisplayMode = .always
//            dataList.append($0)
//        }
        return dataList
    }()
}

class TabBarController: UITabBarController {
    
    // MARK: - Life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ViewControllerManager.viewControllers.forEach {
            viewControllers?.append($0.viewController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
