//
//  TableSectionHeaderView.swift
//  YourRecipes
//
//  Created by user908549 on 11/26/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import UIKit

class TableSectionHeaderView: UIView {
    
    //MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARKL - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("TableSectionHeaderView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
    
}
