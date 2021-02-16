//
//  ViewController.swift
//  SalesLog
//
//  Created by parker amundsen on 10/20/20.
//

import UIKit

class DashBoardTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let orderListVC = OrderListViewController()
        orderListVC.tabBarItem = .init(title: "Orders", image: UIImage(systemName: "book.fill"), tag: 0)
        let orderItemListVC = OrderItemsListViewController()
        orderItemListVC.tabBarItem = .init(title: "Order Items", image: UIImage(systemName: "cube.box.fill"), tag: 1)


        let vcs = [
            orderListVC,
            orderItemListVC
        ]
        viewControllers = vcs.map { UINavigationController(rootViewController: $0) }
    }
}

