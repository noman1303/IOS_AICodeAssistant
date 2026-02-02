import SwiftUI

struct RefactoringTab: View {
    let suggestions: [RefactoringSuggestion]
    @State private var selectedCategory: RefactoringSuggestion.RefactoringCategory?
    @State private var selectedPriority: RefactoringSuggestion.Priority?
    
    var filteredSuggestions: [RefactoringSuggestion] {
        var result = suggestions
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if let priority = selectedPriority {
            result = result.filter { $0.priority == priority }
        }
        
        return result.sorted { $0.priority.rawValue > $1.priority.rawValue }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Category Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterPill(
                        title: "All",
                        count: suggestions.count,
                        isSelected: selectedCategory == nil && selectedPriority == nil
                    ) {
                        selectedCategory = nil
                        selectedPriority = nil
                    }
                    
                    ForEach(RefactoringSuggestion.RefactoringCategory.allCases, id: \.self) { category in
                        let count = suggestions.filter { $0.category == category }.count
                        if count > 0 {
                            FilterPill(
                                title: category.rawValue,
                                count: count,
                                isSelected: selectedCategory == category,
                                color: .purple
                            ) {
                                selectedCategory = category
                                selectedPriority = nil
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            Divider()
            
            if filteredSuggestions.isEmpty {
                EmptyResultsView(
                    icon: "checkmark.circle.fill",
                    title: "No Refactoring Needed",
                    subtitle: "Your code structure looks good!"
                )
            } else {
                List {
                    ForEach(filteredSuggestions) { suggestion in
                        RefactoringSuggestionRow(suggestion: suggestion)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct RefactoringSuggestionRow: View {
    let suggestion: RefactoringSuggestion
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: suggestion.category.icon)
                    .font(.title3)
                    .foregroundColor(.purple)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(suggestion.title)
                        .font(.headline)
                    
                    Text(suggestion.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                PriorityBadge(priority: suggestion.priority)
                
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            
            Text(suggestion.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                    
                    // Benefits
                    if !suggestion.benefits.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Benefits", systemImage: "star.fill")
                                .font(.subheadline.bold())
                                .foregroundColor(.orange)
                            
                            ForEach(suggestion.benefits, id: \.self) { benefit in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                    Text(benefit)
                                        .font(.caption)
                                }
                            }
                            .padding(.leading, 28)
                        }
                    }
                    
                    // Code Examples
                    if let beforeCode = suggestion.beforeCode {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Before", systemImage: "xmark.circle")
                                .font(.subheadline.bold())
                                .foregroundColor(.red)
                            
                            CodeBlock(code: beforeCode)
                        }
                    }
                    
                    if let afterCode = suggestion.afterCode {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("After", systemImage: "checkmark.circle")
                                .font(.subheadline.bold())
                                .foregroundColor(.green)
                            
                            CodeBlock(code: afterCode)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 8)
    }
}

struct PriorityBadge: View {
    let priority: RefactoringSuggestion.Priority
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<priority.rawValue, id: \.self) { _ in
                Image(systemName: "exclamationmark")
                    .font(.caption2)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(priority.color).opacity(0.2))
        .foregroundColor(Color(priority.color))
        .cornerRadius(6)
    }
}

struct CodeBlock: View {
    let code: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .padding(12)
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
