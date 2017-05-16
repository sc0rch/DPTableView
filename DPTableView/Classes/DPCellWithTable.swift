//
// Created by Danil Pestov on 06.12.16.
// Copyright (c) 2016 HOKMT. All rights reserved.
//

import RxSwift
import RxCocoa
import DZNEmptyDataSet

private let kHeightScrollFix: CGFloat = 20

open class DPCellWithTable: UITableViewCell {
    @IBOutlet private weak var tableView: DPTableView!
    
    open var cellType: AnyClass? {
        get {
            return tableView.cellType
        }
        set(cellType) {
            tableView.cellType = cellType
        }
    }
    
    open var noItemsText: String {
        get {
            return tableView.noItemsText
        }
        set(noItemsText) {
            tableView.noItemsText = noItemsText
        }
    }
    
    open var contentHeight: CGFloat {
        let height = tableView.contentSize.height
        if height > 0 {
            return height + kHeightScrollFix
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    //MARK: - SBTableMethods
    open func setupTable<CellType: UITableViewCell, ViewModel>(cellType: CellType.Type, viewModels: Observable<[ViewModel]>, isLoadFromNib: Bool = false)
        where CellType: DPTableViewElementCellProtocol, CellType.ViewModel == ViewModel {
            tableView.setup(cellType: cellType, viewModels: viewModels, isLoadFromNib: isLoadFromNib)
    }
    
    open func getModelSelectedObservable<ViewModel>(viewModel: ViewModel.Type) -> ControlEvent<ViewModel> {
        return tableView.rx.modelSelected(viewModel)
    }
}
