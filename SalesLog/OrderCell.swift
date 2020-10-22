//
//  OrderCell.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import UIKit

class OrderCell: UITableViewCell {
    var order: Order?
    
    lazy var orderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    lazy var shippingStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    lazy var paymentStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    lazy var orderItemsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = GC.standardPadding
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(orderNameLabel)
        contentView.addSubview(orderItemsStackView)
        contentView.addSubview(paymentStatusLabel)
        contentView.addSubview(shippingStatusLabel)
        NSLayoutConstraint.activate([
            orderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: GC.standardPadding),
            orderNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: GC.standardPadding),
            orderNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: orderItemsStackView.leadingAnchor, constant: -GC.standardPadding),
            orderNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -GC.standardPadding),
            paymentStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: GC.standardPadding),
            paymentStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: orderItemsStackView.leadingAnchor, constant: -GC.standardPadding),
            paymentStatusLabel.topAnchor.constraint(equalTo: orderNameLabel.bottomAnchor, constant: GC.standardSmallPadding),
            shippingStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: GC.standardPadding),
            shippingStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: orderItemsStackView.leadingAnchor, constant: -GC.standardPadding),
            shippingStatusLabel.topAnchor.constraint(equalTo: paymentStatusLabel.bottomAnchor, constant: GC.standardSmallPadding),
            shippingStatusLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -GC.standardPadding),
            orderItemsStackView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            orderItemsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -GC.standardPadding),
            orderItemsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: GC.standardPadding),
            orderItemsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -GC.standardPadding)
        ])
        
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func setUp(_ order: Order) {
        self.order = order
        orderNameLabel.text = order.name
        for label in orderItemsStackView.arrangedSubviews {
            label.removeFromSuperview()
        }
        
        for element in order.orderItems! {
            guard let orderItem = element as? OrderItem else { continue }
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "Item: \(orderItem.item?.name ?? "") \nQuantity: \(orderItem.quantity)"
            if let size = orderItem.size, size != "NA" {
                label.text = label.text! + "\nSize: " + size
            }
            label.layoutMargins = UIEdgeInsets(top: GC.standardSmallPadding,
                                               left: 0,
                                               bottom: GC.standardSmallPadding,
                                               right: 0)
            label.textAlignment = .center
            label.backgroundColor = .secondarySystemBackground
            label.layer.cornerRadius = 10
            label.clipsToBounds = true
            orderItemsStackView.addArrangedSubview(label)
        }
        
        shippingStatusLabel.text = order.shipped ? "Shipped: ✅":"Shipped: ‼️"
        paymentStatusLabel.text = order.paid ? "Paid: ✅":"Paid: ‼️"        
    }
    
}
