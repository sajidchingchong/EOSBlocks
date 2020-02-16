//
//  DetailViewController.swift
//  EOSBlocks
//
//  Created by Sajid Hussain on 8/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, AlertDisplayer {
    
    static var blockCache = [Int: Block?]()

    let blockUrl = "https://api.eosnewyork.io/v1/get_block"
    
    @IBOutlet weak var producer: UILabel!
    @IBOutlet weak var producerSignature: UILabel!
    @IBOutlet weak var transactionCount: UILabel!
    @IBOutlet weak var rawJson: UITextView!
    
    var detailItem : Block?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            self.producer.text = detail.producer
            self.producerSignature.text = detail.producerSignature
            self.transactionCount.text = String(detail.transactionCount())
            self.rawJson.text = detail.rawJson
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func toggleJson(_ sender: Any) {
        self.rawJson.isHidden = !self.rawJson.isHidden
    }
    
    var item: Int? {
        didSet {
            if let block: Block = DetailViewController.blockCache[item!]! {
                self.detailItem = block
                DispatchQueue.main.async {
                    self.configureView()
                }
            } else {
                URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: blockUrl)!) { data, response, error in
                    guard let data = data else {
                        print("Error: No block data!")
                        self.displayAlert(with: "Alas!" , message: "No Block Data is Found!", actions: [UIAlertAction(title: "OK", style: .default)])
                        return
                    }
                
                    let blockResponse: String = String(decoding: data, as: UTF8.self)
                    print("Block Response: " + blockResponse)
                
                    guard let block = try? JSONDecoder().decode(Block.self, from: data) else {
                        print("Error: Couldn't decode data into block")
                        return
                    }
                
                    self.detailItem = block
                    self.detailItem?.rawJson = blockResponse
                    DetailViewController.blockCache[self.item!] = self.detailItem
                
                    DispatchQueue.main.async {
                        self.configureView()
                    }
                
                }.resume()
            }
        }
    }

}

