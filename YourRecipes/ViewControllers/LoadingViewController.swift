//
//  LoadingViewController.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    //MARK: - Identifiers
    let segueToList = "fromLoadingToList"

    //MARK: - Properties

    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColorsForUI()
        setTextForUI()
        setImage()
        setAppearance(for: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }

    //MARK: - Prepare UI
    func setColorsForUI() {
        view.backgroundColor = UIColor.getColor(for: .background)
        informationLabel.textColor = UIColor.getColor(for: .fontWhite)
        retryButton.tintColor = UIColor.getColor(for: .fontWhite)
        authorLabel.textColor = UIColor.getColor(for: .fontWhite)
    }
    
    func setTextForUI() {
        informationLabel.text = "LoadingVC_FetchingData".localized()
        retryButton.setTitle("LoadingVC_RetryButton".localized(), for: .normal)
        authorLabel.text = "LoadingVC_Author".localized()
    }
    
    func setImage() {
        let image = UIImage(named: "RecipeLogo")
        photoImageView.image = image
    }
    
    func setAppearance(for isDownload: Bool) {
        retryButton.isHidden = isDownload
        informationLabel.isHidden = !isDownload
        activityIndicatorView.isHidden = !isDownload
        
        if isDownload {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    
    //MARK: - Fetching data
    func fetchData() {
        let parameters = RecipeParameters(tags: "", size: "thumbnail-medium", ratio: 1, limit: 50, from: 0)
        APIManager.shared.fetchRecipes(parameters: parameters).then { [unowned self](_) in
            self.performSegue(withIdentifier: self.segueToList, sender: self)
         }.catch { (error) in
            let alert = UIAlertController(title: "Global_AlertTitle".localized(), message: "Global_AlertyBody".localized(), preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Global_OK".localized(), style: UIAlertActionStyle.default, handler: { (action) in
                self.performSegue(withIdentifier: self.segueToList, sender: self)
            })
            let cancelAction = UIAlertAction(title: "Global_Cancel".localized(), style: UIAlertActionStyle.cancel, handler: { (action) in
                self.setAppearance(for: false)
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }


    //MARK: - Actions
    @IBAction func tappedRetryButton(_ sender: Any) {
        setAppearance(for: true)
        fetchData()
        
    }
}
