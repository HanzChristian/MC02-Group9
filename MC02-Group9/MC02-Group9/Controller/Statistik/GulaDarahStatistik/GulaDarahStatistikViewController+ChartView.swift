//
//  GulaDarahStatistikViewController+ChartView.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 14/12/22.
//

import UIKit
import Charts

extension GulaDarahStatistikViewController{
    
    func setupLineChartView() {
        dayInit()
        
        lineChartView.setScaleEnabled(false)
        
        lineChartView.drawBordersEnabled = true
        lineChartView.borderColor = magenta100
        lineChartView.drawGridBackgroundEnabled = true
        lineChartView.gridBackgroundColor = magenta25
        lineChartView.rightAxis.enabled = false
        
        let yAxsis = lineChartView.leftAxis
        yAxsis.labelFont = .boldSystemFont(ofSize: 12)
        yAxsis.setLabelCount(4, force: true)
        
        yAxsis.labelTextColor = magenta100
        yAxsis.axisLineColor = magenta100
        yAxsis.labelPosition = .outsideChart
        //        yAxsis.drawGridLinesEnabled = false
        yAxsis.gridColor = magenta100
        
        let xAxsis = lineChartView.xAxis
        xAxsis.labelPosition = .bottom
        xAxsis.labelFont = .boldSystemFont(ofSize: 12)
        xAxsis.labelTextColor = magenta100
        xAxsis.axisLineColor = magenta100
        //        xAxsis.drawGridLinesEnabled = false
        xAxsis.gridColor = magenta100
        
        lineChartView.animate(xAxisDuration: 1)
        
        lineChartView = setupDailyView(chartView: lineChartView)
        
        if id == 2{
            
            lineChartView.borderColor = lime100
            lineChartView.gridBackgroundColor = lime25
            
            yAxsis.labelTextColor = lime100
            yAxsis.axisLineColor = lime100
            yAxsis.gridColor = lime100
            
            xAxsis.labelTextColor = lime100
            xAxsis.axisLineColor = lime100
            xAxsis.gridColor = lime100
        }
    }
    
    func setupWeeklyView(chartView: LineChartView) -> LineChartView{

        chartView.xAxis.labelRotationAngle = 0
        
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = 6
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: week)
        chartView.xAxis.setLabelCount(week.count, force: true)
        
        return chartView
    }
    
    func setupDailyView(chartView: LineChartView) -> LineChartView{
//        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: day)
        
//        chartView.xAxis.labelRotationAngle = -90
//        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = 1440
        
        chartView.xAxis.setLabelCount(5, force: true)
            
        let formatter = xAxisFormatter()
        chartView.xAxis.valueFormatter = formatter
        
        
        return chartView
    }
    
    func setupMonthView(chartView: LineChartView, numberOfDays: Int) -> LineChartView{
        chartView.xAxis.labelRotationAngle = 0
        
        chartView.xAxis.axisMinimum = 1
        chartView.xAxis.axisMaximum = Double(numberOfDays)
        
        chartView.xAxis.setLabelCount(6, force: true)
        chartView.xAxis.valueFormatter = nil
        
        return chartView
    }
    
    func setData() {
        //selected == 0
        var set1 = LineChartDataSet(entries: chartDataEntries,label: "Gula Darah")
                
        set1.label = ""
        set1.colors = [.secondarySystemBackground]
        
        set1.lineWidth = 0
        set1.valueFont = UIFont.systemFont(ofSize: 10)
        set1.setCircleColor(magenta50)
        set1.circleHoleColor = magenta50
        set1.circleRadius = 5
        
        set1.highlightColor = magenta100
        
        if id == 2{
            set1.setCircleColor(lime100)
            set1.circleHoleColor = lime100
            set1.highlightColor = lime100
        }
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        pFormatter.maximumFractionDigits = 0
        pFormatter.multiplier = 1

        
        let data = LineChartData(dataSet: set1)

        lineChartView.data = data
        
        lineChartView.lineData?.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
    }
    
}
