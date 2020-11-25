//
//  HistoryViewController.swift
//  Where_Am_I
//
//  Created by MacsSuck on 2020-11-18.
//  Copyright © 2020 MacsSuck. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    let dataManager = DataManager()
    var locations: [Location] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // reload the collection view
        locations = DataManager.shared.locations()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDirections":
            if let vc = segue.destination as? MapViewController {
                vc.locations = locations
            }
            break
            
        case "showPin":
            if let vc = segue.destination as? MapViewController, let c = sender as? LocationCell {
                vc.location = c.location
            }
            break
        default:
            break
        }
    }
}

extension HistoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = locations[indexPath.item]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_LocationDetail", for: indexPath) as! LocationCell
        cell.location = location
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
