//
//  DateInlineFieldRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/24/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation


open class DateInlineCell : Cell<Date>, CellType {
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        accessoryType = .none
        editingAccessoryType =  .none
    }
    
    open override func update() {
        super.update()
        selectionStyle = row.isDisabled ? .none : .default
    }
    
    open override func didSelect() {
        super.didSelect()
        row.deselect()
    }
}


open class _DateInlineFieldRow: Row<Date, DateInlineCell>, DatePickerRowProtocol, NoValueDisplayTextConformance {
    
    /// The minimum value for this row's UIDatePicker
    open var minimumDate : Date?
    
    /// The maximum value for this row's UIDatePicker
    open var maximumDate : Date?
    
    /// The interval between options for this row's UIDatePicker
    open var minuteInterval : Int?
    
    /// The formatter for the date picked by the user
    open var dateFormatter: DateFormatter?
    
    open var noValueDisplayText: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        dateFormatter = DateFormatter()
        dateFormatter?.locale = .current
        displayValueFor = { [unowned self] value in
            guard let val = value, let formatter = self.dateFormatter else { return nil }
            return formatter.string(from: val)
        }
    }
}
