//
//  DetailsViewController.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import UIKit

enum TableViewSection: Int {
    case photo
    case description
    case ingredients
}

class DetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Identifiers
    let identifierPhotoCell = "identifierPhotoCell"
    let identifierCell = "identifierCell"
    
    //MARK: - Properties
    var cdRecipe: CDRecipe? = nil {
        didSet {
            prepareCellModel()
        }
    }
    var cellModels: [TableViewSection: [CellModel]] = [TableViewSection.photo: [],
                                                     TableViewSection.description: [],
                                                     TableViewSection.ingredients: []
                                                    ]
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
        if cdRecipe != nil {
            title = cdRecipe?.title
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
 
    //MARK: - UI
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "PhotoTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifierPhotoCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifierCell)
    }
    
    //MARK: - Data
    func prepareCellModel() {
        for (key, _) in cellModels {
            cellModels[key] = initialValue(for: key)
        }
    }
    
    func initialValue(for section: TableViewSection) -> [CellModel] {
        var cellModelsToReturn = [CellModel]()
        switch section {
        case .photo:
            let model = CellModel()
            model.entryValue = cdRecipe?.correctFormatImageUrl()
            cellModelsToReturn.append(model)
        case .description:
            let model = CellModel()
            model.entryValue = cdRecipe?.desc
            cellModelsToReturn.append(model)
        case .ingredients:
            guard ((cdRecipe?.ingredients) != nil) else { return cellModelsToReturn }
            for cdIngredient in (cdRecipe?.ingredients)! {
                if let ingredient = cdIngredient as? CDIngredient {
                    let model = CellModel()
                    model.entryValue = ingredient.name
                    cellModelsToReturn.append(model)
                }
            }
        }
        
        return cellModelsToReturn
    }
    
}

//MARK: UITableViewDelegate, DataSource
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        if let sectionEnum = TableViewSection.init(rawValue: section){
            returnValue = (cellModels[sectionEnum]?.count)!
        }
        
        return returnValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellModels.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if let sectionEnum = TableViewSection.init(rawValue: indexPath.section){
            switch sectionEnum {
            case .photo:
                let model = cellModels[sectionEnum]![indexPath.row]
                let photoCell = tableView.dequeueReusableCell(withIdentifier: identifierPhotoCell)
                cell = configurePhotoCell(photoCell as! PhotoTableViewCell, for: model)
            case .description, .ingredients:
                let model = cellModels[sectionEnum]![indexPath.row]
                let cellNormal = tableView.dequeueReusableCell(withIdentifier: identifierCell)
                cellNormal?.textLabel?.numberOfLines = 0
                cellNormal?.textLabel?.text = model.entryValue as? String
                cell = cellNormal!
            }
        }
        
        return cell
    }
    
    func configurePhotoCell(_ cell: PhotoTableViewCell,for model: CellModel) -> PhotoTableViewCell {
        if let url = model.entryValue as? URL {
            cell.photoImageView.sd_setShowActivityIndicatorView(true)
            cell.photoImageView.sd_setIndicatorStyle(.gray)
            cell.photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "RecipeLogo"), options: [], completed: nil)
        } else {
            cell.photoImageView.image = UIImage(named: "RecipeLogo")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionEnum = TableViewSection.init(rawValue: section){
            if sectionEnum == .ingredients {
                let headerView =  TableSectionHeaderView()
                headerView.titleLabel.text  = "DetailsVC_TitleHeaderSectionIngredietns".localized()
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionEnum = TableViewSection.init(rawValue: section){
            if sectionEnum == .ingredients {
                return 65.0
            }
        }
        
        return 0.0
    }
}
