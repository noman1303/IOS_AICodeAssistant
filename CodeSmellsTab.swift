import SwiftUI

struct CodeSmellsTab: View {
    let codeSmells: [CodeSmell]
    @State private var selectedSeverity: Severity?
    
    var filteredSmells: [CodeSmell] {
        if let severity = selectedSeverity {
            return codeSmells.filter { $0.severity == severity }
        }
        return codeSmells
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterPill(
                        title: "All",
                        count: codeSmells.count,
                        isSelected: selectedSeverity == nil
                    ) {
                        selectedSeverity = nil
                    }
                    
                    ForEach(Severity.allCases, id: \.self) { severity in
                        let count = codeSmells.filter { $0.severity == severity }.count
                        if count > 0 {
                            FilterPill(
                                title: severity.label,
                                count: count,
                                isSelected: selectedSeverity == severity,
                                color: Color(severity.color)
                            ) {
                                selectedSeverity = severity
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            Divider()
            
            if filteredSmells.isEmpty {
                EmptyResultsView(
                    icon: "checkmark.circle.fill",
                    title: "No Code Smells Found",
                    subtitle: "Your code looks clean!"
                )
            } else {
                List {
                    ForEach(filteredSmells) { smell in
                        CodeSmellRow(smell: smell)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct CodeSmellRow: View {
    let smell: CodeSmell
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: smell.type.icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(smell.type.rawValue)
                        .font(.headline)
                    
                    if let lineNumber = smell.lineNumber {
                        Text("Line \(lineNumber)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                SeverityBadge(severity: smell.severity)
                
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            
            Text(smell.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Label("Suggestion", systemImage: "lightbulb.fill")
                        .font(.subheadline.bold())
                        .foregroundColor(.orange)
                    
                    Text(smell.suggestion)
                        .font(.subheadline)
                        .padding(.leading, 28)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 8)
    }
}

struct FilterPill: View {
    let title: String
    let count: Int
    var isSelected: Bool = false
    var color: Color = .blue
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline.bold())
                
                Text("\(count)")
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(isSelected ? Color.white.opacity(0.3) : Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color : Color(.secondarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct SeverityBadge: View {
    let severity: Severity
    
    var body: some View {
        Text(severity.label)
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(severity.color).opacity(0.2))
            .foregroundColor(Color(severity.color))
            .cornerRadius(6)
    }
}

struct EmptyResultsView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text(title)
                .font(.title3.bold())
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
