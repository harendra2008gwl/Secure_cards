//
//  ViewController.swift
//  SecureCards
//
//  Created by Harendra Sharma on 15/05/17.
//  Copyright © 2017 Harendra Sharma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var cardsTbl: UITableView!
    
    var ActionName: NSString? = nil
//    var cards  = Array<Any>()
    var cards = [NSManagedObject]()

    
    var ccard :  NSManagedObject? = nil
    
    @IBOutlet weak var cSearchBar: UISearchBar!
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsTbl.cellLayoutMarginsFollowReadableWidth = false

        
        // Do any additional setup after loading the view, typically from a nib.
        //save()
       
        cardsTbl.delegate = self
        cardsTbl.dataSource = self
        cSearchBar.delegate = self
        cSearchBar.showsCancelButton = true
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         GetCards()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func GetContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
  
    func GoNextScreen() -> Void {
        self.performSegue(withIdentifier: "addupdatesegue", sender: self)
    }
    
   
    @IBAction func AddNewCard(_ sender: UIButton) {
        ActionName = "Add New Card"
        ccard = nil
        self.GoNextScreen()
    }
    

    
    
    func GetCards() -> Void {
        
        let context = GetContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        let fetchedData = try! context.fetch(request)
      
        for card in fetchedData {
                print((card as! NSManagedObject).value(forKey: "card_nick_name") ?? "")
        }
        
        print("fetchedData Count: \(fetchedData.count)")
        
        guard let Arr = fetchedData as? Array<NSManagedObject>, Arr.count > 0 else {
            //What ever condition you want to do on fail or simply return
            return
        }
          
        cards = Arr
        cardsTbl.reloadData()
    }
    
    
    
    // MARK: UITableView, DataSource and Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardsIdentifier", for: indexPath )
       
        
        let card = cards[indexPath.row]
        
        var lbl = self.view.viewWithTag(1) as! UILabel
        
        lbl.text = "Nick Name: \(String(describing: card.value(forKey: "card_nick_name") as! String))"
        
        lbl = self.view.viewWithTag(2) as! UILabel
        lbl.text = "Card Number: \(String(describing: card.value(forKey: "card_number") as! String))"
        
        lbl = self.view.viewWithTag(3) as! UILabel
        lbl.text = "Exp. Date: \(String(describing: card.value(forKey: "exp_date") as! String))"
        
        lbl = self.view.viewWithTag(4) as! UILabel
        lbl.text = "CVV: \(String(describing: card.value(forKey: "card_cvv") as! String))"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
    indexPath: IndexPath){
    
    ccard = cards[indexPath.row]
    self.GoNextScreen()
}
    
    
    
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let context = GetContext() 
            context.delete(cards[indexPath.row])
            
            //save the object
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }

            cards.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
   
  // MARK: Tableview cell right, left margins adjustment.  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
  // Mark: - UISearch Bar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         print("searchBarCancelButtonClicked")
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.GetCards()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         print("searchBarCancelButtonClicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         print("textDidChange:" + searchText)
        
        if searchText.count>0 {
            let context = GetContext()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
//            request.predicate = NSPredicate(format: "card_nick_name = %@", searchText) // Search, when find exact string.
            request.predicate = NSPredicate(format: "card_nick_name CONTAINS[cd] %@", searchText) // Search, if string contains.

            do{
                let results = try context.fetch(request)
                cards = results as! Array<NSManagedObject>
                cardsTbl.reloadData()
                
                for result in results
                {
                    print(result)
                }
                
            } catch let error{
                print(error)
            }
        }
        else{
          GetCards()
        }
    }
    
    // Mark: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene =  segue.destination as! AddUpdatedCardVC
        nextScene.actionName = "Add New Card"
        nextScene.card = ccard
    }

    
 //Mark: Final closer... Do Not Write Code Below This Line.....
}






