//
//  PushRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/24/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation

open class _PushRow<T: Equatable, Cell: CellType> : SelectorRow<T, Cell, SelectorViewController<T>> where Cell: BaseCell, Cell: TypedCellType, Cell.Value == T {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .show(controllerProvider: ControllerProvider.callback { return SelectorViewController<T>(){ _ in } }, completionCallback: { vc in vc.navigationController?.popViewController(animated: true) })
    }
}

/// A selector row where the user can pick an option from a pushed view controller
public final class PushRow<T: Equatable> : _PushRow<T, PushSelectorCell<T>>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
