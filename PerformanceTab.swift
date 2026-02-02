import SwiftUI

struct PerformanceTab: View {
    let warnings: [PerformanceWarning]
    @State private var selectedImpact: PerformanceWarning.Impact?
    
    var filteredWarnings: [PerformanceWarning] {
        if let impact = selectedImpact {
            return warnings.filter { $0.impact == impact }
        }
        return warnings.sorted { $0.impact.rawValue > $1.impact.rawValue }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Impact Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterPill(
                        title: "All",
                        count: warnings.count,
                        isSelected: selectedImpact == nil
                    ) {
                        selectedImpact = nil
                    }
                    
                    ForEach(PerformanceWarning.Impact.allCases, id: \.self) { impact in
                        let count = warnings.filter { $0.impact == impact }.count
                        if count > 0 {
                            FilterPill(
                                title: impact.rawValue,
                                count: count,
                                isSelected: selectedImpact == impact,
                                color: Color(impact.color)
                            ) {
                                selectedImpact = impact
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            Divider()
            
            if filteredWarnings.isEmpty {
                EmptyResultsView(
                    icon: "gauge.badge.checkmark",
                    title: "No Performance Issues",
                    subtitle: "Your code is optimized!"
                )
            } else {
                List {
                    ForEach(filteredWarnings) { warning in
                        PerformanceWarningRow(warning: warning)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct PerformanceWarningRow: View {
    let warning: PerformanceWarning
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: warning.impact.icon)
                    .font(.title3)
                    .foregroundColor(Color(warning.impact.color))
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(warning.issue)
                        .font(.headline)
                    
                    if let lineNumber = warning.lineNumber {
                        Text("Line \(lineNumber)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                ImpactBadge(impact: warning.impact)
                
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            
            Text(warning.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                    
                    // Optimization
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Optimization", systemImage: "bolt.fill")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                        
                        Text(warning.optimization)
                            .font(.subheadline)
                            .padding(.leading, 28)
                    }
                    
                    // Estimated Improvement
                    if let improvement = warning.estimatedImprovement {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Expected Impact", systemImage: "chart.line.uptrend.xyaxis")
                                .font(.subheadline.bold())
                                .foregroundColor(.green)
                            
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                    .foregroundColor(.green)
                                Text(improvement)
                                    .font(.subheadline)
                            }
                            .padding(.leading, 28)
                        }
                    }
                    
                    // Tips Section
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Pro Tip", systemImage: "lightbulb.fill")
                            .font(.subheadline.bold())
                            .foregroundColor(.orange)
                        
                        Text(getPerformanceTip(for: warning))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 28)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 8)
    }
    
    private func getPerformanceTip(for warning: PerformanceWarning) -> String {
        if warning.issue.contains("String") {
            return "Use String's built-in methods like joined() or string interpolation for better performance."
        } else if warning.issue.contains("Array") {
            return "Pre-allocating array capacity can significantly reduce memory allocations in tight loops."
        } else if warning.issue.contains("isEmpty") {
            return "The isEmpty property is O(1) for all Swift collections, while count can be O(n) for some types."
        } else if warning.issue.contains("Retain") {
            return "Always use [weak self] in closures that capture self to avoid memory leaks and retain cycles."
        } else {
            return "Profile your code with Instruments to measure the actual performance impact before optimizing."
        }
    }
}

struct ImpactBadge: View {
    let impact: PerformanceWarning.Impact
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color(impact.color))
                .frame(width: 8, height: 8)
            
            Text(impact.rawValue)
                .font(.caption.bold())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(impact.color).opacity(0.2))
        .foregroundColor(Color(impact.color))
        .cornerRadius(6)
    }
}
