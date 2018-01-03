/************************************************************************************************************************************/
/** @file       ViewController.swift
 *  @project    0_0 - UIPickerView
 *  @brief      x
 *  @details    x
 *
 *  @author     Justin Reina, Firmware Engineer, Jaostech
 *  @created    11/6/16
 *  @last rev   1/3/18
 *
 *  @section    Reference
 *      https://codewithchris.com/uipickerview-example/
 *      https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDatePicker_Class/index.html#//apple_ref/occ/cl/UIDatePicker
 *      http://sourcefreeze.com/ios-datepicker-tutorial-uidatepicker-using-swift/
 *      http://www.brianjcoleman.com/tutorial-nsdate-in-swift/
 *
 *  @section    Opens
 *  [X] switch to UIPickerView
 *      Layout written implementation steps in header
 *      custom UIPickerView creation example (aNote ref)
 *      grab & reset buttons with resp (buttons & text view)
 *      tap response
 *      UIDatePicker example
 *      DateFormatter example
 *
 *  @section    Components
 *      [1] UIPickerView        (picker)
 *      [2] [[Data]]            (pickerData)
 *
 *
 *  @section    Procedure
 *
 * @section    Legal Disclaimer
 *     All contents of this source file and/or any other Jaostech related source files are the explicit property of Jaostech
 *     Corporation. Do not distribute. Do not copy.
 */
/************************************************************************************************************************************/
import UIKit


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //UI
    var picker_1col  : UIPickerView!;
    var picker_3col  : UIPickerView!;
    var picker_aNote : UIPickerView!;
    
    //Init Data
    var pickerData_1col  : [String]!;
    var pickerData_3col  : [[String]]!;
    var pickerData_aNote : [[String]]!;                                     /* temp                                                 */
    
    let picker_1col_hash  : Int;
    let picker_3col_hash  : Int;
    let picker_aNote_hash : Int;
    
    /********************************************************************************************************************************/
    /** @fcn        init()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    init() {
        
        //Init UI
        picker_1col = UIPickerView();
        picker_3col = UIPickerView();
        picker_aNote = UIPickerView();
        
        //Hashes
        picker_1col_hash  = picker_1col.hashValue;
        picker_3col_hash  = picker_3col.hashValue;
        picker_aNote_hash = picker_aNote.hashValue;
        
        super.init(nibName: nil, bundle: nil);
        
        print("My Custom Init - \(picker_1col.hashValue), \(picker_3col.hashValue), \(picker_aNote.hashValue)");
        
        return;
    }
    
    
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

        //Add Pickers
        addPicker_1col(self.view);
        addPicker_3col(self.view);
        addPicker_aNote(self.view);
        
        genTestArr();
        getDayOfMonth("2018-01-03");
        getDayOfMonth("2018-04-13");
        
        print("ViewController.viewDidLoad():       viewDidLoad() complete");
        
        return;
    }

    
    /********************************************************************************************************************************/
    /** @fcn        addPicker_1col(_ view:UIView)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func addPicker_1col(_ view : UIView) {
        
        //Set size
        picker_1col.frame = CGRect(x: 50, y: 75,  width: 200, height: 100);
        
        //Set data
        pickerData_1col = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"];
        print(pickerData_1col.count);
        
        // Connect data
        picker_1col.delegate   = self;
        picker_1col.dataSource = self;
        
        //Add to view
        view.addSubview(picker_1col);
        
        print("ViewController.addPicker_1col():   picker added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        addPicker_3col(_ view:UIView)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func addPicker_3col(_ view:UIView) {
        
        //Set size
        picker_3col.frame = CGRect(x: 50, y: 90, width: 200, height: 400);
        
        //Set data
        pickerData_3col = gen3ColData(true);
        
        print(pickerData_3col.count);
        print(pickerData_3col[0].count);

        print(pickerData_3col[0][0]);       											/* cols go horiz, rows go vert [R][C]		*/
        //!print(pickerData_3col[4][0]);
        
        // Connect data
        picker_3col.delegate   = self;
        picker_3col.dataSource = self;
        
        //Add to view
        view.addSubview(picker_3col);
        
        print("ViewController.addPicker_3col():   picker added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        addPicker_aNote(_ view:UIView)
     *  @brief      x
     *  @details    x
     *
     *  @section    Fields
     *      "Today        11    15    AM"       R: <365, 24, 2>
     *      "Thu Jan 4    11    15    AM"       C: 3
     */
    /********************************************************************************************************************************/
    func addPicker_aNote(_ view:UIView) {
        
        //Set size
        picker_aNote.frame = CGRect(x: 50, y: 270, width: 200, height: 400);
        
        //Set data
        pickerData_aNote = gen3ColData(true);
        
        print(pickerData_aNote.count);
        print(pickerData_aNote[0].count);
        
        print(pickerData_aNote[0][0]);                                                 /* cols go horiz, rows go vert [R][C]        */
        //!print(pickerData_aNote[4][0]);
        
        // Connect data
        picker_aNote.delegate   = self;
        picker_aNote.dataSource = self;
        
        //Add to view
        view.addSubview(picker_aNote);
        
        print("ViewController.addPicker_aNote():   picker added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        gen3ColData(_ isGenerated : Bool) -> [[String]]
     *  @brief      return a 2D array either manually or programmatically
     *  @details    show the difference
     */
    /********************************************************************************************************************************/
    func gen3ColData(_ isGenerated : Bool) -> [[String]] {
        
        var data : [[String]];
        
        let colNames : [String] = ["A", "B", "C", "D", "E"];
        
        if(isGenerated) {
            //Code Gen
            data = [[String]]();
            
            for i in 0...4 {                                                /* [Cols]                                               */
                var newArr : [String] = [String]();
                for j in 0...3 {                                            /* [Rows]    [C][R] <-> [X][Y] <-> <X,Y>                */
                    newArr.append("\(colNames[i])\(j)");
                }
                data.append(newArr);
            }
        } else {
            //Manual Gen
            data = [["1", "2", "3", "4", "5"],                              /* 5 columns(X), 4 rows(Y),                             */
                ["a", "b", "c", "d", "e"],                              /* visual disp is transposed from access                */
                ["!", "#", "$", "%", "?"],
                ["v", "w", "x", "y", "z"]];
        }
        
        return data;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        numberOfComponents(in pickerView: UIPickerView) -> Int
     *  @brief      The number of columns of data
     *  @details    called in picker initialization
     */
    /********************************************************************************************************************************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        let hash = pickerView.hashValue;
        let val  : Int;
        
        switch(hash) {
        case picker_1col_hash:
            val = 1;
            break;
        case picker_3col_hash:
            val = pickerData_3col[0].count;
            break;
        case picker_aNote_hash:
            val = pickerData_aNote[0].count;
            break;
        default:
            fatalError();
        }
        
        return val;
    }
  
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     *  @brief      The number of rows of data
     *  @details    called on picker generation
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let hash = pickerView.hashValue;
        let val  : Int;
        
        switch(hash) {
        case picker_1col_hash:
            val = pickerData_1col.count;
            break;
        case picker_3col_hash:
            val = pickerData_3col.count;
            break;
        case picker_aNote_hash:
            val = pickerData_aNote.count;
            break;
        default:
            fatalError();
        }
        
        return val;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     *  @brief      The data to return for the row and component (column) that's being passed in
     *  @details    called on picker scroll
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let hash = pickerView.hashValue;
        let val  : String;
        
        //Disp selection value
        //print("C:\(component), R:\(row)");
        
        switch(hash) {
        case picker_1col_hash:
            val = pickerData_1col[row];
            break;
        case picker_3col_hash:
            if((row<5)&&(component<4)) {
                val = pickerData_3col[row][component];
            } else {
                fatalError("Unexpected array access requested of R:\(row), C:\(component), aborting");
            }
            break;
        case picker_aNote_hash:
            if((row<5)&&(component<4)) {
                val = pickerData_aNote[row][component];
            } else {
                fatalError("Unexpected array access requested of R:\(row), C:\(component), aborting");
            }
            break;

        default:
            fatalError();
        }
        
        return val;
    }

//<PREV>
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
    
    
    /********************************************************************************************************************************/
    /** @fcn        getHash(picker : NSObject) -> Int
     *  @brief      get hash of object
     *  @details    x
     */
    /********************************************************************************************************************************/
    func getHash(object : NSObject) -> Int {
        return object.hashValue;
    }
    

    /********************************************************************************************************************************/
    /** @fcn        init?(coder aDecoder: NSCoder)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        genTestArr()
     *  @brief      generate the aNote data structure
     *  @details    x
     *
     *  @section    Fields
     *      "Today        11    15    AM"       R: <365, 24, 2>
     *      "Thu Jan 4    11    15    AM"       C: 3
     *
     *  @section    Opens
     *      fields 0-2 loop
     *      responds to scrolls with value updates (e.g. when 59->0, increment the hour)
     */
    /********************************************************************************************************************************/
    func genTestArr() {
        
        var dateArr  = [String]();
        var hourArr  = [String]();
        var minArr   = [String]();
        var meridArr = [String]();

        
        //@open     year is selectable?
        //Col 0 - Date
            //Mon Jan 1
            //Tue Jan 2
            //Today
            //Sun Jan 7
        for day in 1...365 {
            
            //gen date string
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy D";
            let date = dateFormatter.date(from: "\(2018) \(day)");
            let myCalendar = Calendar(identifier: .gregorian);
            
            let month : Int = myCalendar.component(.month, from: date!);
            let day   : Int = myCalendar.component(.day,   from: date!);
            let year  : Int = myCalendar.component(.year,  from: date!);
            
            //get date string
            let dateStr : String = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))";
            
            //append
            dateArr.append(dateStr);
        }
        
        //Col 1 - Hour (0..12)
        for i in 1...12 {
            hourArr.append("\(i)");
        }
        
        //Col 2 - Min
        for i in 1...59 {
            minArr.append("\(i)");
        }
        
        //Col 3 - Date
        meridArr = ["AM", "PM"];
        
        return;
    }
    
    
    //@todo     header
    //Jan: 01
    //Feb: 02
    func getYear(_ today:String)-> Int {
        
        let formatter  = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let todayDate = formatter.date(from: today);
        let myCalendar = Calendar(identifier: .gregorian);
        
        let month : Int = myCalendar.component(.month, from: todayDate!);
        let day   : Int = myCalendar.component(.day, from: todayDate!);
        let year  : Int = myCalendar.component(.year, from: todayDate!);
        
        return year;
    }
    
    
    //@todo     header
    //Jan: 01
    //Feb: 02
    func getMonth(_ today:String)-> Int {
        
        let formatter  = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let todayDate = formatter.date(from: today);
        let myCalendar = Calendar(identifier: .gregorian);
        
        let month : Int = myCalendar.component(.month, from: todayDate!);
        let day   : Int = myCalendar.component(.day, from: todayDate!);
        let year  : Int = myCalendar.component(.year, from: todayDate!);
        
        return month;
    }
    

    //@todo     header
    //1st: 01
    //2nd: 02
    func getDayOfMonth(_ today:String)-> Int {
        
        let formatter  = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let todayDate = formatter.date(from: today);
        let myCalendar = Calendar(identifier: .gregorian);

        let month : Int = myCalendar.component(.month, from: todayDate!);
        let day   : Int = myCalendar.component(.day, from: todayDate!);
        let year  : Int = myCalendar.component(.year, from: todayDate!);
        
        return day;
    }
    
    
    //@todo     header
    //Su:1
    //M:2
    func getDayOfWeek(_ today:String)->Int {
        let formatter  = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let todayDate = formatter.date(from: "2018-01-03")!;
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!;
        let myComponents = myCalendar.components(.weekday, from: todayDate);
        let weekDay = myComponents.weekday;
        return weekDay!;
    }

}

