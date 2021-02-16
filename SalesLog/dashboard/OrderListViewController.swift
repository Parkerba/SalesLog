//
//  OrderListViewController.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import UIKit

class OrderListViewController: UIViewController {
    
    enum Constants {
        static let cellReuseID: String = "OrderCell"
    }
    
    var orders: [Order] = []
    
    lazy var orderTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OrderCell.self, forCellReuseIdentifier: Constants.cellReuseID)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(orderTable)
        NSLayoutConstraint.activate([
            orderTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            orderTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            orderTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        asyncReload()
        setUpNavBar()
        
    }
    
    func asyncReload() {
        ModelManager.shared.fetchAllOrders { (orders) in
            guard let orders = orders else { return }
            DispatchQueue.main.async {
                self.orders = orders
                self.orderTable.reloadData()
            }
        }
    }
    
    private func setUpNavBar() {
        navigationItem.title = "Orders"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addOrderButtonTapped))
        navigationController?.navigationBar.sizeToFit()
    }
    
    @objc
    func addOrderButtonTapped() {
        navigationController?.pushViewController(AddOrderViewController(order: nil), animated: true)
    }
    
}

extension OrderListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: OrderCell? = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseID) as? OrderCell
        if cell == nil {
            cell = OrderCell(reuseIdentifier: Constants.cellReuseID)
        }
        cell?.setUp(orders[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            let order = self.orders[indexPath.row]
            self.orders.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            ModelManager.shared.removeOrder(order)
            tableView.endUpdates()
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(AddOrderViewController(order: orders[indexPath.row]), animated: true)
    }
}
