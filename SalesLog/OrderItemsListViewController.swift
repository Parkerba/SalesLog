//
//  OrderItemsListViewController.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import UIKit

class OrderItemsListViewController: UIViewController {
    
    enum Constants {
        static let cellReuseID: String = "OrderItemCellID"
    }
    
    var items: [Item] = []
    
    lazy var itemListTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(OrderItemCell.self, forCellReuseIdentifier: Constants.cellReuseID)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavBar()
        view.addSubview(itemListTable)
        
        NSLayoutConstraint.activate([
            itemListTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemListTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemListTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            itemListTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        asyncReload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        asyncReload()
    }
    
    func asyncReload() {
        ModelManager.shared.fetchAllItems { (items) in
            guard let items = items else { return }
            DispatchQueue.main.async {
                self.items = items
                self.itemListTable.reloadData()
            }
        }
    }
    
    func setUpNavBar() {
        navigationItem.title = "Order Items"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addOrderItemTapped))
    }
    
    @objc
    func addOrderItemTapped() {
        navigationController?.pushViewController(AddOrderItemViewController(), animated: true)
    }
}

extension OrderItemsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: OrderItemCell? = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseID) as? OrderItemCell
        if cell == nil {
            cell = OrderItemCell(reuseIdentifier: Constants.cellReuseID)
        }
        cell?.setUp(items[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
            tableView.beginUpdates()
            let item = self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            ModelManager.shared.removeItem(item)
            tableView.endUpdates()
        
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}
