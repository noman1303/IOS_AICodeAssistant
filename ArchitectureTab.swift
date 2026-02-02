import SwiftUI

struct ArchitectureTab: View {
    let hints: [ArchitectureHint]
    @State private var selectedPattern: ArchitectureHint.ArchitecturePattern?
    
    var filteredHints: [ArchitectureHint] {
        if let pattern = selectedPattern {
            return hints.filter { $0.pattern == pattern }
        }
        return hints
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Pattern Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterPill(
                        title: "All Patterns",
                        count: hints.count,
                        isSelected: selectedPattern == nil,
                        color: .indigo
                    ) {
                        selectedPattern = nil
                    }
                    
                    ForEach(ArchitectureHint.ArchitecturePattern.allCases, id: \.self) { pattern in
                        let count = hints.filter { $0.pattern == pattern }.count
                        if count > 0 {
                            FilterPill(
                                title: pattern.rawValue,
                                count: count,
                                isSelected: selectedPattern == pattern,
                                color: .indigo
                            ) {
                                selectedPattern = pattern
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            Divider()
            
            if filteredHints.isEmpty {
                EmptyResultsView(
                    icon: "building.columns.fill",
                    title: "No Architecture Hints",
                    subtitle: "Looking good!"
                )
            } else {
                List {
                    ForEach(filteredHints) { hint in
                        ArchitectureHintRow(hint: hint)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct ArchitectureHintRow: View {
    let hint: ArchitectureHint
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: hint.pattern.icon)
                    .font(.title3)
                    .foregroundColor(.indigo)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(hint.pattern.rawValue)
                        .font(.headline)
                    
                    Text(hint.recommendation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            
            Text(hint.rationale)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .italic()
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                    
                    // Implementation Steps
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Implementation Steps", systemImage: "list.number")
                            .font(.subheadline.bold())
                            .foregroundColor(.indigo)
                        
                        ForEach(Array(hint.implementationSteps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.indigo.opacity(0.2))
                                        .frame(width: 24, height: 24)
                                    
                                    Text("\(index + 1)")
                                        .font(.caption.bold())
                                        .foregroundColor(.indigo)
                                }
                                
                                Text(step)
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.leading, 28)
                    }
                    
                    // Resources
                    if !hint.resources.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Learn More", systemImage: "book.fill")
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                            
                            ForEach(hint.resources, id: \.self) { resource in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "link.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    
                                    Text(resource)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.leading, 28)
                        }
                    }
                    
                    // Pattern Benefits
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Why This Matters", systemImage: "star.fill")
                            .font(.subheadline.bold())
                            .foregroundColor(.orange)
                        
                        Text(getPatternBenefits(for: hint.pattern))
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
    
    private func getPatternBenefits(for pattern: ArchitectureHint.ArchitecturePattern) -> String {
        switch pattern {
        case .mvvm:
            return "MVVM provides clear separation between UI and business logic, making your code more testable and easier to maintain. Perfect for SwiftUI applications."
        case .viper:
            return "VIPER offers maximum separation of concerns with clear module boundaries. Best for large-scale applications with complex business logic."
        case .clean:
            return "Clean Architecture creates highly maintainable and testable code by separating business rules from implementation details and frameworks."
        case .coordinator:
            return "Coordinators remove navigation logic from view controllers, creating a clear navigation flow that's easy to test and modify."
        case .repository:
            return "Repository pattern abstracts data sources, making it easy to switch between local/remote data and simplifying testing with mock repositories."
        case .dependency:
            return "Dependency Injection makes your code more flexible and testable by removing hard-coded dependencies and enabling easy mocking."
        case .solid:
            return "SOLID principles lead to more maintainable, flexible code that's easier to extend without modifying existing functionality."
        case .composition:
            return "Composition provides more flexibility than inheritance and follows Swift's protocol-oriented design philosophy for better code reuse."
        }
    }
}
