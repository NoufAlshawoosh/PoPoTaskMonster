//
//  FinishedTodayView.swift
//  PoPoTaskMonsterApp
//
//  Created by Fahdah Alsamari on 13/06/1447 AH.
//
import SwiftUI

struct FinishedTodayView: View {

    @Environment(\.dismiss) var dismiss
    @State private var animate = false

    var body: some View {
        ZStack {

            // ✅ Background
            Color(red: 242/255, green: 248/255, blue: 233/255)
                .ignoresSafeArea()

            // ✅ Stars Behind Monster (Your Asset)
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    Image("stars")   // ✅ Your asset name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .opacity(animate ? 0 : 1)
                        .offset(
                            x: CGFloat.random(in: -140...140),
                            y: animate ? -500 : 450
                        )
                        .animation(
                            .easeOut(duration: Double.random(in: 1.8...3))
                                .repeatForever(autoreverses: false)
                                .delay(Double.random(in: 0...1)),
                            value: animate
                        )
                }
            }

            // ✅ Main Content
            VStack(spacing: 30) {   // ✅ spacing added here

                Text("You completed today's tasks")
                    .font(.custom("krungthep", size: 26))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.text)

                Spacer().frame(height: 10)    // ✅ extra spacing before monster

                Image("happyMonster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230)
                    .scaleEffect(animate ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 1.2).repeatForever(), value: animate)

                Spacer().frame(height: 10)    // ✅ spacing after monster

                Text("You defeated today's monster! ")
                    .font(.custom("krungthep", size: 20))
                    .foregroundColor(.text)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 15)

                Button {
                    dismiss()
                } label: {
                    Text("Return to Home")
                        .font(.custom("krungthep", size: 24))
                        .foregroundColor(.white)
                        .frame(maxWidth: 319, maxHeight: 64)
                        .background(.button)
                        .cornerRadius(30)
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    FinishedTodayView()
}
