//
//  SwitchLabelView.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import UIKit

class SwitchLabelView: UIView {
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = false
        toggle.onTintColor = .systemGreen
        return toggle
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        addSubview(label)
        addSubview(toggle)
        label.text = title
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: GC.standardPadding),
            label.topAnchor.constraint(equalTo: topAnchor, constant: GC.standardSmallPadding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -GC.standardSmallPadding),
            label.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -GC.standardPadding),
            toggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -GC.standardPadding),
            toggle.topAnchor.constraint(equalTo: topAnchor, constant: GC.standardSmallPadding),
            toggle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -GC.standardSmallPadding),
        ])

    }

    required init?(coder: NSCoder) { return nil }
}
