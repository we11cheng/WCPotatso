//
//  SelectorViewController.swift
//  Eureka
//
//  Created by Martin Barreto on 2/24/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation

open class _SelectorViewController<T: Equatable, Row: SelectableRowType>: FormViewController, TypedRowControllerType where Row: BaseRow, Row: TypedRowType, Row.Value == T, Row.Cell.Value == T {
    
    /// The row that pushed or presented this controller
    open var row: RowOf<Row.Value>!
    
    /// A closure to be called when the controller disappears.
    open var completionCallback : ((UIViewController) -> ())?
    
    open var selectableRowCellUpdate: ((_ cell: Row.Cell, _ row: Row) -> ())?
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        guard let options = row.dataProvider?.arrayData else { return }
        
        form +++ SelectableSection<Row, Row.Value>(row.title ?? "", selectionType: .singleSelection(enableDeselection: true)) { [weak self] section in
            if let sec = section as? SelectableSection<Row, Row.Value> {
                sec.onSelectSelectableRow = { _, row in
                    self?.row.value = row.value
                    self?.completionCallback?(self!)
                }
            }
        }
        for option in options {
            form.first! <<< Row.init(String(describing: option)){ lrow in
                    lrow.title = row.displayValueFor?(option)
                    lrow.selectableValue = option
                    lrow.value = row.value == option ? option : nil
                }.cellUpdate { [weak self] cell, row in
                    self?.selectableRowCellUpdate?(cell, row)
                }
        }
    }
}

/// Selector Controller (used to select one option among a list)
open class SelectorViewController<T:Equatable> : _SelectorViewController<T, ListCheckRow<T>>  {
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience public init(_ callback: @escaping (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
