//
// Created by Danil Pestov on 06.12.16.
// Copyright (c) 2016 HOKMT. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

//MARK: -
public protocol DPSectionItemProtocol: SectionModelType {
    var header: String? { get }
    var items: [Item] { get }
}


public struct DPSectionModel<Identity: Hashable, ItemType: IdentifiableType & Equatable>: DPSectionItemProtocol, AnimatableSectionModelType {
    public typealias Item = ItemType
    
    public var header: String?
    public var items: [Item]
    public var identity: Identity
    
    public var hashValue: Int {
        return self.identity.hashValue
    }
    
    public init(identity: Identity, header: String?, items: [ItemType]) {
        self.identity = identity
        self.header = header
        self.items = items
    }
    
    public init(original: DPSectionModel<Identity, ItemType>, items: [ItemType]) {
        self.identity = original.identity
        self.header = original.header
        self.items = items
    }
}

//MARK: -
open class DPSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    func set(title: String?) {
        titleLabel.text = title
    }
}
