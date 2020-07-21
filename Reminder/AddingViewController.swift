//
//  AddingViewController.swift
//  Reminder
//
//  Created by Aleksa on 21.07.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import UIKit

class AddingViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var reminder = Base.Reminder(title: "", notes: "", guid: "")
    public let defaults = UserDefaults.standard
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    public let datePicker = UIDatePicker()
    
    func createDatePicker() {
          dateTextField.inputView = datePicker
          datePicker.datePickerMode = .dateAndTime
          datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
          self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dateChanged() {
           let formatter = DateFormatter()
           formatter.dateStyle = .short
           formatter.timeStyle = .short
           dateTextField.text = formatter.string(from: datePicker.date)
           updateSaveButtonState()
    }
    
    @objc func tapGestureDone() {view.endEditing(true)}
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let titleLength = titleTextField.text?.count
        let dateLength = dateTextField.text?.count
        
        saveButton.isEnabled = titleLength ?? 0 > 0 && dateLength ?? 0 > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
        createDatePicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }

        let title = titleTextField.text ?? ""
        let notes = notesTextField.text ?? ""

        self.reminder = Base.Reminder(title: title, notes: notes, guid: self.reminder.guid)
    }
    
}
