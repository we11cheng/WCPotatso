//
//  MultipleSelectorViewController.swift
//  Eureka
//
//  Created by Martin Barreto on 2/24/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation


/// Selector Controller that enables multiple selection
open class _MultipleSelectorViewController<T:Hashable, Row: SelectableRowType> : FormViewController, TypedRowControllerType where Row: BaseRow, Row: TypedRowType, Row.Value == T, Row.Cell.Value == T {
    
    /// The row that pushed or presented this controller
    open var row: RowOf<Set<T>>!
    
    open var selectableRowCellSetup: ((_ cell: Row.Cell, _ row: Row) -> ())?
    open var selectableRowCellUpdate: ((_ cell: Row.Cell, _ row: Row) -> ())?

    /// A closure to be called when the controller disappears.
    open var completionCallback : ((UIViewController) -> ())?
    
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        guard let options = row.dataProvider?.arrayData else { return }
        form +++ SelectableSection<Row, Row.Value>(row.title ?? "", selectionType: .multipleSelection) { [weak self] section in
            if let sec = section as? SelectableSection<Row, Row.Value> {
                sec.onSelectSelectableRow = { _, selectableRow in
                    var newValue: Set<T> = self?.row.value ?? []
                    if let selectableValue = selectableRow.value {
                        newValue.insert(selectableValue)
                    }
                    else {
                        newValue.remove(selectableRow.selectableValue!)
                    }
                    self?.row.value = newValue
                }
            }
        }
        for o in options {
            form.first! <<< Row.init() { [weak self] in
                    $0.title = String(describing: o.first!)
                    $0.selectableValue = o.first!
                    $0.value = self?.row.value?.contains(o.first!) ?? false ? o.first! : nil
                }.cellSetup { [weak self] cell, row in
                    self?.selectableRowCellSetup?(cell, row)
                }.cellUpdate { [weak self] cell, row in
                    self?.selectableRowCellUpdate?(cell, row)
                }
        
        }
        form.first?.header = HeaderFooterView<UITableViewHeaderFooterView>(title: row.title)
    }
    
}


open class MultipleSelectorViewController<T:Hashable> : _MultipleSelectorViewController<T, ListCheckRow<T>> {
}


