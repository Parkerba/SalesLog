//
//  OrderItemCell.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import UIKit

class OrderItemCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func setUp(_ item: Item) {
        textLabel?.text = item.name
        detailTextLabel?.text = "$\(item.price)"
    }
}
