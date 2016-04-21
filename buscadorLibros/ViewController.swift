//
//  ViewController.swift
//  buscadorLibros
//
//  Created by Pedro Jose on 20/4/16.
//  Copyright © 2016 eureka. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var textFieldISBN: UITextField!
    @IBOutlet weak var textInformacion: UITextView!
    @IBOutlet weak var imageCover: UIImageView!
    
    let urlText = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    let appDelegate : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    var librosObject = [NSManagedObject]()
    
    var autor = ""
    var titulo = ""
    var imgData : NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if imgData != nil
        {
            self.textInformacion.text = "Título: " + titulo + "\n" + "Autor: " + autor
            self.imageCover.image = UIImage(data: imgData!)
            self.imageCover.hidden = false
        }
        else if autor != "" && titulo != ""
        {
            self.textInformacion.text = "Título: " + titulo + "\n" + "Autor: " + autor + "\n" + "NO TIENE PORTADA"
        }
        else
        {
            self.textFieldISBN.becomeFirstResponder()
        }
        
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveName(titulo: String, autor : String, imageData : NSData?) {
        
        let managedContext = self.appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Libros",inManagedObjectContext:managedContext)
        
        let libro = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)
        
        //3
        libro.setValue(titulo, forKey: "titulo")
        libro.setValue(autor, forKey: "autor")
        if imageData != nil
        {
            libro.setValue((imageData), forKey: "cover")
        }
        else
        {
            libro.setValue(nil, forKey: "cover")
        }
        //4
        do {
            try managedContext.save()
            //5
            librosObject.append(libro)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func loadJson(isbn: String)
    {
        let urls = NSURL(string:urlText + isbn)
        let datos = NSData(contentsOfURL: urls!)
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
            let dictionary = json as! NSDictionary
            let isbnDictionary = dictionary["ISBN:"+isbn] as! NSDictionary
            
            let authorsArray = isbnDictionary["authors"] as! NSArray
            let authors = authorsArray[0] as! NSDictionary
            let nombreAutor = authors["name"] as! String
            print("Author: \(authors["name"])")
            
            let title = isbnDictionary["title"] as! String
            print("Title: \(title)")
            
            
            
            if let cover = isbnDictionary["cover"]
            {
                print("Si tiene portada")
                self.textInformacion.text = "Autor: " + nombreAutor + "\n" + "Título: " + title
                
                let coverDictionary = cover as! NSDictionary
                var imageData : NSData?
                
                if let urlCover = coverDictionary["large"]
                {
                    imageData = loadImageUrl(urlCover as! String)!
                }else if let urlCover = coverDictionary["medium"]
                {
                    imageData = loadImageUrl(urlCover as! String)!
                }else if let urlCover = coverDictionary["small"]
                {
                    imageData = loadImageUrl(urlCover as! String)!
                }
                
                saveName(title, autor: nombreAutor, imageData: imageData)
            }
            else
            {
                saveName(title, autor: nombreAutor, imageData: nil)
                self.textInformacion.text = "Autor: " + nombreAutor + "\n" + "Título: " + title + "\n" + "NO TIENE PORTADA"
            }
        }
        catch{}
    }
    
    func loadImageUrl(urlString: String) -> NSData? {
        let url = NSURL(string:urlString)
        let data = NSData(contentsOfURL:url!)
        if data != nil {
            self.imageCover.image = UIImage(data:data!)
            self.imageCover.hidden = false
            return data
        }
        else
        {
            self.imageCover.hidden = true
            return nil
        }
    }
}

//MARK: UITextField Delegate
extension ViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        if textField.hasText()
        {
            self.textInformacion.text = "Cargando..."
         loadJson(textField.text!)
         print("search ISBN")
        }
        return true
    }
    
   
}
