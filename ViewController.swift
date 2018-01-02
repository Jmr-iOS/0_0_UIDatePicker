/************************************************************************************************************************************/
/** @file       ViewController.swift
 *  @project    0_0 - UIDatePicker
 *  @brief      x
 *  @details    x
 *
 *  @author     Justin Reina, Firmware Engineer, Jaostech
 *  @created    11/6/16
 *  @last rev   1/3/18
 *
 *  @section    Reference
 *      https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDatePicker_Class/index.html#//apple_ref/occ/cl/UIDatePicker
 *      http://sourcefreeze.com/ios-datepicker-tutorial-uidatepicker-using-swift/
 *      http://www.brianjcoleman.com/tutorial-nsdate-in-swift/
 *
 *  @section    Opens
 *      switch to UIPickerView
 *      custom UIPickerView creation example
 *      confirm, edit & reset buttons with resp
 *      tap response
 *      UIDatePicker example
 *      DateFormatter example
 *
 * @section    Legal Disclaimer
 *     All contents of this source file and/or any other Jaostech related source files are the explicit property on Jaostech
 *     Corporation. Do not distribute. Do not copy.
 */
/************************************************************************************************************************************/
import UIKit


class ViewController: UIViewController {

    
    /********************************************************************************************************************************/
    /** @fcn        override func viewDidLoad()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.backgroundColor = UIColor.white;
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        addDatePicker(self.view);
        addCustPicker(self.view);
            
        print("ViewController.viewDidLoad():       viewDidLoad() complete");
        
        return;
    }

    
    /********************************************************************************************************************************/
    /** @fcn        func addDatePicker(_ view:UIView)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func addDatePicker(_ view:UIView) {
        
        var datePicker:UIDatePicker = UIDatePicker(frame: CGRect(x: 20, y: 50, width: UIScreen.main.bounds.width-40, height: 100));
        
        let currDate:Date = datePicker.date;
        
        datePicker.backgroundColor = UIColor.red;
        datePicker.translatesAutoresizingMaskIntoConstraints = true;
        
        print("ViewController.addDatePicker():     added date picker for \(currDate), of \(hour(currDate)) and \(minute(currDate))");
        
        view.addSubview(datePicker);

        return;
    }

    var textField = UITextField();
    var picker = UIDatePicker();
    
    
    /********************************************************************************************************************************/
    /** @fcn        func addCustPicker(_ view:UIView)
     *  @brief      x
     *  @details    x
     *
     *  @section    Reference
     *      https://developer.apple.com/documentation/uikit/uidatepicker
     */
    /********************************************************************************************************************************/
    func addCustPicker(_ view:UIView) {
        
        print("A");
        
        picker = UIDatePicker(frame: CGRect(x: 20, y: 225, width: UIScreen.main.bounds.width-40, height: 100));
//?     textField.inputView = picker;
        picker.addTarget(self, action: #selector(ViewController.handleDatePicker), for: UIControlEvents.valueChanged);
        picker.datePickerMode = .date;
        
        picker.backgroundColor = UIColor.blue;
        
        view.addSubview(picker)
        
        return;
    }
        
    
    enum Foo : CustomStringConvertible {
        case dmy;
        case ymd;
        case Boom;
        
        var description : String {
            switch self {
            case .dmy: return "dd-MM-yyyy";                             /* November 2 2018                                          */
            case .ymd: return "YYYY-MM-dd HH:mm";                       /* */
            case .Boom: return "Boom";
            }
        }
    }

    /********************************************************************************************************************************/
    /** @fcn        func handleDatePicker()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    @objc func handleDatePicker() {

        print("B");
        print(Foo.ymd);
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = Foo.ymd.description;
        textField.text = dateFormatter.string(from: picker.date);
        textField.resignFirstResponder();
        
        return;
    }
    

    /********************************************************************************************************************************/
    /** @fcn        func hour(_ date:Date) -> Int
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func hour(_ date:Date) -> Int {
        
        //Get Hour
        let calendar = Calendar.current;
        let components = (calendar as NSCalendar).components(NSCalendar.Unit.hour, from: date);
        let hour = components.hour;
        
        //Return Hour
        return hour!;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        func minute(_ date:Date) -> Int
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func minute(_ date:Date) -> Int {
        
        //Get Minute
        let calendar = Calendar.current;
        let components = (calendar as NSCalendar).components(NSCalendar.Unit.minute, from: date);
        let minute = components.minute;
        
        //Return Minute
        return minute!;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        func toShortTimeString(_ date:Date) -> String
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func toShortTimeString(_ date:Date) -> String {
        
        //Get Short Time String
        let formatter = DateFormatter();
        formatter.timeStyle = .short;
        let timeString = formatter.string(from: date);
        
        //Return Short Time String
        return timeString;
    }
    

    /********************************************************************************************************************************/
    /** @fcn        override func didReceiveMemoryWarning()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();

        return;
    }
}

