import SwiftUI

struct ContentView: View {
    
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
                    
                    Text("0")
                        .font(.system(size: 100, weight: .light))
                        .foregroundColor(Color.white)
                        .padding()
                }
                
                VStack {
                    ForEach(calculateItems, id: \.self) { items in
                        NumberView(items: items)
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
}

struct NumberView: View {
    
    // NumberViewの第一引数（ボタンに使用する文字の配列）
    var items: [String]
    
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
                    
                } label: {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
