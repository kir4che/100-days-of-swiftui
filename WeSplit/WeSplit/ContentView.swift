//
//  ContentView.swift
//  WeSplit
//
//  Created by Molly on 2023/9/9.
//

import SwiftUI

struct ContentView: View {
    @State private var orderTotal: Float = 0
    @State private var numberOfPeople = 0
    
    let tipPercentages: [Int] = [10, 15, 20, 25, 0]
    @State private var tipPercentage: Int = 20
    
    @FocusState private var totalIsFocused: Bool
    
    // 計算總金額（含小費）
    var totalAmount: Float {
        let tipValue = orderTotal * Float(tipPercentage) / 100
        return orderTotal + tipValue
    }
    
    // 計算每個人需要支付的費用
    var totalPerPerson: Int {
        let peopleCount = numberOfPeople + 1
        return Int(totalAmount) / peopleCount
    }
    
    // 貨幣格式化
    func currencyFormatter(maxDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyISOCode
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.maximumFractionDigits = maxDigits
        return formatter
    }

    var body: some View {
        VStack {
            Text("WeSplit")
                .font(.largeTitle)
                .fontWeight(.bold)
            NavigationView {
                Form {
                    Section {
                        TextField("NT 0", value: $orderTotal, formatter: currencyFormatter(maxDigits: 0))
                            .keyboardType(.numberPad)
                            .focused($totalIsFocused)
                            .toolbar {
                                // 在鍵盤出現時顯示一個「完成」按鈕
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer() // 讓按鈕靠右對齊
                                    Button("完成") {
                                        totalIsFocused = false
                                    }
                                }
                            }
                        // numberOfPeople 會自動生成一個 Binding<Int> 的變數，並與 numberOfPeople 連接。
                        Picker("分帳人數", selection: $numberOfPeople) {
                            // 遍歷 1 到 10
                            ForEach(1..<11) {
                                Text("\($0) 人")
                            }
                        }
                    }
                    Section{
                        // id: \.self 是指對於每一 tipPercentages 的元素，都用它自己作為識別碼。
                        Picker("小費", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }.pickerStyle(.segmented) // 顯示成分段選擇器
                    } header: {
                        Text("你想留下多少小費？")
                    }
                    Section(header: Text("總金額（含小費）")) {
                        Text("\(totalAmount as NSNumber, formatter: currencyFormatter(maxDigits: 2))")
                    }
                    Section(header: Text("每人應付金額")) {
                        Text("\(totalPerPerson as NSNumber, formatter: currencyFormatter(maxDigits: 0))")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
