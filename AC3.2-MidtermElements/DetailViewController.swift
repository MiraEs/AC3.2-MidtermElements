//
//  DetailViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Ilmira Estil on 12/8/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

private let postEndpoint = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites"
class DetailViewController: UIViewController {
    let api = APIManager.manager
    var elementDetails: Element!
    var postData = [String:String]()
    
    @IBOutlet weak var detailNum: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailWeight: UILabel!
    @IBOutlet weak var detailBackgroundImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFullImage(symbol: (self.elementDetails?.symbol)!)
        self.title = elementDetails.name
        detailNum?.text = String(self.elementDetails.number)
        detailName?.text = self.elementDetails.name
        detailWeight?.text = String(self.elementDetails.weight)
        
        //Post data
        self.postData = [
            "my_name": "Mira",
            "favorite_element": self.elementDetails.name
        ]
        
        
    }
    
    //DELAYED HERE..
    func getFullImage(symbol: String) {
        let endpoint = "https://s3.amazonaws.com/ac3.2-elements/\(symbol).png"
        api.getData(endPoint: endpoint) { (data: Data?) in
            if let validImageData = data {
                DispatchQueue.main.async {
                    self.detailImage.image = UIImage(data: validImageData)
                    self.detailBackgroundImg.image = UIImage(data: validImageData)
                    self.view.setNeedsLayout()
                }
            }
        }
    }
    
    @IBAction func favoriteElement(_ sender: UIBarButtonItem) {
        api.postRequest(endPoint: postEndpoint, data: postData)
    }
}
