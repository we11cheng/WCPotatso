//
//  DateFieldRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/24/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation

public protocol DatePickerRowProtocol: class {
    var minimumDate : Date? { get set }
    var maximumDate : Date? { get set }
    var minuteInterval : Int? { get set }
}


open class DateCell : Cell<Date>, CellType {
    
    lazy open var datePicker = UIDatePicker()
    
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
        datePicker.datePickerMode = datePickerMode()
        datePicker.addTarget(self, action: #selector(DateCell.datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    deinit {
        datePicker.removeTarget(self, action: nil, for: .allEvents)
    }
    
    open override func update() {
        super.update()
        selectionStyle = row.isDisabled ? .none : .default
        datePicker.setDate(row.value ?? Date(), animated: row is CountDownPickerRow)
        datePicker.minimumDate = (row as? DatePickerRowProtocol)?.minimumDate
        datePicker.maximumDate = (row as? DatePickerRowProtocol)?.maximumDate
        if let minuteIntervalValue = (row as? DatePickerRowProtocol)?.minuteInterval{
            datePicker.minuteInterval = minuteIntervalValue
        }
    }
    
    open override func didSelect() {
        super.didSelect()
        row.deselect()
    }
    
    override open var inputView : UIView? {
        if let v = row.value{
            datePicker.setDate(v, animated:row is CountDownRow)
        }
        return datePicker
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        row.value = sender.date
        detailTextLabel?.text = row.displayValueFor?(row.value)
    }
    
    fileprivate func datePickerMode() -> UIDatePickerMode{
        switch row {
        case is DateRow:
            return .date
        case is TimeRow:
            return .time
        case is DateTimeRow:
            return .dateAndTime
        case is CountDownRow:
            return .countDownTimer
        default:
            return .date
        }
    }
    
    open override func cellCanBecomeFirstResponder() -> Bool {
        return canBecomeFirstResponder
    }
    
    open override var canBecomeFirstResponder : Bool {
        return !row.isDisabled;
    }
}


open class _DateFieldRow: Row<Date, DateCell>, DatePickerRowProtocol, NoValueDisplayTextConformance {
    
    /// The minimum value for this row's UIDatePicker
    open var minimumDate : Date?
    
    /// The maximum value for this row's UIDatePicker
    open var maximumDate : Date?
    
    /// The interval between options for this row's UIDatePicker
    open var minuteInterval : Int?
    
    /// The formatter for the date picked by the user
    open var dateFormatter: DateFormatter?
    
    open var noValueDisplayText: String? = nil
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { [unowned self] value in
            guard let val = value, let formatter = self.dateFormatter else { return nil }
            return formatter.string(from: val)
        }
    }
}
