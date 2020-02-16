//
//  MasterViewController.swift
//  EOSBlocks
//
//  Created by Sajid Hussain on 8/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    static let TOTAL_BLOCKS: Int = 20
    
    let loadingCellIdentifier = "loadingCell"
    let blockCellIdentifier = "blockCell"
    
    var detailViewController: DetailViewController? = nil
    
    var blocks = [Int]()
    var head: Int = -1
    var tail: Int = -1
    
    let infoUrl = "https://api.eosnewyork.io/v1/get_info"
    var url : URL {
        return URL(string: "\(infoUrl)")!
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
                let block = blocks[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.item = block
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
        return MasterViewController.TOTAL_BLOCKS
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let block = blocks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: blockCellIdentifier, for: indexPath) as! BlockTableViewCell
        cell.configureCell(with: block)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            blocks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    @objc func reloadBlocks() {
        loadRecentBlockBatch()
        refreshControl?.endRefreshing()
    }
    
    private func loadRecentBlockBatch() {
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                print("Error: No block data!")
                return
            }
            
            print("Info Response: " + String(decoding: data, as: UTF8.self))
            
            guard let infoResponse = try? JSONDecoder().decode(InfoResponse.self, from: data) else {
                print("Error: Couldn't decode data into info response")
                return
            }
            
            if infoResponse.headBlockNum != self.head {
                self.head = infoResponse.headBlockNum
                if self.blocks.count > 0 {
                    var peek: Int = self.head
                    for i in MasterViewController.TOTAL_BLOCKS-1...0 {
                        self.blocks[i] = peek
                        peek -= 1
                    }
                    self.tail = peek + 1
                } else {
                    for i in MasterViewController.TOTAL_BLOCKS-1...0 {
                        self.blocks.append(infoResponse.headBlockNum - i)
                    }
                    self.tail = self.head - MasterViewController.TOTAL_BLOCKS + 1
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            }.resume()
    }

}

