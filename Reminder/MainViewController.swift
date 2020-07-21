//
//  MainViewController.swift
//  Reminder
//
//  Created by Aleksa on 20.07.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0 ..< Base.shared.info.count {
            print("Title: \(Base.shared.info[i].title) Notes: \(Base.shared.info[i].notes)")
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }

        let sourceViewController = segue.source as! AddingViewController
        var reminder = sourceViewController.reminder

//        if let selectedIndexPath = collectionView.indexPathsForSelectedItems {
//
//            Base.shared.info[selectedIndexPath.] = reminder
//            collectionView.reloadItems(at: selectedIndexPath)
////            sendNotification(datePicker: sourceViewController.datePicker, reminder: reminder)
//            }
//
//        else {
//            reminder = Base.Reminder(title: reminder.title, notes: reminder.notes, guid: UUID().uuidString)
//            let newIndexPath = IndexPath(item: Base.shared.info.count, section: 0)
//            Base.shared.info.append(reminder)
//            collectionView.insertItems(at: [newIndexPath])
//            collectionView.reloadData()
////                sendNotification(datePicker: sourceViewController.datePicker, reminder: reminder)
//            }
    }
    
}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Base.shared.info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        
        let reminder = Base.shared.info[indexPath.item]
        cell.set(reminder: reminder)
        return cell
    }
    
    
    
}


