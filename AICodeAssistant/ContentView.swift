//
//  ContentView.swift
//  AICodeAssistant
//
//  Created by Noman belim on 02/02/26.
//
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = CodeAnalysisViewModel()
    @State private var isImporting = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 32))
                            .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        VStack(alignment: .leading) {
                            Text("AI Code Assistant")
                                .font(.title2.bold())
                            Text("Swift Analysis & Refactoring")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { isImporting = true }) {
                            Label("Import", systemImage: "doc.badge.plus")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    
                    if viewModel.isAnalyzing {
                        ProgressView("Analyzing code...")
                            .padding(.bottom)
                    }
                }
                .background(Color(.systemBackground))
                
                Divider()
                
                // Main Content
                if let analysis = viewModel.analysis {
                    TabView(selection: $selectedTab) {
                        OverviewTab(analysis: analysis)
                            .tabItem {
                                Label("Overview", systemImage: "chart.pie.fill")
                            }
                            .tag(0)
                        
                        CodeSmellsTab(codeSmells: analysis.codeSmells)
                            .tabItem {
                                Label("Code Smells", systemImage: "exclamationmark.triangle.fill")
                            }
                            .tag(1)
                        
                        RefactoringTab(suggestions: analysis.refactoringSuggestions)
                            .tabItem {
                                Label("Refactoring", systemImage: "arrow.triangle.2.circlepath")
                            }
                            .tag(2)
                        
                        PerformanceTab(warnings: analysis.performanceWarnings)
                            .tabItem {
                                Label("Performance", systemImage: "speedometer")
                            }
                            .tag(3)
                        
                        ArchitectureTab(hints: analysis.architectureHints)
                            .tabItem {
                                Label("Architecture", systemImage: "building.columns.fill")
                            }
                            .tag(4)
                    }
                } else {
                    EmptyStateView(onImport: { isImporting = true })
                }
            }
            .navigationBarHidden(true)
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType(filenameExtension: "swift") ?? .text],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
        }
    }
    
    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            viewModel.analyzeFile(at: url)
        case .failure(let error):
            print("Error importing file: \(error.localizedDescription)")
        }
    }
}

struct EmptyStateView: View {
    let onImport: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 80))
                .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
            
            VStack(spacing: 8) {
                Text("No Code Analyzed Yet")
                    .font(.title2.bold())
                
                Text("Import a Swift file to get started with AI-powered analysis")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: onImport) {
                Label("Import Swift File", systemImage: "doc.badge.plus")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
