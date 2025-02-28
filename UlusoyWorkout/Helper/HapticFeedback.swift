//
//  HapticFeedback.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 27.02.2025.
//

import Foundation
import UIKit

class HapticFeedback {
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // Convenience functions for common haptic feedbacks
    static func lightImpact() {
        impact(style: .light)
    }
    
    static func mediumImpact() {
        impact(style: .medium)
    }
    
    static func heavyImpact() {
        impact(style: .heavy)
    }
    
    static func softImpact() {
        if #available(iOS 13.0, *) {
            impact(style: .soft)
        }
    }
    
    static func rigidImpact() {
        if #available(iOS 13.0, *) {
            impact(style: .rigid)
        }
    }
    
    static func successNotification() {
        notification(type: .success)
    }
    
    static func warningNotification() {
        notification(type: .warning)
    }
    
    static func errorNotification() {
        notification(type: .error)
    }
}
