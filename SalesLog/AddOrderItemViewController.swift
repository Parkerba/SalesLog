//
//  AddOrderItemViewController.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import UIKit

class AddOrderItemViewController: UIViewController {
    
    lazy var inputStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.layoutMargins = UIEdgeInsets(top: 0, left: GC.standardPadding, bottom: 0, right: GC.standardPadding)
        stack.spacing = GC.standardPadding
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Price of item"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name of item"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        view.backgroundColor = .systemBackground
        view.addSubview(inputStack)
        inputStack.addArrangedSubview(nameTextField)
        inputStack.addArrangedSubview(priceTextField)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
        NSLayoutConstraint.activate([
            inputStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide .bottomAnchor),
            priceTextField.widthAnchor.constraint(equalTo: inputStack.widthAnchor, constant: -GC.standardPadding*2),
            nameTextField.widthAnchor.constraint(equalTo: inputStack.widthAnchor, constant: -GC.standardPadding*2)
        ])
    }
    
    func setUpNavBar() {
        navigationItem.title = "Add Order Item"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
    }
    
    @objc
    func donePressed() {
        guard nameTextField.hasText, let name = nameTextField.text else {
            let alertController = UIAlertController(title: "Provide a name", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        guard priceTextField.hasText, let float = Float(priceTextField.text!) else {
            let alertController = UIAlertController(title: "Price invalid", message: "Proceed with default $0.00?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .destructive) {_ in
                ModelManager.shared.createAndAddItem(name: name, price: 0)
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true, completion: nil)
            return
        }
        ModelManager.shared.createAndAddItem(name: name, price: float)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func backgroundTapped() {
        view.endEditing(true)
    }

}

