//
// Created by i20 on 06.12.16.
// Copyright (c) 2016 i20. All rights reserved.
//

import RxSwift
import RxCocoa
import DZNEmptyDataSet
import RxDataSources

protocol DPTableViewElementCellProtocol {
    associatedtype ViewModel
    
    static var estimatedHeight: CGFloat { get }
    func set(viewModel: ViewModel)
}

//MARK: -
protocol DPSectionItemProtocol: SectionModelType {
    associatedtype ViewModel
    
    var header: String { get }
    var items: [ViewModel] { get }
}

//MARK: -
class DPSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    func set(title: String?) {
        titleLabel.text = title
    }
}

//MARK: -
class DPTableView: UITableView {
    private var disposeBag = DisposeBag()
    
    ///CellType saved from setup method
    var cellType: AnyClass?
    
    ///HeaderType saved from setup method
    var headerType: DPSectionHeader.Type?
    
    ///Text, that showed when row count == 0
    var noItemsText: String = ""
    
    ///If true then when selected cell will be auto deselected
    var isAutoDeselect: Bool = true
    
    //MARK: Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    private func setupTableView() {
        self.emptyDataSetSource = self
        self.emptyDataSetDelegate = self
        self.rowHeight = UITableViewAutomaticDimension
        self.tableFooterView = UIView()
        self.delegate = self
    }
    
    //MARK: Sizing
    ///Compress and correct sizing header of tableView
    func sizeHeaderToFit() {
        DispatchQueue.main.async {
            if let headerView = self.tableHeaderView {
                headerView.setNeedsLayout()
                headerView.layoutIfNeeded()
                let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
                var frame = headerView.frame
                frame.size.height = height
                headerView.frame = frame
                self.tableHeaderView = headerView
            }
        }
    }
    
    //MARK: Setups
    ///Basic setup for RxTableView, that same for non-sectioned and sectioned tables.
    private func basicSetup<CellType: UITableViewCell>(cellType: CellType.Type, isLoadFromNib: Bool = false)
        where CellType: DPTableViewElementCellProtocol {
            
            dataSource = nil
            estimatedRowHeight = CellType.estimatedHeight
            
            self.cellType = cellType
            
            if isLoadFromNib {
                register(cellType.nib, forCellReuseIdentifier: cellType.describing)
            }
            layoutIfNeeded()
    }
    
    /**
     Setup table view with RxDataSource
     - parameter cellType: Type of cell, that will be used for present data in table. Must conform **SBTableViewElementCellProtocol**.
     - parameter viewModels: Observable of array of viewModels, that will be used for cell configuration.
     - parameter isLoadFromNib: If **true**, view for cell will be loaded from *xib*, that named same as cell type. See: `UIView.nib`.
     - parameter customCellSetup: Custom configuration block, called for each cell on reload data for cell.
     */
    func setup<CellType: UITableViewCell, ViewModel>(cellType: CellType.Type,
               viewModels: Observable<[ViewModel]>,
               isLoadFromNib: Bool = false,
               customCellSetup: ((CellType, Int) -> Void)? = nil)
        where CellType: DPTableViewElementCellProtocol, CellType.ViewModel == ViewModel {
            
            basicSetup(cellType: cellType, isLoadFromNib: isLoadFromNib)
            
            //Cell configuration
            viewModels
                .bindTo(self.rx.items(cellIdentifier: cellType.describing, cellType: cellType))
                { row, viewModel, cell in
                    cell.set(viewModel: viewModel)
                    if let customCellSetup = customCellSetup {
                        customCellSetup(cell, row)
                    }
                }
                .addDisposableTo(disposeBag)
    }
    
    
    /**
     Setup table view with RxTableViewSectionedReloadDataSource.
     - parameter cellType: Type of cell, that will be used for present data in table. Must conform **SBTableViewElementCellProtocol**.
     - parameter items: Observable of array of section items, that will be used for cell configuration and header titles. Section items must conform **SBSectionItemProtocol**.
     - parameter isLoadFromNib: If **true**, view for cell will be loaded from *xib*, that named same as cell type. See: `UIView.nib`.
     - parameter headerType: If not nil, view loaded from xib with that type will be used for section header.
     - parameter customCellSetup: Custom configuration block, called for each cell on reload data for cell.
     */
    func setup<CellType: UITableViewCell, SectionItem:DPSectionItemProtocol, HeaderType:DPSectionHeader>(cellType: CellType.Type,
                                                                                                         items: Observable<[SectionItem]>,
                                                                                                         isLoadFromNib: Bool = false,
                                                                                                         headerType: HeaderType.Type? = nil,
                                                                                                         customCellSetup: ((CellType) -> Void)? = nil)
        where CellType: DPTableViewElementCellProtocol, CellType.ViewModel == SectionItem.ViewModel {
            
            basicSetup(cellType: cellType, isLoadFromNib: isLoadFromNib)
            
            //Register header
            if let headerType = headerType {
                self.headerType = headerType
                register(headerType.nib, forHeaderFooterViewReuseIdentifier: headerType.describing)
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionItem>()
            
            //Cell configurations
            dataSource.configureCell = { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier:cellType.describing, for: indexPath)
                
                if let cell = cell as? CellType, let item = item as? CellType.ViewModel{
                    cell.set(viewModel: item)
                    if let customCellSetup = customCellSetup {
                        customCellSetup(cell)
                    }
                }
                return cell
            }
            
            //Section titles
            dataSource.titleForHeaderInSection = { dateSource, section in
                return dataSource[section].header
            }
            
            items.bindTo(self.rx.items(dataSource: dataSource))
                .addDisposableTo(disposeBag)
    }
}

//MARK: - UITableViewDelegate
extension DPTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let title = dataSource?.tableView?(self, titleForHeaderInSection: section)
        if let _ = title {
            return UITableViewAutomaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerType = headerType, let dataSource = dataSource {
            let header = dequeueReusableHeaderFooterView(withIdentifier: headerType.describing) as? DPSectionHeader
            let title = dataSource.tableView?(self, titleForHeaderInSection: section)
            header?.set(title: title)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let title = dataSource?.tableView?(self, titleForHeaderInSection: section)
        if let _ = title {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAutoDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK: - DZNEmptyDataSet
extension DPTableView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        return NSAttributedString(string: noItemsText, attributes: attributes)
    }
}
