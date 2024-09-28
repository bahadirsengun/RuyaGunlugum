//
//  HomeVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI

struct HomeVC: View {
    @StateObject private var viewModel = DreamViewModel() // Initialize ViewModel
    
    var body: some View {
        VStack {
            // Scrollable Cards Section
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    if viewModel.favoriteDreams.isEmpty {
                        // Placeholder Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.7), Color.gray.opacity(0.5)]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            VStack {
                                Text("Favorilerinize eklediğiniz rüyalarınız bu alanda gözükecek :)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .frame(width: 200, height: 150)
                    } else {
                        ForEach(viewModel.favoriteDreams) { dream in
                            CardView(dream: dream)
                                .onTapGesture {
                                    viewModel.selectedDream = dream // Set selected dream
                                }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Buttons Section
            VStack(spacing: 20) {
                NavigationLink(destination: SymbolsVC()) {
                    Text("Semboller")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                
                NavigationLink(destination: DreamVC()) {
                    Text("Rüyalarım")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // AdMob Banner
            AdMobBanner()
                .frame(width: 320, height: 50)
        }
        .navigationBarItems(trailing:
            NavigationLink(destination: ProfileVC()) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
            }
        )
        .navigationTitle("Rüya Günlüğüm")
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(
                destination: DetailDreamVC(dream: viewModel.selectedDream, viewModel: viewModel),
                isActive: Binding(
                    get: { viewModel.selectedDream != nil },
                    set: { _ in viewModel.selectedDream = nil }
                ),
                label: { EmptyView() }
            )
        )
    }
}

#Preview {
    NavigationView {
        HomeVC() // Ensure HomeVC is the root view
    }
}

// Placeholder for the scrollable card view
struct CardView: View {
    let dream: Dream
    
    var body: some View {
        ZStack {
            // Background with gradient
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            VStack {
                // Symbol icon
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                // Dream title
                Text(dream.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
            .padding()
        }
        .frame(width: 200, height: 150)
    }
}





