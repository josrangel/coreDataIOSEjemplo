//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Parpaditos de kmmx on 10/22/20.

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Reference to managed object context
    let context =  (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext //NSManagedObject()
    
    // data for the table
    var items: [Person]?
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // get items from Core Data
        fetchPeople()
        
       // let _ = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
    }

    // MARK: - Private methods
    func fetchPeople() {
        // fetch the data from core data to display in the tableview
        
        do {
            self.items = try context?.fetch(Person.fetchRequest())
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            
        } catch  {
            print(" error on fetch the person")
        }
        
        
    }
    
    
    // MARK: - IBActions
    @IBAction func addTapped(_ sender: Any){
        // create alert
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        // configure action handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            // Get the textfield for the alert
            let textField = alert.textFields?.first
            
            // TODO create a person object
            // this is how we interact with the context
            let newPerson = Person(context: self.context!)
            newPerson.name = textField?.text
            newPerson.age = 50
            newPerson.gender = "Male"
            
            // TODO save the data
            do {
                try self.context?.save()
            } catch {
                print("unable to save data")
            }
            
            // TODO refresh the data
            self.fetchPeople()
        }
        
        // add button
        alert.addAction(submitButton)
        
        // show alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of people
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        // get the person from the array and set the label
        let person = self.items?[indexPath.row]
        cell.textLabel?.text = person?.name // "Placeholder ... "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // select person
        let person = self.items![indexPath.row]
        
        // create alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields?.first
        textField?.text = person.name
        
        // configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // get the textfield for the cell
            let textField = alert.textFields?.first
            
            //TODO  edit name property of person object
            person.name = textField?.text
            
            // TODO save the data
            do {
                try self.context?.save()
            } catch {
                print("Unable to update")
            }
            
            // TODO re-fetch the data
            self.fetchPeople()
        }
        
        // Add button
        alert.addAction(saveButton)
        
        // show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionhandler) in
            
            // TODO wich person to remove
            let personToRemove = self.items![indexPath.row]
            
            // TODO remove the person
            self.context?.delete(personToRemove)
            
            // TODO save the data
            do {
                try self.context?.save()
            } catch {
                print("Unable to delete")
            }
            
            // TODO re-fecth the data
            self.fetchPeople()
        }
        
        // return swipe action
        return UISwipeActionsConfiguration(actions: [action])
        
        
    }
    
}
