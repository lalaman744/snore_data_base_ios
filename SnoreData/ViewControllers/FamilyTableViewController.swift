//
//  ViewController.swift
//  SnoreData
//
//  Created by student1 on 4/2/19.
//  Copyright © 2019 clara. All rights reserved.
//

import UIKit
import CoreData

class FamilyTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, FamilyMemberDelegate {
    
    var managedContext: NSManagedObjectContext?
    var fetchResultsController: NSFetchedResultsController<FamilyMember>?
    var familyMemberObjects: [FamilyMember] = []
    
    func newFamilyMember(name: String, age: Int16) {
        let familyEntity = FamilyMember(context: managedContext!)
        familyEntity.name = name
        familyEntity.age = age
        
        do {
            try managedContext!.save()
        } catch {
            managedContext!.reset()
            showAlert(title: "Error", message: "Unable to add family member")
            print("Error adding new family member, \(error)")
        }
    }
    
    func modify(familyMember: FamilyMember) {
        
        do {
            try familyMember.validateForUpdate()
            try managedContext!.save()
        } catch {
            managedContext!.reset()
            showAlert(title: "Error", message: "Unable to modify family Member")
            print("Error saving family member, \(error)")
        }
        
    }
    
    func delete(familyMember: FamilyMember) {
        
        do {
            managedContext!.delete(familyMember)
            try managedContext!.save()
        } catch {
            managedContext!.reset()
            showAlert(title: "Error", message: "Unable to delete family member.")
            print("Error deleting family member, \(error)")
        }
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let familyFetch = NSFetchRequest<FamilyMember>(entityName: "FamilyMember")
        familyFetch.sortDescriptors = [sortDescriptor]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: familyFetch, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultsController!.delegate = self
        
        do {
            try fetchResultsController!.performFetch()
            familyMemberObjects = fetchResultsController!.fetchedObjects!
        } catch {
            print("Error fetching family members \(error)")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyMemberObjects.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let familyMember = familyMemberObjects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyTableCell")!
        cell.textLabel?.text = familyMember.name
        cell.detailTextLabel?.text = "\(familyMember.age) years old"
        return cell
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        
        familyMemberObjects = controller.fetchedObjects as! [FamilyMember]
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "addFamilyMember":
            let destination = segue.destination as! AddEditFamilyMemberViewController
            destination.familyDelegate = self
            
        case "editFamilyMember":
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let selectedRow = indexPath.row
            let selectedFamilyMember = familyMemberObjects[selectedRow]
            let destination = segue.destination as! AddEditFamilyMemberViewController
            destination.familyMember = selectedFamilyMember
            destination.familyDelegate = self
            
        case "showFamilyMemberSleepRecords":
            let selectedRow = tableView.indexPathForSelectedRow!.row
            let familyMember = familyMemberObjects[selectedRow]
            let destination = segue.destination as! SleepRecordViewController
            destination.managedContext = managedContext
            destination.familyMember = familyMember
            
        default:
            print("What type of segue is this??")
        }
        
    }
    
    
    

}

