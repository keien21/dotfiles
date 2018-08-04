//
//  ViewController.swift
//  ChartsApp
//
//  Created by 西川継延 on 2018/07/24.
//  Copyright © 2018年 kei. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var bodyfat: UITextField!
    @IBOutlet weak var chtChart: LineChartView!
    @IBOutlet weak var chartssegment: UISegmentedControl!
    @IBOutlet weak var mytableView: UITableView!
    var numbers : [Double] = []
    var bfpnumbers : [Double] = []
    var item = String()
    
    var dete = NSDate()
    
    @IBAction func okBtr(_ sender: Any) {
        let input = Double(weight.text!)
        let output = Double(bodyfat.text!)
        
        numbers.append(input!) //here we add the data to the array.
        bfpnumbers.append(output!)
        
        updateGraph()
        item.append("\(numbers)" + "\(bfpnumbers)")
        mytableView.reloadData()
        weight.text = ""
        bodyfat.text = ""
    }
    
    func updateGraph(){
        var lineChartEntry = [ChartDataEntry]()//ここが折れ線グラフのキー
        var lineChartEntry2 = [ChartDataEntry]()
        
        for i in 0..<numbers.count {
    
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
        
            //Y軸の右側の値について
            //chtChart.rightAxis.enabled = true
            //chtChart.leftAxis.drawGridLinesEnabled = false
            
            lineChartEntry.append(value)

        
        }
        
        for i in 0..<bfpnumbers.count {
            
            let value2 = ChartDataEntry(x: Double(i), y: bfpnumbers[i])
            
            //Y軸の右側の値について
            //chtChart.rightAxis.enabled = true
            //chtChart.leftAxis.drawGridLinesEnabled = false
            
            lineChartEntry2.append(value2)
            
        }

        let line1 = LineChartDataSet(values: lineChartEntry, label: "円相場")
        line1.colors = [NSUIColor.blue]
        
        let line2 = LineChartDataSet(values: lineChartEntry2, label: "ドル相場")
        line2.colors = [NSUIColor.red]
        
        line1.axisDependency = .left
        line2.axisDependency = .right
        
        line1.circleRadius = 6
        line1.circleColors = [UIColor.red]
        
        line2.circleRadius = 5
        line2.circleColors = [UIColor.blue]
        
        
        let xAxis = chtChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = numbers.count
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        

        //横軸を非表示
        //chtChart.xAxis.enabled = true

        chtChart.leftAxis.axisMaximum = 150 //y左軸最大値
        chtChart.leftAxis.axisMinimum = 30 //y左軸最小値
        
        chtChart.rightAxis.axisMaximum = 50 //y左軸最大値
        chtChart.rightAxis.axisMinimum = 0 //y左軸最小値
        
        chtChart.rightAxis.drawGridLinesEnabled = false

        let data = LineChartData()
        data.addDataSet(line1)
        data.addDataSet(line2)
        
        chtChart.data = data
        chtChart.chartDescription?.text = "My awesome chart"
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale? // ロケールの設定
        dateFormatter.dateFormat = "yyyy/MM/dd  "//:ss" // 日付フォーマットの設定
        
        let dateString = dateFormatter.string(from: dete as Date)
        print(dateString) // -> 2014/06/25 02:13:18*/
        
        let str = String("\(numbers)" + "\(bfpnumbers)")
        
        cell.textLabel?.text = dateString + ("\(numbers[indexPath.row]) " + "¥  " +  "\(bfpnumbers[indexPath.row])") + " $"//str.description
        
        /*if numbers.count > 2 {
            numbers.remove(at: indexPath.row)
            mytableView.reloadData()
        }*/
        
        print(str)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row % 2 == 0 else { return UISwipeActionsConfiguration(actions: []) }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { action, view, completionHandler in
            self.numbers.remove(at: indexPath.row)
            self.bfpnumbers.remove(at: indexPath.row)
            self.mytableView.reloadData()
            completionHandler(true)
        }
        
        let edit = UIContextualAction(style: .normal,title: "edit", handler:
        { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
            //self.showTextFieldAlert(.titleEdit, index: indexPath.section)
            success(true)
        })
        
        edit.backgroundColor = .blue
        let config = UISwipeActionsConfiguration(actions: [deleteAction,edit])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mytableView.delegate = self
        mytableView.dataSource = self
        //mytableView.separatorColor = UIColor.clear
        makeKeybord()
        self.weight.keyboardType = UIKeyboardType.decimalPad
        self.bodyfat.keyboardType = UIKeyboardType.decimalPad
        
    }
    //入力画面を閉じる時
    func makeKeybord(){
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.commitButtonTapped))
        
        kbToolBar.items = [spacer, commitButton]
        weight.inputAccessoryView = kbToolBar
        bodyfat.inputAccessoryView = kbToolBar
    }
    
    @objc func commitButtonTapped (){
        self.view.endEditing(true)
    }
}
