//
// Created by i20 on 06.12.16.
// Copyright (c) 2016 i20. All rights reserved.
//

import RxSwift
import RxCocoa
import DZNEmptyDataSet

private let kHeightScrollFix: CGFloat = 20

class DPCellWithTable: UITableViewCell {
    @IBOutlet private weak var tableView: DPTableView!
    
    var cellType: AnyClass? {
        get {
            return tableView.cellType
        }
        set(cellType) {
            tableView.cellType = cellType
        }
    }
    
    var noItemsText: String {
        get {
            return tableView.noItemsText
        }
        set(noItemsText) {
            tableView.noItemsText = noItemsText
        }
    }
    
    var contentHeight: CGFloat {
        let height = tableView.contentSize.height
        if height > 0 {
            return height + kHeightScrollFix
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    //MARK: - SBTableMethods
    func setupTable<CellType: UITableViewCell, ViewModel>(cellType: CellType.Type, viewModels: Observable<[ViewModel]>, isLoadFromNib: Bool = false)
        where CellType: DPTableViewElementCellProtocol, CellType.ViewModel == ViewModel {
            tableView.setup(cellType: cellType, viewModels: viewModels, isLoadFromNib: isLoadFromNib)
    }
    
    func getModelSelectedObservable<ViewModel>(viewModel: ViewModel.Type) -> ControlEvent<ViewModel> {
        return tableView.rx.modelSelected(viewModel)
    }
}
