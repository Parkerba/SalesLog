//
//  OrderItemView.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import UIKit

class OrderItemView: UIView {
    let size: String
    let quantity: Int16
    let item: Item
    
    lazy var orderItemNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var orderSizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var orderQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "minus.square.fill")?.withRenderingMode(.alwaysTemplate)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            orderItemNameLabel,
            orderSizeLabel,
            orderQuantityLabel,
            removeButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.spacing = GC.standardPadding
        stack.alignment = .center
        return stack
    }()
    
    required init?(coder: NSCoder) { return nil }
    
    init(item: Item, size: String, quantity: Int16) {
        self.size = size
        self.item = item
        self.quantity = quantity
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        addSubview(hStack)
        orderItemNameLabel.text = item.name
        orderSizeLabel.text = "Size: " + size
        orderQuantityLabel.text = "Quantity: \(quantity)"
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: GC.standardPadding),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -GC.standardPadding),
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: GC.standardSmallPadding),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -GC.standardSmallPadding)
        ])
    }
    
    @objc
    func removeTapped() {
        removeFromSuperview()
    }
}
