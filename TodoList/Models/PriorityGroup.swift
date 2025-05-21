import Foundation
import SwiftUI

enum PriorityGroup: String, CaseIterable {
    case today = "today"
    case thisWeek = "thisWeek"
    case whenPossible = "whenPossible"
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .thisWeek:
            return "This Week"
        case .whenPossible:
            return "When There Is Time"
        }
    }
    
    var color: Color {
        switch self {
        case .today:
            return .red
        case .thisWeek:
            return .blue
        case .whenPossible:
            return .green
        }
    }
    
    var lightColor: Color {
        switch self {
        case .today:
            return .red.opacity(0.1)
        case .thisWeek:
            return .blue.opacity(0.1)
        case .whenPossible:
            return .green.opacity(0.1)
        }
    }
} 