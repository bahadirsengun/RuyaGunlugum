//
//  AdManager.swift
//  mydreams
//
//  Created by Bahadır Sengun on 30.08.2024.
//

import GoogleMobileAds
import SwiftUI

class AdManager: NSObject, ObservableObject, GADFullScreenContentDelegate {
    @Published var isAdReady = false
    var interstitial: GADInterstitialAd?
    var onAdDismissed: (() -> Void)?

    func loadInterstitial() {
        let request = GADRequest()   // gerçek id   ca-app-pub-6772888339663305/3695613792
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: request) { ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.isAdReady = true
        }
    }

    func showInterstitial(from viewController: UIViewController) {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: viewController)
        } else {
            print("Interstitial ad is not ready.")
            onAdDismissed?() // Call the dismiss callback if ad is not ready
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        onAdDismissed?() // Call the dismiss callback when ad is dismissed
    }
}




