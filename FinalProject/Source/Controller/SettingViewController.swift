//
//  SettingViewController.swift
//  FinalProject
//
//  Created by Zhexin Jia on 7/28/16.
//
//

import UIKit
import MessageUI

class SettingViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var autoAddingSwitch:UISwitch!
    @IBOutlet var setQuestionNumSwitch:UISwitch!
    @IBOutlet var keyboardPopUpSwitch:UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSwitch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let about = "The TFHpple html parser was Created by Geoffrey Grosenbach\n\n The DLRadioButton was created by Davyd Liu\n\nNote:\nBecause of the xcode bug, the email feature only works in real device, not simulator"
        if indexPath.section == 2 && indexPath.row == 1{
            let alertController = UIAlertController(title: "Resources Reference", message: about, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func autoAddingButton(sender: AnyObject) {
        
        if autoAddingSwitch.on{
            SettingService.sharedSettingService.setAutoAdd(true)
        }else{
            SettingService.sharedSettingService.setAutoAdd(false)
        }
        //print(SettingService.sharedSettingService.getAutoAdd())
        
    }
    
    
    @IBAction func setQuestionNum(sender: AnyObject) {
        if setQuestionNumSwitch.on{
            SettingService.sharedSettingService.setQuestionNum(20)
        }else{
            SettingService.sharedSettingService.setQuestionNum(10)
        }
        //print(SettingService.sharedSettingService.getQuestionNum())
    }
    
    
    @IBAction func keyboardPopUp(sender: AnyObject) {
        if keyboardPopUpSwitch.on{
            SettingService.sharedSettingService.setAutoPopUpKeyboard(true)
        }else{
            SettingService.sharedSettingService.setAutoPopUpKeyboard(false)
        }
        //print(SettingService.sharedSettingService.getAutoPopUPKeyboard())
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        let toRecipients = ["zhexinj@uoregon.edu"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject("App FeedBack")
        mc.setMessageBody("bug or feedback report", isHTML: false)
        mc.setToRecipients(toRecipients)
        if MFMailComposeViewController.canSendMail(){
            self.presentViewController(mc, animated: true, completion: nil)
        }else{
            print("can't send email")
        }
    }
    
    func updateSwitch(){
        if SettingService.sharedSettingService.getAutoAdd() == true{
            autoAddingSwitch.on = true
        }else{
            autoAddingSwitch.on = false
        }
        
        if SettingService.sharedSettingService.getQuestionNum() == 10{
            setQuestionNumSwitch.on  = false
        }else{
            autoAddingSwitch.on = true
        }
        
        if SettingService.sharedSettingService.getAutoPopUPKeyboard() == true{
            keyboardPopUpSwitch.on = true
        }else{
            keyboardPopUpSwitch.on = false
        }
    }
    
    
    //email functions
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue{
            
        case MFMailComposeResultCancelled.rawValue:
            NSLog("Mail Canceled")
            break;
        case MFMailComposeResultSaved.rawValue:
            NSLog("Mail Saved")
            break
        case MFMailComposeResultSent.rawValue:
            NSLog("Mail sent")
            break
        case MFMailComposeResultFailed.rawValue:
            NSLog("Mail sent failed: %@", [error!.localizedDescription])
            break
        default:
            break
     
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
