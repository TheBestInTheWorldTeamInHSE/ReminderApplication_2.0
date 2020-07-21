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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ReminderCell", bundle: nil), forCellWithReuseIdentifier: "ReminderCell")
        
        checkNotificationSettings(center: UNUserNotificationCenter.current())
        
    }
    
    func checkNotificationSettings(center: UNUserNotificationCenter) {
                
            center.getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .notDetermined {
                    // Notification permission has not been asked yet, go for it!
                    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
                } else if settings.authorizationStatus == .denied {
                    // Notification permission was previously denied, go to settings & privacy to re-enable
                } else if settings.authorizationStatus == .authorized {
                    // Notification permission was already granted
                }
            })
        }
    
    func sendNotification(datePicker: UIDatePicker, reminder: Base.Reminder) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
            
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = reminder.notes
        content.categoryIdentifier = "category"
        
        let date = datePicker.calendar.dateComponents([.day, .hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: reminder.guid, content: content, trigger: trigger)
        
        let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Snooze", options: [])
//        let doneAction = UNNotificationAction(identifier: "done", title: "Done", options: [])
        let category = UNNotificationCategory(identifier: "category", actions: [snoozeAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        center.add(request) {(error) in}
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            if response.actionIdentifier == "snooze" {
                var dayComponent = DateComponents()
                dayComponent.minute = 9
                let theCalendar = Calendar.current
                let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
                let comps = Calendar.current.dateComponents([.day, .hour, .minute], from: nextDate!)

                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                let request = UNNotificationRequest(identifier: response.notification.request.identifier,
                                                    content: response.notification.request.content, trigger: trigger)
    //            print(response.notification.request.identifier)
    //            print(response.notification.request.content)
    //            print(comps)
                center.add(request) {(error) in}
            }
            completionHandler()
        }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceViewController = segue.source as! AddingViewController
        var reminder = sourceViewController.reminder

        if let selectedIndexPath = collectionView.indexPathsForSelectedItems {
            Base.shared.info.append(reminder)
            print(Base.shared.info)
            collectionView.reloadItems(at: selectedIndexPath)
            sendNotification(datePicker: sourceViewController.datePicker, reminder: reminder)
        }
        else {
            reminder = Base.Reminder(title: reminder.title, notes: reminder.notes, guid: UUID().uuidString)
            let newIndexPath = IndexPath(item: Base.shared.info.count, section: 0)
            Base.shared.info.append(reminder)
            collectionView.insertItems(at: [newIndexPath])
            collectionView.reloadData()
            sendNotification(datePicker: sourceViewController.datePicker, reminder: reminder)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editReminder" else {return}
        
        guard let indexPath = (sender as? UIView)?.findCollectionViewIndexPath() else { return }
        
//        let indexPath = collectionView.indexPathsForSelectedItems!
//        print(indexPath)
//        let selectedIndexPath = selectedIndexPaths?.first
//        print(selectedIndexPath)
//        let reminder = Base.shared.info[indexPath.row]
//        let selectedIndexPaths = collectionView.indexPathsForSelectedItems()
//        let selectedIndexPath = selectedIndexPaths?.first
//        let row = self.tableView?.indexPathForSelectedRow?.row ?? 0
        let VC = segue.destination
        let addingVC = VC as! AddingViewController
//        addingVC.reminder = reminder
        
        
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


