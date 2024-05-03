//
//  ContentView.swift
//  ImageSlider
//
//  Created by Serdar Onur KARADAĞ on 2.05.2024.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var opacity: Double = 0.5
    @State private var currUpacity: Double = 1
    @State private var scaleEffect: Double = 0.9
    @State private var currScaleEffect: Double = 1
    
    var cardWidth: CGSize {
        let window = UIScreen.current?.bounds.size ?? CGSize(width: 300, height: 200)
        return window
    }
    
    @State private var items: [Item] = [
        Item(content: "First Chart", color: .red),
        Item(content: "Second Chart", color: .green),
        Item(content: "Third Chart", color: .blue)
    ]
    

    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(items.indices, id: \.self) { index in
                        let item: Item = items[index]
                        VStack(alignment: .leading) {
                            Text("\(item.content)")
                                .font(.system(size: 24, weight: .bold))
                                .opacity(currentIndex == index ? currUpacity : opacity)
                                .scaleEffect(currentIndex == index ? currScaleEffect : scaleEffect)
                                .offset(x: CGFloat(index-currentIndex) * cardWidth.width + dragOffset, y: 0)
                            TestView()
                                .padding()
                                .frame(width: cardWidth.width - 20, height: 200)
                                .background(.ultraThickMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .opacity(currentIndex == index ? currUpacity : opacity)
                                .scaleEffect(currentIndex == index ? currScaleEffect : scaleEffect)
                                .offset(x: CGFloat(index-currentIndex) * cardWidth.width + dragOffset, y: 0)
 
                        }
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if currentIndex == 0 && value.translation.width > 0 {
                                      return
                                    } else if currentIndex == items.count - 1 && value.translation.width < 0 {
                                      return
                                    }
                                    let dragPercentage = value.translation.width / 300
                                    let targetScaleEffect = min(abs(dragPercentage) + 0.9, 1.0)
                                    let targetCurrScaleEffect = max(0.9, 1.0 - abs(dragPercentage))
                                    
                                    let progress = abs(dragPercentage)

                                    scaleEffect = (1.0 - progress) * 0.9 + progress * targetScaleEffect
                                    opacity = abs(dragPercentage) + 0.5

                                    currUpacity = max(0.5, (1.0 - progress) + 0.1 * progress)
                                    currScaleEffect = (1.0 - progress) * 1.0 + progress * targetCurrScaleEffect

                                    dragOffset = value.translation.width
                                })
                                .onEnded({ value in
                                    let threshHold: CGFloat = 50
                                    if value.translation.width > threshHold {
                                        withAnimation {
                                            dragOffset = 0
                                            opacity = 0.5
                                            scaleEffect = 0.9
                                            currUpacity = 1
                                            currScaleEffect = 1
                                            currentIndex = max(0, currentIndex - 1)

                                        }
                                    } else if value.translation.width < -threshHold {
                                        withAnimation {
                                            dragOffset = 0
                                            opacity = 0.5
                                            scaleEffect = 0.9
                                            currUpacity = 1
                                            currScaleEffect = 1
                                            currentIndex = min(items.count - 1, currentIndex + 1)
       
                                        }
                                    } else {
                                        withAnimation {
                                            dragOffset = 0
                                            opacity = 0.5
                                            scaleEffect = 0.9
                                            currUpacity = 1
                                            currScaleEffect = 1
                                        }
                                    }
                                })
                        )
                        .frame(width: cardWidth.width - 16, height: 250)
                    }
                }
                HStack {
                    ForEach(0..<items.count, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? .red : .blue)
                            .scaleEffect(currentIndex == index ? currScaleEffect : scaleEffect)
                            .frame(width: 10)
                    }
                }
                ZStack {
                    ForEach(items.indices, id: \.self) { index in
                        let item: Item = items[index]
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(item.content)")
                                    .font(.system(size: 24, weight: .bold))
                                Spacer()
                            }
                        }
                        .opacity(currentIndex == index ? currUpacity : 0)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Analytics")
        }
    }
}

#Preview {
    ContentView()
}

class Item: Identifiable {
    var id = UUID().uuidString
    var content: String
    var color: Color
    
    init(id: String = UUID().uuidString, content: String, color: Color) {
        self.id = id
        self.content = content
        self.color = color
    }
}

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

struct TestView: View {
    @State var datas: [ToyShape] = [
        .init(type: "Cube", count: 78),
        .init(type: "Sphere", count: 24),
        .init(type: "Pyramid", count: 46)
    ]
    
    var body: some View {
        Chart {
            ForEach(datas) { data in
                LineMark(x: .value("Details", data.type) , y: .value("", data.count))
            }
        }
    }
}
