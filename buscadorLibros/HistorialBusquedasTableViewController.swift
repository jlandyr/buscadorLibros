//
//  HistorialBusquedasTableViewController.swift
//  buscadorLibros
//
//  Created by Pedro Jose on 20/4/16.
//  Copyright © 2016 eureka. All rights reserved.
//

import UIKit
import CoreData

class HistorialBusquedasTableViewController: UITableViewController {

    var historial = [NSManagedObject]()
    
    override func viewWillAppear(animated: Bool) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Libros")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            historial = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("historial.count \(self.historial.count)")
        return self.historial.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("Cells", forIndexPath: indexPath)
        
        let libro = historial[indexPath.row]
        print("historial.titulo: \(libro.valueForKey("titulo") as! String) ")
        
        cell.textLabel?.text = (libro.valueForKey("titulo") as! String)
        cell.detailTextLabel?.text = (libro.valueForKey("autor") as! String)
        
        print(("cell.textlabel.text: \(cell.textLabel!.text)"))
//        cell?.textLabel?.text = libro.valueForKey("titulo") as? String
//        cell!.textLabel!.text = libro.valueForKey("titulo") as! String
        
        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mapViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        
        let libro = historial[indexPath.row]
        print("historial.titulo: \(libro.valueForKey("titulo") as! String) ")
        mapViewControllerObj?.titulo = libro.valueForKey("titulo") as! String
        mapViewControllerObj?.autor = libro.valueForKey("autor") as! String
        mapViewControllerObj?.imgData = libro.valueForKey("cover") as? NSData
        
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
