/************************************************************************************************************************************/
/** @file       CustomPickerViewrView.swift
 *  @project    0_0 - UIPickerView
 *  @brief      class to wrap & control a custom picker view
 *  @details    picker imitates the UIDatePicker in XYZ configuration
 *
 *  @notes      data is private to enforce api access
 *
 *  @section    Opens
 *      handle hour and minute changes, updating meridian (bug to mitigate)
 *
 *  @section    Legal Disclaimer
 *      All contents of this source file and/or any other Jaostech related source files are the explicit property on Jaostech
 *      Corporation. Do not distribute. Do not copy.
 */
/************************************************************************************************************************************/
import UIKit


class CustomPickerView : UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Data
    private var dateArr  = [String]();
    private var hourArr  = [String]();
    private var minArr   = [String]();
    private var meridArr = [String]();
    
    //Constants
    private let aNote_colWidths  : [CGFloat] = [150, 40, 60, 80];

    //Data
    private var pickerData_aNote  : [[String]]!;
    private var picker_aNote_hash : Int!;
    
    
    /********************************************************************************************************************************/
    /** @fcn        init()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    override init(frame : CGRect) {
        
        super.init(frame:frame);
        
        //Hash
        picker_aNote_hash = hashValue;

        //Set size
        self.frame = CGRect(x: (UIScreen.main.bounds.width/2-165), y: 300, width: 330, height: 300);
        
        //Set data
        pickerData_aNote = genTableData();
        
        // Connect data
        delegate   = self;
        dataSource = self;
        
        //Init scroll position
        selectRow((10_000/2), inComponent: 0, animated: false);
        selectRow((10_000/2), inComponent: 1, animated: false);
        selectRow((10_000/2), inComponent: 2, animated: false);
        selectRow(1,          inComponent: 3, animated: false);

        if(verbose) { print("ANotePickerView.init():             initialization complete"); }
        
        return;
    }
    

    /********************************************************************************************************************************/
    /** @fcn        numberOfComponents(in pickerView: UIPickerView) -> Int
     *  @brief      The number of columns of data
     *  @details    called in picker initialization
     */
    /********************************************************************************************************************************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        let val = pickerData_aNote.count;

        return val;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     *  @brief      The number of rows of data
     *  @details    called on picker generation
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let sizes = [10_000, 10_000, 10_000, 2];
        
        let val = sizes[component];
        
        return val;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     *  @brief      The data to return for the row and component (column) that's being passed in
     *  @details    called on picker scroll
     *  @hazard     a bug calls this multiple times per single scroll for large row counts (ex 10_000)
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let val  : String?;
        
        switch(component) {
            case 0:
                val = dateArr[row%dateArr.count];
                break;
            case 1:
                val = hourArr[row%hourArr.count];
                break;
            case 2:
                let c = (row%minArr.count);                                             /* unexpected bug if used direct            */
                val = minArr[c];
                break;
            case 3:
                val = meridArr[row];
                break;
            default:
                fatalError("component \(component) exceeded, aborting");
            }
        
        return val!;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
     *  @brief      return the columns width
     *  @details    x
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return aNote_colWidths[component];
    }
        
    
    /********************************************************************************************************************************/
    /** @fcn        genTableData()
     *  @brief      generate the aNote data structure
     *  @details    x
     *
     *  @section    Fields
     *      "Today        11    15    AM"       R: <365, 24, 2>
     *      "Thu Jan 4    11    15    AM"       C: 3
     */
    /********************************************************************************************************************************/
    func genTableData() -> [[String]] {
        
        for day in 1...365 {
            
            //gen date string
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy D";
            let date = dateFormatter.date(from: "\(2018) \(day)");
            let myCalendar = Calendar(identifier: .gregorian);
            
            let month   : Int = myCalendar.component(.month,   from: date!);
            let day     : Int = myCalendar.component(.day,     from: date!);
            let weekday : Int = myCalendar.component(.weekday, from: date!);
            
            //get date string
            let months : [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            let days   : [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
            
            let dateStr : String = "\(days[weekday-1]) \(months[month-1]) \(day)";
            
            //append
            dateArr.append(dateStr);
        }
        
        //Col 1 - Hour (0..12)
        for i in 1...12 {
            hourArr.append("\(i)");
        }
        
        //Col 2 - Min (00..05...55)
        var t_min : Int = 0;
        
        while (t_min < 60) {
            let minStr : String = String(format: "%02d", t_min);
            minArr.append("\(minStr)");
            t_min = t_min + 5;                                                  /* update for next row                              */
        }
        
        //Col 3 - Date
        meridArr = ["AM", "PM"];
        
        let retArr = [dateArr, hourArr, minArr, meridArr];
        
        return retArr;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        class func pickValue()
     *  @brief      show picker for date selection
     *  @details    init to current date
     */
    /********************************************************************************************************************************/
    class func pickValue() {
        CustomPickerView.pickValue(Date(timeIntervalSinceNow: 0));
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        class func pickValue(_ picker : ANotePickerView?)
     *  @brief      show picker for date selection
     *  @details    x
     *
     *  @param      [in] (ANotePickerView?) picker - picker to extract init date from
     */
    /********************************************************************************************************************************/
    class func pickValue(_ picker : CustomPickerView?) {
        fatalError("not yet supported");
        //CustomPickerView.pickValue((picker?.getDate())!);
        //return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        getAsString() -> String
     *  @brief      generate the aNote data structure as a string
     *  @details    x
     *
     *  @section    Example
     *      ?
     */
    /********************************************************************************************************************************/
    func getAsString() -> String {
    
        var s = "[" + Utils.selectedRowValue(handler: self, picker: self, ic: 0);

        for ic in 1...3 {
            s = s + ", " + Utils.selectedRowValue(handler: self, picker: self, ic: ic);
        }
        s = s + "]";
        
        return s;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        getCount(_ dim : Dimension) -> Int
     *  @brief      get requested dimension
     *  @details    x
     */
    /********************************************************************************************************************************/
    func getCount(_ dim : Dimension) -> Int {
        
        switch(dim) {
            case .cols:
                return self.genTableData().count;
            case .rows:
                return self.genTableData()[0].count;
        }
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        getValue(ic : Int) -> String
     *  @brief      get value of selected column
     *  @details    x
     */
    /********************************************************************************************************************************/
    func getValue(ic : Int) -> String {
        
        var val : String;
        let row : Int = selectedRow(inComponent: ic);
        
        switch(ic) {
            case 0:
                val = dateArr[row%dateArr.count];
                break;
            case 1:
                val = hourArr[row%hourArr.count];
                break;
            case 2:
                let c = (row%minArr.count);                                             /* unexpected bug if used direct            */
                val = minArr[c];
                break;
            case 3:
                val = meridArr[row];
                break;
            default:
                fatalError("component \(ic) exceeded, aborting");
        }

        return val;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        getDate() -> Date
     *  @brief      parse current selection
     *  @return     current selection as date
     *
     *  @section    Component Access
     *      day   = Calendar.current.component(.day, from: date)
     *      month = Calendar.current.component(.month, from: date)
     *
     *  @section    Opens
     *      Handle error case where (hour==12) && (mer==PM)
     *      Handle scrolling issues, off by '1' quite consistently?
     *      Understand and resolve why very last row of column zero states row=0, currently ignored
     */
    /********************************************************************************************************************************/
    func getDate() -> Date {

        print(">>----------------------------------------------------------------------------------------------------//");
        var dc    : DateComponents = DateComponents();                              /* used for date generation                     */
        
        //Init
        dc.calendar = Calendar(identifier: .gregorian);
        dc.timeZone = TimeZone(abbreviation: "PST");

        //Get Fields (Date, Hr, Min, Merid)
        let val   = ((selectedRow(inComponent: 0)+1)%365);                          /*  +1 for zero-indexed row                     */
        var date  = DateComponents(calendar: dc.calendar, year: 0, day: val).date;
        var hr    = ((selectedRow(inComponent: 1)%hourArr.count)+1);                /*  +1 for zero-indexed row                     */
        let min   = ((selectedRow(inComponent: 2)%minArr.count)*5);
        let mer   = selectedRow(inComponent: 3);
        
        //Apply Meridian (AM/PM)
        if(mer > 0) {
            hr = (hr + 12);
        }
        print("val:\(val)");
        //Grab hour & minute from
        var newComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!);
        newComps.year   = 0;                                                        /* set to 0 for simplicity                      */
        newComps.hour   = hr;
        newComps.minute = min;
        newComps.second = 0;
        
        date = Calendar.current.date(from: newComps);
        
        print("ANotePickerView.getDate():          date returned (\(date!))");
        print(">>----------------------------------------------------------------------------------------------------//\n\n");
        return date!;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        resetPressed()
     *  @brief      reset fields
     *  @details    x
     */
    /********************************************************************************************************************************/
    func resetPressed() {
        selectRow((10_000/2), inComponent: 0, animated: true);
        selectRow((10_000/2), inComponent: 1, animated: true);
        selectRow((10_000/2), inComponent: 2, animated: true);
        selectRow(1,          inComponent: 3, animated: true);
        
        return;

    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        class func pickValue(_ date : Date)
     *  @brief      show picker for date selection
     *  @details    called by class & raw versions
     *
     *  @param      [in] (Date) date - value to initialize display with
     */
    /********************************************************************************************************************************/
    class func pickValue(_ date : Date) {
        
        //Fields
//      let cal : Calendar = Calendar.current;
//      let hr  : Int = cal.component(.hour, from: date);
        
        //Second Picker
//      let sec : Int = cal.component(.second, from: date);
        
        //Meridian
        print("--> Open Picker Here @todo");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        required init?(coder aDecoder: NSCoder)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601);
}
