//
//  SnapsViewController.swift
//  SnapchatClone
//
//  Created by Steven Sherry on 12/18/16.
//  Copyright © 2016 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class SnapsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var snaps : [Snap] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Do any additional setup after loading the view.
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            
            let snap = Snap()
            let snapshotDictionary = snapshot.value as? NSDictionary
            snap.imageURL = snapshotDictionary!["imageURL"] as! String
            snap.from = snapshotDictionary!["from"] as! String
            snap.descrip = snapshotDictionary!["description"] as! String
            snap.key = snapshot.key
            snap.uuid = snapshotDictionary!["uuid"] as! String
            
            self.snaps.append(snap)
            
            self.tableView.reloadData()
            
        })
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            print(snapshot)
            
            var index = 0
            for snap in self.snaps {
                if snap.key == snapshot.key{
                    self.snaps.remove(at: index)
                }
                index += 1
            }
            self.tableView.reloadData()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        }else{
            return snaps.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            cell.textLabel?.text = "No Snaps 😫"
        } else {
            
            let snap = snaps[indexPath.row]
            
            cell.textLabel?.text = snap.from
            
        }
        return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let snap = snaps[indexPath.row]
            
            performSegue(withIdentifier: "viewSnapSegue", sender: snap)
            
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "viewSnapSegue"{
                let nextVC = segue.destination as! ViewSnapViewController
                nextVC.snap = sender as! Snap
            }
        }
        
}



