import SwiftUI

// どの処理を行うのかを判断するためのEnum
enum CalculateState {
    case initial, addition, substraction, multiplication, division, sum
}

struct ContentView: View {
    
    // ボタン押下時の入力情報（初期値は"0"）
    @State var selectedItem: String = "0"
    // 計算記号ごとに処理を分けるためのEnum
    @State var calculateState: CalculateState = .initial
    // 入力された数値の保持や、計算結果の保持を行う変数（初期値は"0"）
    @State var calculatedNumber: Double = 0
    
    // 電卓のボタンに使用する文字を格納した配列
    private let calculateItems: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    // 入力した数字や、計算結果の数字を表示するためのテキスト
                    Text(selectedItem == "0" ? checkDecimal(number: calculatedNumber) : selectedItem)
                        .font(.system(size: 100, weight: .light))
                        .foregroundColor(Color.white)
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                
                VStack {
                    ForEach(calculateItems, id: \.self) { items in
                        NumberView(
                            items: items,
                            selectedItem: $selectedItem,
                            calculateState: $calculateState,
                            calculatedNumber: $calculatedNumber
                        )
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    /// 小数点の表示要否をチェックするためのメソッド
    ///
    /// - Parameters:
    ///     - number: 小数点を含んだ数値
    /// - Returns: チェック後の数値をString型（文字列）に変換したもの
    private func checkDecimal(number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne) {
            return String(Int(number))
        } else {
            return String(number)
        }
    }
}

struct NumberView: View {
    
    // NumberViewの第一引数（ボタンに使用する文字の配列）
    var items: [String]
    // NumberViewの第二引数（ボタン押下時の入力情報）
    @Binding var selectedItem: String
    // NumberViewの第三引数（計算記号ごとに処理を分けるためのEnum）
    @Binding var calculateState: CalculateState
    // NumberViewの第四引数（入力された数値の保持や、計算結果の保持を行う変数）
    @Binding var calculatedNumber: Double
    
    // 電卓のボタンに使用する"数字"と"."のみをまとめた配列
    private let numbers: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."]
    // 電卓のボタンに使用する"計算記号"のみをまとめた配列
    private let symbols: [String] = ["÷", "×", "-", "+", "="]
    
    // ボタンの縦横幅
    private let buttonWidth: CGFloat = (UIScreen.main.bounds.width - 50) / 4
    
    var body: some View {
        
        HStack {
            ForEach(items, id: \.self) { item in
                
                Button {
                    handleButtonProcess(item: item)
                } label: {
                    // 各ボタン内に表示するテキスト
                    Text(item)
                        .font(.system(size: 30, weight: .regular))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .foregroundColor(numbers.contains(item) || symbols.contains(item) ? Color.white : Color.black)
                .background(handleButtonColor(item: item))
                .frame(width: item == "0" ? buttonWidth * 2 + 10 : buttonWidth)
                .cornerRadius(buttonWidth)
            }
            .frame(height: buttonWidth)
        }
    }
    
    /// ボタンに設定する背景色を判断するメソッド
    ///
    /// - Parameters:
    ///     - item: "数字"や"計算記号"などの文字列
    /// - Returns: ボタンの背景色
    private func handleButtonColor(item: String) -> Color {
        if numbers.contains(item) {
            return Color(white: 0.2, opacity: 1)
        } else if symbols.contains(item) {
            return Color.orange
        } else {
            return Color(white: 0.8, opacity: 1)
        }
    }
    
    /// ボタン押下時の処理を判断するメソッド
    ///
    /// - Parameters:
    ///     - item: "数字"や"計算記号"などの文字列
    private func handleButtonProcess(item: String) {
        
        // String型の文字列をDouble型の数値に変換している
        guard let selectedNumber = Double(selectedItem) else { return }
        
        // 押下されたボタンに応じて、処理を分岐させる
        switch item {
        case "AC":
            selectedItem = "0"
            calculatedNumber = 0
            calculateState = .initial
            
        case "+/-", "%":
            break
        
        case "+":
            calculatePreparation(state: .addition, selectedNumber: selectedNumber)
            
        case "-":
            calculatePreparation(state: .substraction, selectedNumber: selectedNumber)
            
        case "×":
            calculatePreparation(state: .multiplication, selectedNumber: selectedNumber)
            
        case "÷":
            calculatePreparation(state: .division, selectedNumber: selectedNumber)
            
        case "=":
            selectedItem = "0"
            calculate(selectedNumber: selectedNumber)
            calculateState = .sum
            
        default:
            // "."の複数入力は受け付けない
            if item == "." && (selectedItem.contains(".") || selectedItem.contains("0")) {
                return
            }
            
            // 10桁より大きい数字の入力は受け付けない
            if selectedItem.count >= 10 {
                return
            }
            
            if selectedItem == "0" {
                selectedItem = item
                return
            }
            
            selectedItem += item
        }
    }
    
    /// 四則演算処理を行うためのメソッド
    ///
    /// - Parameters:
    ///     - selectedNumber: 入力した数値
    private func calculate(selectedNumber: Double) {
        
        // 初回入力時の数値を保持しておく
        if calculatedNumber == 0 {
            calculatedNumber = selectedNumber
            return
        }
        
        // Enumごとに計算処理を分ける
        switch calculateState {
        case .addition:
            calculatedNumber = calculatedNumber + selectedNumber
        case .substraction:
            calculatedNumber = calculatedNumber - selectedNumber
        case .multiplication:
            calculatedNumber = calculatedNumber * selectedNumber
        case .division:
            calculatedNumber = calculatedNumber / selectedNumber
        default:
            break
        }
    }
    
    /// 四則演算処理を行うために必要な情報を整理するためのメソッド
    ///
    /// - Parameters:
    ///     - state: どの処理を行うのかを判断するEnum
    ///     - selectedNumber: 入力した数値
    private func calculatePreparation(state: CalculateState, selectedNumber: Double) {
        if selectedItem == "0" {
            calculateState = state
            return
        }
        
        selectedItem = "0"
        calculateState = state
        
        // 四則演算処理を行うメソッドを呼び出す
        calculate(selectedNumber: selectedNumber)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
