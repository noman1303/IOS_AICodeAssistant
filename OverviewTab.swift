import SwiftUI
import Charts

struct OverviewTab: View {
    let analysis: CodeAnalysis
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Stats
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Health Score",
                            value: "\(analysis.healthScore)",
                            icon: "heart.fill",
                            color: healthColor(score: analysis.healthScore)
                        )
                        
                        StatCard(
                            title: "Lines of Code",
                            value: "\(analysis.linesOfCode)",
                            icon: "doc.text",
                            color: .blue
                        )
                    }
                    
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Issues Found",
                            value: "\(totalIssues)",
                            icon: "exclamationmark.triangle",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Suggestions",
                            value: "\(analysis.refactoringSuggestions.count)",
                            icon: "lightbulb.fill",
                            color: .yellow
                        )
                    }
                }
                .padding(.horizontal)
                
                // Health Score Gauge
                VStack(alignment: .leading, spacing: 12) {
                    Text("Code Health")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(analysis.healthScore) / 100)
                            .stroke(
                                healthColor(score: analysis.healthScore),
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1), value: analysis.healthScore)
                        
                        VStack {
                            Text("\(analysis.healthScore)")
                                .font(.system(size: 48, weight: .bold))
                            Text("Health Score")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(height: 200)
                    .padding()
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Issues Breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text("Issues Breakdown")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if #available(iOS 16.0, *) {
                        Chart {
                            ForEach(issueCategories, id: \.name) { category in
                                BarMark(
                                    x: .value("Count", category.count),
                                    y: .value("Category", category.name)
                                )
                                .foregroundStyle(by: .value("Category", category.name))
                            }
                        }
                        .frame(height: 200)
                        .padding()
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(issueCategories, id: \.name) { category in
                                HStack {
                                    Text(category.name)
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(category.count)")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.blue)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                    }
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // File Info
                VStack(alignment: .leading, spacing: 12) {
                    Text("File Information")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        InfoRow(label: "File Name", value: analysis.fileName)
                        InfoRow(label: "File Size", value: formatBytes(analysis.fileSize))
                        InfoRow(label: "Lines of Code", value: "\(analysis.linesOfCode)")
                        InfoRow(label: "Analyzed", value: formatDate(analysis.analyzedAt))
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
    }
    
    private var totalIssues: Int {
        analysis.codeSmells.count + analysis.performanceWarnings.count
    }
    
    private var issueCategories: [(name: String, count: Int)] {
        [
            ("Code Smells", analysis.codeSmells.count),
            ("Performance", analysis.performanceWarnings.count),
            ("Refactoring", analysis.refactoringSuggestions.count),
            ("Architecture", analysis.architectureHints.count)
        ]
    }
    
    private func healthColor(score: Int) -> Color {
        switch score {
        case 80...100: return .green
        case 60..<80: return .yellow
        case 40..<60: return .orange
        default: return .red
        }
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}
