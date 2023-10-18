//
//  ViewController.swift
//  test
//
//  Created by sandeep on 2023-10-17.
//

import UIKit

class ProjectConstants{
    static var minSpacing:CGFloat = 24
    static var widthMultiplier = 0.2929
    static var phoneWidthMultiplier = 0.9
    static var detailViewWidthConstraint:CGFloat = 100
    static var apiUrl = "testreq"
}
// Basic model for data parsing
struct BasicModel: Codable {
    var property1: String
    var property2: Int
    // Add more properties as needed

    enum CodingKeys: String, CodingKey {
        case property1
        case property2
        // Define coding keys for other properties as needed
    }
}

func isIPhone() -> Bool {
return UIDevice.current.userInterfaceIdiom == .phone
}
class SomeVC: UIViewController{

    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var detailViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var detailView: UIView!
    var detailVC: UIViewController?
    var dataArray: [BasicModel]? // Replace YourModel with your data model
    // Add a loading indicator
    let activityIndicator = UIActivityIndicatorView(style: .medium)

     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the data source for the collection view
        self.collectionView.dataSource = self

        // Other setup code
        collectionView.register(UINib(nibName: "someCell", bundle: nil), forCellWithReuseIdentifier: "someCell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(dismissController))
    }
    
    override func viewWillAppear(_ animated: Bool) {
       fetchData()
    }
    
    @objc func dismissController () {}
    
    func fetchData() {
    activityIndicator.startAnimating() // Show the loading indicator
        let url = URL(string: ProjectConstants.apiUrl)!
    let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
        
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating() // Hide the loading indicator
        }
        // Handle errors, if any
                   guard error == nil else {
                       print("Error: \(error!.localizedDescription)")
                       return
                   }
        if let data = data {
            do {
                // Decode the data into the expected format with the actual data model).
                let basicModels = try JSONDecoder().decode([BasicModel].self, from: data)
                self.dataArray = basicModels
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error)")
                // Handle the decoding error, e.g., show an error message to the user.
            }
        }
    }
    task.resume()
    }
    
    
    @IBAction func closeShowDetails() {
         detailViewWidthConstraint.constant = 0
         UIView.animate(withDuration: 0.5) {
             self.view.layoutIfNeeded()
         } completion: { [weak self] (completed) in
             self?.detailVC?.removeFromParent()
         }
     }

     @IBAction func showDetail() {
         detailViewWidthConstraint.constant = ProjectConstants.detailViewWidthConstraint
         UIView.animate(withDuration: 0.5) {
             self.view.layoutIfNeeded()
         } completion: { [weak self] (completed) in
             self?.view.addSubview(self?.detailView ?? UIView())
         }
     }
}
extension SomeVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource  {
    
    open func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthMultiplier: CGFloat = ProjectConstants.widthMultiplier
    if isIPhone() {
        widthMultiplier = ProjectConstants.phoneWidthMultiplier
    }
        
    return CGSize(width: view.frame.width * widthMultiplier ,
    height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
    collectionViewLayout: UICollectionViewLayout,

    minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        let frameWidth = (view.frame.width * ProjectConstants.widthMultiplier * 3) + 84
    var minSpacing: CGFloat = (view.frame.width - frameWidth)/2
    if isIPhone() {
        minSpacing = ProjectConstants.minSpacing
    }
    return minSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.dataArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
    return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.showDetail()
    }
}
