//
//  ViewController.swift
//  0_0 - Empty Template (Swift)
//
//  Created by Justin Reina on 11/12/15.
//  Copyright © 2015 Jaostech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addDatePicker(self.view);
        
        print("ViewController.viewDidLoad():       viewDidLoad() complete");
        
        return;
    }

    
    func addDatePicker(view:UIView) {
        
        let datePicker:UIDatePicker = UIDatePicker();
        
        let currDate:NSDate = datePicker.date;

        datePicker.translatesAutoresizingMaskIntoConstraints = false;
        
        print(currDate);

        print(self.hour(currDate));
 
        print(self.minute(currDate));
        
            
        view.addSubview(datePicker);

        return;
    }

    
    func hour(date:NSDate) -> Int {
        
        //Get Hour
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components(NSCalendarUnit.Hour, fromDate: date);
        let hour = components.hour;
        
        //Return Hour
        return hour;
    }
    
    
    func minute(date:NSDate) -> Int {
        
        //Get Minute
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components(NSCalendarUnit.Minute, fromDate: date);
        let minute = components.minute;
        
        //Return Minute
        return minute;
    }
    
    
    func toShortTimeString(date:NSDate) -> String {
        
        //Get Short Time String
        let formatter = NSDateFormatter();
        formatter.timeStyle = .ShortStyle;
        let timeString = formatter.stringFromDate(date);
        
        //Return Short Time String
        return timeString;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();

        return;
    }
}



