//
//  AddOrderViewController.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import UIKit

class AddOrderViewController: UIViewController {
    
    enum Constants {
        static let sizes: [String] = [
            "NA",
            "XS",
            "S",
            "M",
            "L",
            "XL",
            "XXL",
            "XXXL"
        ]
    }
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name of customer"
        if let order = order {
            textField.text = order.name
        }
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()
    
    lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameTextField,
            shippedToggle,
            paidToggle
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = GC.standardPadding
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var shippedToggle: SwitchLabelView = {
        let switchLabel = SwitchLabelView(title: "Shipped:")
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.toggle.isOn = order?.shipped ?? false
        return switchLabel
    }()
    
    lazy var paidToggle: SwitchLabelView = {
        let switchLabel = SwitchLabelView(title: "Paid:")
        switchLabel.toggle.isOn = order?.paid ?? false
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        return switchLabel
    }()
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "plus.square.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        return button
    }()
    
    private var items: [Item] = []
    private let order: Order?
    
    init(order: Order?) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { return nil }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
        ModelManager.shared.fetchAllItems { (items) in
            self.items = items ?? []
        }
        setUpNavBar()
        setUpSubviews()
        if let order = order {
            for orderItem in order.orderItems! where orderItem is OrderItem {
                let orderItem = orderItem as! OrderItem
                addOrderItemView(from: orderItem.item!, with: orderItem.size!, and: orderItem.quantity)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavBar()
    }
    
    func setUpSubviews() {
        view.addSubview(inputStack)
        view.addSubview(pickerView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            inputStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputStack.bottomAnchor.constraint(lessThanOrEqualTo: pickerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: inputStack.widthAnchor, constant: -GC.standardPadding*2),
            shippedToggle.widthAnchor.constraint(equalTo: inputStack.widthAnchor),
            paidToggle.widthAnchor.constraint(equalTo: inputStack.widthAnchor),
            pickerView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -GC.standardPadding),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: GC.standardPadding),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -GC.standardPadding),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -GC.standardPadding),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        navigationItem.title = "New Order"
        navigationController?.navigationBar.sizeToFit()
    }
    
    @objc
    func donePressed() {
        guard nameTextField.hasText, (inputStack.arrangedSubviews.contains { $0 is OrderItemView }) else {
            let alertVC = UIAlertController(title: "Incomplete Order", message: "Ensure the order has a name and added order items.", preferredStyle: .alert)
            alertVC.addAction(.init(title: "OK", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
            return
        }
        var newItems = [(item: Item, size: String, quantity: Int16)]()
        
        for view in inputStack.arrangedSubviews where view is OrderItemView {
            let orderItemView = view as! OrderItemView
            newItems.append((item: orderItemView.item,
                             size: orderItemView.size,
                             quantity: orderItemView.quantity))
        }
        if let order = order {
            ModelManager.shared.updateOrder(order, name: nameTextField.text!, paid: paidToggle.toggle.isOn, shipped: shippedToggle.toggle.isOn, orderItemData: newItems)
        } else {
            ModelManager.shared.addOrder(name: nameTextField.text!, paid: paidToggle.toggle.isOn, shipped: shippedToggle.toggle.isOn, orderItemData: newItems)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func addPressed() {
        let quantity = Int16(pickerView.selectedRow(inComponent: 2))
        guard quantity > 0 else {
            let alertVC = UIAlertController(title: "Quantity is 0", message: "Quantity must be greater than 0 to add to the order.", preferredStyle: .alert)
            alertVC.addAction(.init(title: "OK", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
            return
        }
        let item = items[pickerView.selectedRow(inComponent: 0)]
        let size = Constants.sizes[pickerView.selectedRow(inComponent: 1)]
        addOrderItemView(from: item, with: size, and: quantity)
    }
    
    func addOrderItemView(from item: Item, with size: String, and quantity: Int16) {
        let orderItemView = OrderItemView(item: item, size: size, quantity: quantity)
        orderItemView.translatesAutoresizingMaskIntoConstraints = false
        inputStack.addArrangedSubview(orderItemView)
        orderItemView.widthAnchor.constraint(equalTo: inputStack.widthAnchor).isActive = true
    }
    
    @objc
    func backgroundTapped() {
        view.endEditing(true)
    }
    
}

extension AddOrderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return items.count
        case 1:
            return Constants.sizes.count
        default:
            return 50
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return items[row].name
        case 1:
            return Constants.sizes[row]
        default:
            return "\(row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let availableWidth = pickerView.frame.size.width
        switch component {
        case 0:
            return availableWidth * 3/5
        case 1:
            return availableWidth * 1/5
        default:
            return availableWidth * 1/7
        }
    }
}
