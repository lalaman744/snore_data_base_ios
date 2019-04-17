//
//  SleepRecordTableViewController.swift
//  SnoreData
//
//  Created by student1 on 4/2/19.
//  Copyright © 2019 clara. All rights reserved.
//


import UIKit
import CoreData

class SleepRecordViewController: UITableViewController, NSFetchedResultsControllerDelegate, SleepRecordDelegate {
    
    var familyMember: FamilyMember?
    var managedContext: NSManagedObjectContext?
    var sleepRecords: [SleepRecord] = []
    var fetchedSleepRecordsController: NSFetchedResultsController<SleepRecord>?
    
    
    let dateFormatter = {() -> DateFormatter in
        let df = DateFormatter()
        df.dateStyle = .long
        return df
    }()
    
    
    func newSleepRecord(familyMember: FamilyMember, hours: Float, date: Date) {
        let sleepRecord = SleepRecord(context: managedContext!)
        sleepRecord.hours = hours
        sleepRecord.date = date
        sleepRecord.familyMember = familyMember
        
        do {
            try sleepRecord.validateForInsert()
            try managedContext!.save()
        } catch {
            print("Error saving new sleep record because \(error)")
        }
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let familyMember = familyMember else {
            preconditionFailure("Family Member must be set")
        }
        
        navigationItem.title = "Sleep Records for \(familyMember.name!)"
        
        let familyPredicate = NSPredicate(format: "familyMember == %@", familyMember)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false) // most recent first
        
        let sleepRecordsFetch = NSFetchRequest<SleepRecord>(entityName: "SleepRecord")
        sleepRecordsFetch.sortDescriptors = [sortDescriptor]
        sleepRecordsFetch.predicate = familyPredicate
        
        fetchedSleepRecordsController = NSFetchedResultsController<SleepRecord>(fetchRequest: sleepRecordsFetch, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedSleepRecordsController?.delegate = self
        
        do {
            try fetchedSleepRecordsController?.performFetch()
            sleepRecords = fetchedSleepRecordsController!.fetchedObjects!
        } catch {
            print("Error fetching sleep records \(error)")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleepRecords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleepRecordTableCell")!
        let sleepRecord = sleepRecords[indexPath.row]
        cell.textLabel?.text = "\(dateFormatter.string(from: sleepRecord.date!))"
        cell.detailTextLabel!.text = "\(sleepRecord.hours) hours"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSleepRecord" {
            let addRecordController = segue.destination as!
                AddSleepRecordViewController
            addRecordController.delegate = self
            addRecordController.familyMember = familyMember!
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sleepRecords = controller.fetchedObjects as! [SleepRecord]
        tableView.reloadData()
    }
    

    
}
