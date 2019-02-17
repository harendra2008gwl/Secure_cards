//
//  AddUpdatedCardVC.swift
//  SecureCards
//
//  Created by Harendra Sharma on 19/05/17.
//  Copyright © 2017 Harendra Sharma. All rights reserved.
//

import UIKit
import CoreData

class AddUpdatedCardVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var number_lbl: UITextField!
    @IBOutlet weak var exp_date_lbl: UITextField!
    @IBOutlet weak var card_cvv: UITextField!
    
    var Globle: GlobleClass! = nil
    var card: NSManagedObject?
    var actionName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Globle = GlobleClass ()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        headerLbl.text = actionName
        
        if (card != nil) {
            nickNameField.text = card?.value(forKey: "card_nick_name") as? String
            number_lbl.text = card?.value(forKey: "card_number") as? String
            exp_date_lbl.text = card?.value(forKey: "exp_date") as? String
            card_cvv.text = card?.value(forKey: "card_cvv") as? String
        }
        
        
    }
    
    
    
    
    func GetContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    
    @IBAction func BackClicked(_ sender: UIButton?) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func DoneClicked(_ sender: AnyObject?) {
        
        
        if (nickNameField.text?.count)!<=0 {
            Globle.ShowAlert(ViewControllder: self, title: "Alert", message: "Please Enter Card Nick Name.")
        }
        else  if (number_lbl.text?.count)!<19 {
            Globle.ShowAlert(ViewControllder: self, title: "Alert", message: "Please Enter 16 Digits Of Your Card.")
        }
        else  if (exp_date_lbl.text?.count)!<5 {
            Globle.ShowAlert(ViewControllder: self, title: "Alert", message: "Please Enter Valid Exp. Date Of Your Card.")
        }
        else  if (card_cvv.text?.count)!<3 {
            Globle.ShowAlert(ViewControllder: self, title: "Alert", message: "Please Enter Valid CVV Number Of Your Card.")
        }
        
       else
        {
            self.SaveOrUpdate()
            self.BackClicked(nil)
        }
        
    }
    
    
    func SaveOrUpdate()
    {
        let context = GetContext() as NSManagedObjectContext
        if (card != nil) {
            card?.setValue(card_cvv.text, forKey: "card_cvv")
            card?.setValue(nickNameField.text, forKey: "card_nick_name")
            card?.setValue(number_lbl.text, forKey: "card_number")
            card?.setValue(exp_date_lbl.text, forKey: "exp_date")
        }
        else
        {
            let entity =  NSEntityDescription.entity(forEntityName: "Card", in: context)
            let newcard = NSManagedObject(entity: entity!, insertInto: context)
            
            //set the entity values
            newcard.setValue(card_cvv.text, forKey: "card_cvv")
            newcard.setValue(nickNameField.text, forKey: "card_nick_name")
            newcard.setValue(number_lbl.text, forKey: "card_number")
            newcard.setValue(exp_date_lbl.text, forKey: "exp_date")
        }
        //save the object
        do {
            try context.save()
            print("saved!")
            
//        Globle.ShowAlert(ViewControllder: self, title: "Success.", message: "Your Card Details Are Saved Successfully.")
            
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            Globle.ShowAlert(ViewControllder: self, title: "failed.", message: "Could not save \(error), \(error.userInfo)")
            
        } catch {
            
        }

    }
    
    @IBAction func CopyClicked(_ sender: UIButton?) {
        
        let Copycardnumber = number_lbl.text?.replacingOccurrences(of: "-", with: "")
       
        if Copycardnumber?.count == 16 {
            UIPasteboard.general.string = Copycardnumber
             Globle.ShowAlert(ViewControllder: self, title: "Copied", message: "Card number copied.")
        }
        else
        {
        UIPasteboard.general.string = ""
        Globle.ShowAlert(ViewControllder: self, title: "Failed", message: "There is no valid card number to copy.")
        }
         print("Copied:" + Copycardnumber!)
        
       
    }
    
    
    
    
    
   
    // Mark: Add TextField Methods
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        
        if range.length + range.location > (textField.text?.count)! {
          return false
        }
        
        
         if textField == nickNameField {
            
            guard let text = textField.text else
            {
                return true
            }
            let newLength = text.count + string.count - range.length
            return newLength <= 30
        }

        
       else if textField == number_lbl {
            
           return Globle.GroupTextField(textField: textField, range: range, string: string, maxLength: 16, group: 4, seperater: "-")
        }
        else if textField == exp_date_lbl {
            
            return  Globle.GroupTextField(textField: textField, range: range, string: string, maxLength: 4, group: 2, seperater: "/")
            
        }
            
        else if textField == card_cvv {
            
            guard let text = textField.text else
            {
                return true
            }
            let newLength = text.count + string.count - range.length
            return newLength <= 3
        }

         else
        {
            return true
        }
    
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //Mark: Final closer... Do Not Write Code Below This Line.....
}
