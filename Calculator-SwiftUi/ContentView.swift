//
//  ContentView.swift
//  Calculator-SwiftUi
//
//  Created by Marco on 2025-06-06.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var env: GlobalState
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Spacer(minLength: 40)
                Text(env.display)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,
                           maxHeight: 100,
                           alignment: .bottomTrailing)
                    .padding()
                
                HStack {
                    makeButton(key: .clear, buttonColor: Color.init(white: 0.8))
                    makeButton(key: .plusMinus, buttonColor: Color.init(white: 0.8))
                    makeButton(key: .percent, buttonColor: Color.init(white: 0.8))
                    makeButton(key: .divide, buttonColor: Color.orange)
                }
                HStack{
                    makeButton(key: .seven)
                    makeButton(key: .eight)
                    makeButton(key: .nine)
                    makeButton(key: .multiply, buttonColor: Color.orange)
                }
                HStack{
                    makeButton(key: .four)
                    makeButton(key: .five)
                    makeButton(key: .six)
                    makeButton(key: .subtract, buttonColor: Color.orange)
                }
                HStack{
                    makeButton(key: .one)
                    makeButton(key: .two)
                    makeButton(key: .three)
                    makeButton(key: .add, buttonColor: Color.orange)
                }
                HStack {
                    makeButton(key: .zero, width: 168)
                    makeButton(key: .decimal)
                    makeButton(key: .equals, buttonColor: .orange)
                }
            }
            .padding()
        }
    }
    
    func makeButton(
        key: CalcKey,
        buttonColor: Color = Color.gray, 
        width: CGFloat = 80,
        height: CGFloat = 80) -> some View {
        Button {
            env.keyPressed(key)
        } label: {
            Text(key.rawValue)
                .font(.system(size: 40))
                .frame(width: width, height: height)
                .foregroundColor(.white)
                .background(buttonColor)
                .cornerRadius(width / 2)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalState())
}
