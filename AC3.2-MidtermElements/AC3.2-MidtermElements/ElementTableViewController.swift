//
//  ElementTableViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Ilmira Estil on 12/8/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ElementTableViewController: UITableViewController {
    let elementEndpoint = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements"
    let api = APIManager.manager
    var elements = [Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Periodic Table of Elements"
        getData()
    }
    
    func getData() {
        api.getData(endPoint: elementEndpoint) { (data: Data?) in
            if let validData = data {
                DispatchQueue.main.async {
                    self.elements = Element.buildElement(data: validData)!
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath)
        let currentCell = elements[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = currentCell.name
        cell.detailTextLabel?.text = ("\(currentCell.symbol)(\(currentCell.number)) \(currentCell.weight)")
        
        //images
        let elementImageEndpoint = "https://s3.amazonaws.com/ac3.2-elements/\(currentCell.symbol)_200.png"
        api.getData(endPoint: elementImageEndpoint) { (data: Data?) in
            if let validImageData = data {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: validImageData)!
                    cell.setNeedsLayout()
                }
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? DetailViewController,
            let cell = sender as? UITableViewCell,
            let indexpath = tableView.indexPath(for: cell) {
            dvc.elementDetails = elements[indexpath.row]
        }
    }
    
}



