/************************************************************************************************************************************/
/** @file       ANotePickerView.swift
 *  @project    0_0 - UIPickerView
 *  @brief      class to wrap & control the aNote picker view
 *  @details    x
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


class ANotePickerView : UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
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

        print("ANotePickerView.init():             initialization complete");
        
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
    /** @fcn        getAsString() -> String
     *  @brief      generate the aNote data structure as a string
     *  @details    x
     *
     *  @section    Example
     *      ?
     */
    /********************************************************************************************************************************/
    func getAsString() -> String {
    
        var s = "[" + ViewController.selectedRowValue(handler: self, picker: self, ic: 0);

        for ic in 1...3 {
            s = s + ", " + ViewController.selectedRowValue(handler: self, picker: self, ic: ic);
        }
        s = s + "]";
        
        return s;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        Dimension
     *  @brief      table dimension
     *  @details    x
     */
    /********************************************************************************************************************************/
    enum Dimension {
        case cols;
        case rows;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        getCount(_ dim : ANotePickerView.Dimension) -> Int
     *  @brief      get requested dimension
     *  @details    x
     */
    /********************************************************************************************************************************/
    func getCount(_ dim : ANotePickerView.Dimension) -> Int {
        
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
    /** @fcn        required init?(coder aDecoder: NSCoder)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

