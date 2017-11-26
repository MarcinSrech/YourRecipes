//
//  ListViewController.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import UIKit
import SDWebImage

class ListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Identifiers
    let segueToDetails = "fromListToDetails"
    let identifierListCell = "identifierListCell"
    
    //MARK: - Properties
    var isFiltering = false
    var allRecipes = [CDRecipe]()
    var filteredRecipes = [CDRecipe]()

    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()

        allRecipes = fetchData()
        prepareTableView()
        searchBar.delegate = self
        title = "ListVC_Title".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

   
    //MARK: - UI
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "ListTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifierListCell)
    }
    
    //MARK: - Fetch Data
    func fetchData() -> [CDRecipe] {
        let recipes = CDRecipe.mr_findAllSorted(by: "title", ascending: true) as! [CDRecipe]

        return recipes
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToDetails {
            let destVC = segue.destination as! DetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                if isFiltering {
                    destVC.cdRecipe = filteredRecipes[indexPath.row]
                } else {
                    destVC.cdRecipe = allRecipes[indexPath.row]
                }
            }
        }
    }
}

//MARK: UITableViewDelegate, DataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredRecipes.count
        } else {
            return allRecipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifierListCell) as! ListTableViewCell
        
        cell = configureCell(cell, for: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: ListTableViewCell,for indexPath: IndexPath) -> ListTableViewCell {
        let cdRecipe = isFiltering ? filteredRecipes[indexPath.row] : allRecipes[indexPath.row]
        cell.titleLabel.text = cdRecipe.title
        cell.descriptionLabel.text = cdRecipe.desc
        
        if let url = cdRecipe.correctFormatImageUrl() {
            cell.photoImageView.sd_setShowActivityIndicatorView(true)
            cell.photoImageView.sd_setIndicatorStyle(.gray)
            cell.photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "RecipeLogo"), options: [], completed: nil)
        } else {
            cell.photoImageView.image = UIImage(named: "RecipeLogo")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueToDetails, sender: self)
    }
}

//MARK: - UISearchBarDelegate Delegate
extension ListViewController: UISearchBarDelegate  {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isFiltering = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isFiltering = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = true
        guard searchBar.text != nil else { return }
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText == "" {
            filteredRecipes = allRecipes
        } else {
            filteredRecipes = allRecipes.filter({ cdRecipe in
                let matchingIngredients = cdRecipe.ingredients?.allObjects.filter({ (cdIngredient) in
                    guard let title = (cdIngredient as? CDIngredient)?.name else { return false }
                    return title.lowercased().contains(searchText.lowercased())
                })
                
                guard let title = cdRecipe.title else { return (matchingIngredients?.count)! > 0 }
                return title.lowercased().contains(searchText.lowercased()) || (matchingIngredients?.count)! > 0
            })
        }
        
        tableView.reloadData()
    }
}

