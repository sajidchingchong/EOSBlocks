//
//  MasterViewController.swift
//  EOSBlocks
//
//  Created by Sajid Hussain on 8/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    let loadingCellIdentifier = "loadingCell"
    let blockCellIdentifier = "blockCell"
    
    var detailViewController: DetailViewController? = nil
    
    var objects = [Block]()
    
    let blockUrl = "https://api.eosnewyork.io/v1"
    var url : URL {
        return URL(string: "\(blockUrl)")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: loadingCellIdentifier)
        tableView.register(UINib(nibName: "BlockTableViewCell", bundle: nil) , forCellReuseIdentifier: blockCellIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(reloadBlocks), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.item = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = objects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: blockCellIdentifier, for: indexPath) as! BlockTableViewCell
        cell.configureCell(with: object)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    @objc func reloadBlocks() {
        objects.removeAll()
        loadRecentBlockBatch()
        refreshControl?.endRefreshing()
    }
    
    private func loadRecentBlockBatch() {
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                print("Error: No block data!")
                return
            }
            
            print("Discovery Response: " + String(decoding: data, as: UTF8.self))
            
            guard let discoverResponse = try? JSONDecoder().decode(BlockResponse.self, from: data) else {
                print("Error: Couldn't decode data into discover response")
                return
            }
            
            self.objects.append(contentsOf: discoverResponse.results)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            }.resume()
    }

}

