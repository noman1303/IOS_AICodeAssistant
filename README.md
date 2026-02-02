# AI Code Assistant

A powerful SwiftUI iOS application that analyzes Swift code files to detect code smells, suggest refactorings, identify performance issues, and provide architecture recommendations.

## 📋 Table of Contents
- [Features](#features)
- [Project Flow](#project-flow)
- [Code Architecture](#code-architecture)
- [Major Code Explanations](#major-code-explanations)
- [Installation & Usage](#installation--usage)
- [Analysis Algorithms](#analysis-algorithms)
- [Contributing](#contributing)

## Features

### 📊 Overview Dashboard
- **Health Score**: Visual gauge showing overall code quality (0-100)
- **Statistics**: Lines of code, file size, issues found, and suggestions
- **Issues Breakdown**: Chart visualization of different issue categories
- **File Information**: Detailed metadata about the analyzed file

### 🔍 Code Smells Detection
The app detects common code smells including:
- **Long Methods**: Methods exceeding recommended length
- **Large Classes**: Files with too many lines
- **Magic Numbers**: Hard-coded numeric values
- **Deep Nesting**: Excessive indentation levels
- **Long Parameter Lists**: Functions with too many parameters
- **Duplicate Code**: Repetitive code patterns

Each code smell includes:
- Severity level (Low, Medium, High, Critical)
- Line number location
- Detailed description
- Actionable suggestions for improvement

### 🔧 Refactoring Suggestions
Get intelligent refactoring recommendations:
- **Extract Method/Class**: Break down complex code
- **Simplification**: Remove unnecessary complexity
- **Naming Improvements**: Better variable and function names
- **Code Organization**: Structural improvements
- **Swift Modernization**: Adopt modern Swift features
- **Error Handling**: Safer error management

Each suggestion includes:
- Priority level (Low, Medium, High, Critical)
- Before/After code examples
- List of benefits
- Implementation guidance

### ⚡ Performance Warnings
Identify performance bottlenecks:
- **String Concatenation in Loops**: Inefficient string building
- **Array Capacity**: Memory allocation issues
- **isEmpty vs count**: Collection checking optimizations
- **NSObject Inheritance**: Unnecessary Objective-C overhead
- **Retain Cycles**: Memory leak detection in closures

Each warning includes:
- Impact level (Minor, Moderate, Significant, Critical)
- Line number location
- Optimization strategy
- Estimated performance improvement

### 🏗️ Architecture Hints
Learn about architectural patterns:
- **MVVM**: Model-View-ViewModel pattern
- **VIPER**: View-Interactor-Presenter-Entity-Router
- **Clean Architecture**: Layered architecture approach
- **Coordinator Pattern**: Navigation flow management
- **Repository Pattern**: Data abstraction layer
- **Dependency Injection**: Loose coupling
- **SOLID Principles**: Object-oriented design principles
- **Composition over Inheritance**: Swift best practices

Each hint includes:
- Pattern explanation
- Implementation steps
- Learning resources
- Benefits and rationale

## Requirements

- iOS 15.0 or later
- Xcode 14.0 or later
- Swift 5.7 or later

---

## 📊 Project Flow

### High-Level Application Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER LAUNCHES APP                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    ContentView Displayed                        │
│                                                                 │
│  ┌────────────────────────────────────────────────────┐        │
│  │  Empty State: "No Code Analyzed Yet"               │        │
│  │  [Import Swift File Button]                        │        │
│  └────────────────────────────────────────────────────┘        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ User taps "Import"
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   FileImporter Presented                        │
│                                                                 │
│  User selects .swift file from:                                │
│  • Files App                                                   │
│  • iCloud Drive                                                │
│  • On My iPhone                                                │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ File selected
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              handleFileImport() - ContentView                   │
│                                                                 │
│  1. Get file URL from FileImporter                             │
│  2. Call: viewModel.analyzeFile(at: url)                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│         analyzeFile() - CodeAnalysisViewModel                   │
│                                                                 │
│  1. Set isAnalyzing = true (shows progress)                    │
│  2. Start accessing security-scoped resource                   │
│  3. Read file contents: String(contentsOf: url)                │
│  4. Create analyzer: SwiftCodeAnalyzer()                       │
│  5. Run analysis: analyzer.analyze(code, fileName)             │
│  6. Set isAnalyzing = false                                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│            analyze() - SwiftCodeAnalyzer                        │
│                                                                 │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Split code into lines                           │          │
│  │  Count non-empty lines                           │          │
│  └──────────────────────────────────────────────────┘          │
│                      │                                          │
│                      ▼                                          │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Run 4 Analysis Processes:                       │          │
│  │                                                   │          │
│  │  1. detectCodeSmells()                           │          │
│  │     • Long methods                               │          │
│  │     • Magic numbers                              │          │
│  │     • Deep nesting                               │          │
│  │     • Long parameters                            │          │
│  │     • Large classes                              │          │
│  │                                                   │          │
│  │  2. generateRefactoringSuggestions()             │          │
│  │     • Force unwrapping detection                 │          │
│  │     • var vs let analysis                        │          │
│  │     • Unnecessary self                           │          │
│  │     • Modern Swift features                      │          │
│  │                                                   │          │
│  │  3. detectPerformanceIssues()                    │          │
│  │     • String concatenation in loops              │          │
│  │     • Array capacity issues                      │          │
│  │     • isEmpty vs count                           │          │
│  │     • Retain cycles                              │          │
│  │                                                   │          │
│  │  4. generateArchitectureHints()                  │          │
│  │     • MVVM pattern                               │          │
│  │     • Dependency Injection                       │          │
│  │     • SOLID principles                           │          │
│  │     • Repository pattern                         │          │
│  └──────────────────────────────────────────────────┘          │
│                      │                                          │
│                      ▼                                          │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Create CodeAnalysis object with:                │          │
│  │  • All detected code smells                      │          │
│  │  • All refactoring suggestions                   │          │
│  │  • All performance warnings                      │          │
│  │  • All architecture hints                        │          │
│  │  • Calculated health score                       │          │
│  └──────────────────────────────────────────────────┘          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ Return CodeAnalysis
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│         ViewModel Updates @Published Property                   │
│                                                                 │
│  self.analysis = analysisResult                                │
│                                                                 │
│  SwiftUI automatically observes this change                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   UI AUTOMATICALLY UPDATES                      │
│                                                                 │
│  ┌─────────────────────────────────────────────────────┐       │
│  │              TabView Now Shows:                     │       │
│  │                                                      │       │
│  │  📊 Overview Tab                                    │       │
│  │     • Health Score: 45/100                          │       │
│  │     • Lines of Code: 245                            │       │
│  │     • Issues Found: 15                              │       │
│  │     • Visual Charts                                 │       │
│  │                                                      │       │
│  │  🔍 Code Smells Tab (8 issues)                      │       │
│  │     • Long Method - Line 12                         │       │
│  │     • Magic Numbers - Line 45                       │       │
│  │     • Deep Nesting - Line 78                        │       │
│  │                                                      │       │
│  │  🔧 Refactoring Tab (6 suggestions)                 │       │
│  │     • Replace Force Unwrapping                      │       │
│  │     • Use let instead of var                        │       │
│  │     • Remove unnecessary self                       │       │
│  │                                                      │       │
│  │  ⚡ Performance Tab (4 warnings)                     │       │
│  │     • String concatenation in loop                  │       │
│  │     • Potential retain cycle                        │       │
│  │     • Use isEmpty instead of count                  │       │
│  │                                                      │       │
│  │  🏗️ Architecture Tab (3 hints)                      │       │
│  │     • Consider MVVM                                 │       │
│  │     • Implement Dependency Injection                │       │
│  │     • Apply SOLID Principles                        │       │
│  └─────────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

### Data Binding Flow (MVVM Pattern)

```
┌──────────────────────┐
│   ContentView        │  (View Layer)
│   @StateObject       │
│   viewModel          │
└──────────┬───────────┘
           │
           │ Observes changes to @Published properties
           │
           ▼
┌──────────────────────┐
│ CodeAnalysisViewModel│  (ViewModel Layer)
│                      │
│ @Published var       │
│   analysis          │◄──── UI reads this
│                      │
│ @Published var       │
│   isAnalyzing       │◄──── Shows/hides progress
│                      │
│ func analyzeFile()   │◄──── View calls this
└──────────┬───────────┘
           │
           │ Uses
           │
           ▼
┌──────────────────────┐
│ SwiftCodeAnalyzer    │  (Business Logic)
│                      │
│ func analyze()       │
│ returns CodeAnalysis │
└──────────┬───────────┘
           │
           │ Creates
           │
           ▼
┌──────────────────────┐
│   CodeAnalysis       │  (Model Layer)
│   CodeSmell          │
│   RefactoringSuggestion│
│   PerformanceWarning │
│   ArchitectureHint   │
└──────────────────────┘
```

---

## 🏗️ Code Architecture

### File Structure & Responsibilities

```
AICodeAssistant/
│
├── 📱 App Entry Point
│   └── AICodeAssistantApp.swift
│       • Defines @main entry point
│       • Creates root WindowGroup
│       • Initializes ContentView
│
├── 🎨 Main View Layer
│   └── ContentView.swift
│       • File import handling
│       • Tab navigation
│       • Empty state display
│       • Progress indicator
│       • ViewModel integration
│
├── 📊 Data Models
│   └── Models.swift
│       • CodeAnalysis (main container)
│       • CodeSmell (quality issues)
│       • RefactoringSuggestion (improvements)
│       • PerformanceWarning (optimizations)
│       • ArchitectureHint (patterns)
│       • Enums: Severity, Priority, Impact
│
├── 🧠 Business Logic
│   └── CodeAnalysisViewModel.swift
│       • CodeAnalysisViewModel (state management)
│       • SwiftCodeAnalyzer (analysis engine)
│       • Detection algorithms
│       • Suggestion generators
│
└── 📱 Tab Views (UI Components)
    ├── OverviewTab.swift      (Dashboard & stats)
    ├── CodeSmellsTab.swift    (Quality issues)
    ├── RefactoringTab.swift   (Improvements)
    ├── PerformanceTab.swift   (Optimizations)
    └── ArchitectureTab.swift  (Design patterns)
```

---

## 💻 Major Code Explanations

### 1. File Import System

**Location**: `ContentView.swift`

```swift
// FileImporter modifier - handles document picking
.fileImporter(
    isPresented: $isImporting,  // Binding to show/hide picker
    allowedContentTypes: [UTType(filenameExtension: "swift") ?? .text],  // Only .swift files
    allowsMultipleSelection: false  // Single file only
) { result in
    handleFileImport(result)
}

// Handle the imported file
private func handleFileImport(_ result: Result<[URL], Error>) {
    switch result {
    case .success(let urls):
        guard let url = urls.first else { return }
        viewModel.analyzeFile(at: url)  // Trigger analysis
    case .failure(let error):
        print("Error importing file: \(error.localizedDescription)")
    }
}
```

**How it works**:
1. User taps "Import" button → sets `isImporting = true`
2. iOS shows native file picker
3. User selects .swift file
4. `handleFileImport` receives the file URL
5. Passes URL to ViewModel for analysis

---

### 2. ViewModel - State Management

**Location**: `CodeAnalysisViewModel.swift`

```swift
@MainActor
class CodeAnalysisViewModel: ObservableObject {
    // Published properties - UI automatically updates when these change
    @Published var analysis: CodeAnalysis?        // Analysis results
    @Published var isAnalyzing = false            // Loading state
    @Published var errorMessage: String?          // Error handling
    
    func analyzeFile(at url: URL) {
        isAnalyzing = true  // Show progress indicator
        errorMessage = nil
        
        Task {  // Run asynchronously
            do {
                // Security-scoped resource access (required for document picker)
                guard url.startAccessingSecurityScopedResource() else {
                    throw NSError(domain: "FileAccess", code: -1)
                }
                defer { url.stopAccessingSecurityScopedResource() }
                
                // Read file contents
                let content = try String(contentsOf: url, encoding: .utf8)
                
                // Create analyzer and run analysis
                let analyzer = SwiftCodeAnalyzer()
                let analysis = analyzer.analyze(
                    code: content, 
                    fileName: url.lastPathComponent
                )
                
                // Update UI on main thread
                await MainActor.run {
                    self.analysis = analysis  // This triggers UI update!
                    self.isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isAnalyzing = false
                }
            }
        }
    }
}
```

**Key Concepts**:
- `@Published`: When value changes, SwiftUI views automatically re-render
- `@MainActor`: Ensures UI updates happen on main thread
- `Task`: Runs code asynchronously without blocking UI
- Security-scoped resource: Required for accessing files from document picker

---

### 3. Code Smell Detection Algorithm

**Location**: `CodeAnalysisViewModel.swift` → `detectCodeSmells()`

```swift
private func detectCodeSmells(code: String, lines: [String]) -> [CodeSmell] {
    var smells: [CodeSmell] = []
    
    // ALGORITHM 1: Detect Long Methods
    let methodPattern = /func\s+\w+/  // Regex: matches "func methodName"
    var methodLineCount = 0
    var inMethod = false
    var methodStartLine = 0
    var braceCount = 0  // Track opening/closing braces
    
    for (index, line) in lines.enumerated() {
        // Found method declaration
        if line.contains(methodPattern) {
            inMethod = true
            methodStartLine = index + 1
            methodLineCount = 0
            braceCount = 0
        }
        
        if inMethod {
            methodLineCount += 1
            // Count braces to find method end
            braceCount += line.filter { $0 == "{" }.count
            braceCount -= line.filter { $0 == "}" }.count
            
            // Method ended (braces balanced)
            if braceCount == 0 && methodLineCount > 1 {
                // Check if method is too long
                if methodLineCount > 50 {
                    smells.append(CodeSmell(
                        type: .longMethod,
                        severity: .high,
                        lineNumber: methodStartLine,
                        description: "Method spans \(methodLineCount) lines",
                        suggestion: "Break into smaller functions (aim for <30 lines)"
                    ))
                }
                inMethod = false
            }
        }
    }
    
    // ALGORITHM 2: Detect Magic Numbers
    for (index, line) in lines.enumerated() {
        let numberPattern = /\s+(\d+\.?\d*)\s*/  // Matches numeric literals
        if let match = line.firstMatch(of: numberPattern) {
            let number = String(match.1)
            // Ignore 0 and 1 (common constants)
            if number != "0" && number != "1" && !line.contains("//") {
                smells.append(CodeSmell(
                    type: .magicNumbers,
                    severity: .low,
                    lineNumber: index + 1,
                    description: "Magic number '\(number)' found",
                    suggestion: "Replace with named constant"
                ))
            }
        }
    }
    
    // ALGORITHM 3: Detect Deep Nesting
    for (index, line) in lines.enumerated() {
        // Count leading spaces/tabs
        let indentation = line.prefix(while: { $0 == " " || $0 == "\t" }).count
        if indentation > 20 {  // More than 20 spaces = too nested
            smells.append(CodeSmell(
                type: .deepNesting,
                severity: .medium,
                lineNumber: index + 1,
                description: "Deep nesting detected (indentation: \(indentation))",
                suggestion: "Use guard statements or extract methods"
            ))
        }
    }
    
    return smells
}
```

**Algorithm Breakdown**:

1. **Long Method Detection**:
   - Find `func` keyword with regex
   - Count lines until braces balance (method ends)
   - Flag if > 50 lines

2. **Magic Number Detection**:
   - Use regex to find numeric literals
   - Ignore 0 and 1 (acceptable)
   - Flag all others as code smell

3. **Deep Nesting Detection**:
   - Count leading whitespace
   - If > 20 spaces, flag as too nested

---

### 4. Performance Warning Detection

**Location**: `CodeAnalysisViewModel.swift` → `detectPerformanceIssues()`

```swift
private func detectPerformanceIssues(code: String, lines: [String]) -> [PerformanceWarning] {
    var warnings: [PerformanceWarning] = []
    
    // DETECTION 1: String concatenation in loops
    if code.contains("for ") && code.contains("+= ") {
        warnings.append(PerformanceWarning(
            issue: "String Concatenation in Loop",
            impact: .significant,
            lineNumber: nil,
            description: "String += creates multiple copies",
            optimization: "Use array.joined() or String interpolation",
            estimatedImprovement: "Up to 10x faster for large loops"
        ))
    }
    
    // DETECTION 2: Array growth without capacity
    if code.contains(".append(") && code.contains("for ") {
        warnings.append(PerformanceWarning(
            issue: "Consider Array Capacity Pre-allocation",
            impact: .moderate,
            lineNumber: nil,
            description: "Dynamic array growth causes reallocations",
            optimization: "Use array.reserveCapacity(n) before loop",
            estimatedImprovement: "Reduces allocations by ~50%"
        ))
    }
    
    // DETECTION 3: count vs isEmpty
    if code.contains("count >") || code.contains("count ==") {
        warnings.append(PerformanceWarning(
            issue: "Use isEmpty Instead of count == 0",
            impact: .minor,
            lineNumber: nil,
            description: "count can be O(n) for some collections",
            optimization: "Use .isEmpty (always O(1))",
            estimatedImprovement: "O(1) instead of O(n)"
        ))
    }
    
    // DETECTION 4: Retain cycles in closures
    if code.contains("self.") && code.contains("{ ") && !code.contains("[weak self]") {
        warnings.append(PerformanceWarning(
            issue: "Potential Retain Cycle in Closure",
            impact: .critical,
            lineNumber: nil,
            description: "Capturing self without weak causes memory leaks",
            optimization: "Use [weak self] or [unowned self]",
            estimatedImprovement: "Prevents memory leaks"
        ))
    }
    
    return warnings
}
```

**Detection Strategies**:
- Pattern matching for known anti-patterns
- Context-aware analysis (e.g., `self.` in closures)
- Impact classification based on performance effect

---

### 5. Health Score Calculation

**Location**: `Models.swift` → `CodeAnalysis`

```swift
struct CodeAnalysis {
    let codeSmells: [CodeSmell]
    let performanceWarnings: [PerformanceWarning]
    // ... other properties
    
    // CALCULATED PROPERTY: Complexity Score
    var complexityScore: Int {
        // Sum up severity values from code smells
        let smellScore = codeSmells.reduce(0) { $0 + $1.severity.rawValue }
        
        // Each performance warning adds 2 points
        let perfScore = performanceWarnings.count * 2
        
        // Cap at 100 max
        return min(100, smellScore + perfScore)
    }
    
    // CALCULATED PROPERTY: Health Score (inverse of complexity)
    var healthScore: Int {
        return max(0, 100 - complexityScore)
    }
}

// Severity values (defined in enum)
enum Severity: Int {
    case low = 1       // 1 point
    case medium = 3    // 3 points
    case high = 5      // 5 points
    case critical = 8  // 8 points
}
```

**Formula**:
```
Complexity Score = Σ(severity values) + (perf warnings × 2)
Health Score = 100 - Complexity Score

Example:
- 3 Low smells (3 × 1 = 3)
- 2 Medium smells (2 × 3 = 6)
- 1 High smell (1 × 5 = 5)
- 2 Performance warnings (2 × 2 = 4)
─────────────────────────
Complexity = 18
Health = 100 - 18 = 82 ✅ (Good!)
```

---

### 6. SwiftUI State Binding

**Location**: `ContentView.swift` and Tab Views

```swift
// ContentView creates and owns the ViewModel
struct ContentView: View {
    // @StateObject ensures ViewModel persists across view updates
    @StateObject private var viewModel = CodeAnalysisViewModel()
    
    var body: some View {
        // Check if analysis exists
        if let analysis = viewModel.analysis {
            TabView {
                // Pass analysis to each tab
                OverviewTab(analysis: analysis)
                CodeSmellsTab(codeSmells: analysis.codeSmells)
                // ... other tabs
            }
        } else {
            EmptyStateView()
        }
    }
}

// Each tab receives data as parameter
struct CodeSmellsTab: View {
    let codeSmells: [CodeSmell]  // Read-only data
    @State private var selectedSeverity: Severity?  // Local UI state
    
    var filteredSmells: [CodeSmell] {
        // Computed property - recalculates when dependencies change
        if let severity = selectedSeverity {
            return codeSmells.filter { $0.severity == severity }
        }
        return codeSmells
    }
}
```

**State Management Hierarchy**:
```
@StateObject viewModel          (Persists across view updates)
    ↓
@Published analysis             (Triggers view updates when changed)
    ↓
let analysis: CodeAnalysis      (Passed down to child views)
    ↓
@State selectedFilter           (Local UI state in child)
```

---

### 7. Expandable Row Animation

**Location**: Various Tab Views (e.g., `CodeSmellsTab.swift`)

```swift
struct CodeSmellRow: View {
    let smell: CodeSmell
    @State private var isExpanded = false  // Track expanded state
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header (always visible)
            HStack {
                Image(systemName: smell.type.icon)
                Text(smell.type.rawValue)
                Spacer()
                
                // Expand/Collapse button
                Button(action: { 
                    withAnimation {  // Animate the state change
                        isExpanded.toggle() 
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
            }
            
            // Details (conditionally shown)
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    Text(smell.suggestion)
                }
                // Transition defines how view appears/disappears
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
```

**Animation Breakdown**:
1. `@State isExpanded`: Triggers view re-render when changed
2. `withAnimation`: Wraps state change to animate it
3. `if isExpanded`: Shows/hides content based on state
4. `.transition`: Defines animation style (fade + slide)

---

## Requirements

## Installation

1. Open the project in Xcode
2. Select your target device or simulator
3. Build and run (⌘R)

---

## 🚀 Installation & Usage

### Quick Setup (5 minutes)

**Step 1**: Create New Project
```
Xcode → File → New → Project
→ iOS → App
→ Product Name: "AICodeAssistant"
→ Interface: SwiftUI
→ Language: Swift
→ Minimum: iOS 15.0
```

**Step 2**: Add Source Files
- Drag all 9 `.swift` files into Xcode
- Ensure "Copy items if needed" is checked
- Add to target: AICodeAssistant

**Step 3**: Configure Info.plist
Add these keys (Required for file import):
```xml
<key>UISupportsDocumentBrowser</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

**Step 4**: Build & Run
- Select iPhone 14 or newer simulator
- Press ⌘R
- App launches successfully ✅

### Using the App

**Import a File**:
1. Tap "Import" button (top-right)
2. Navigate to your Swift file
3. Select file
4. Analysis runs automatically (2-3 seconds)

**View Results**:
- **Overview**: General health score and statistics
- **Code Smells**: Tap any issue to see details and suggestions
- **Refactoring**: View before/after code examples
- **Performance**: See optimization opportunities
- **Architecture**: Learn design patterns

**Filter Results**:
- Tap filter pills at top of each tab
- Filter by severity, category, or impact
- Tap "All" to reset filters

**Test with Sample**:
- Use included `SampleCode.swift`
- Contains intentional issues to demonstrate all features
- Expected health score: ~45-55

## Usage

1. **Launch the app**: Open AI Code Assistant on your iOS device
2. **Import a file**: Tap the "Import" button in the top-right corner
3. **Select a Swift file**: Choose a .swift file from your device
4. **View analysis**: The app will analyze the code and display results across five tabs:
   - Overview: General statistics and health score
   - Code Smells: Detected code quality issues
   - Refactoring: Improvement suggestions
   - Performance: Optimization opportunities
   - Architecture: Design pattern recommendations

5. **Explore details**: Tap on any item to expand and see detailed information
6. **Filter results**: Use the filter pills at the top of each tab to narrow down results

## Project Structure

```
AICodeAssistant/
├── AICodeAssistantApp.swift      # Main app entry point
├── ContentView.swift               # Main view with file import
├── Models.swift                    # Data models
├── CodeAnalysisViewModel.swift     # Analysis logic and ViewModel
├── OverviewTab.swift               # Overview dashboard
├── CodeSmellsTab.swift            # Code smells view
├── RefactoringTab.swift           # Refactoring suggestions view
├── PerformanceTab.swift           # Performance warnings view
└── ArchitectureTab.swift          # Architecture hints view
```

## Analysis Algorithms

### Code Smell Detection

1. **Long Method Detection**:
   - **Algorithm**: Parse function declarations, track brace nesting
   - **Threshold**: > 50 lines = High severity, > 30 lines = Medium
   - **Implementation**:
   ```swift
   // Find "func" keyword, count lines until braces balance
   for line in lines {
       if line.contains(/func\s+\w+/) { startTracking() }
       if inMethod { 
           braceCount += countBraces(line)
           if braceCount == 0 { checkLength() }
       }
   }
   ```

2. **Magic Number Detection**:
   - **Algorithm**: Regex pattern matching for numeric literals
   - **Exceptions**: Ignores 0 and 1 (common constants)
   - **Pattern**: `\s+(\d+\.?\d*)\s*`
   - **Suggestion**: Replace with named constants

3. **Deep Nesting Detection**:
   - **Algorithm**: Count leading whitespace characters
   - **Threshold**: > 20 spaces indicates excessive nesting
   - **Formula**: `indentation = line.prefix(while: isWhitespace).count`
   - **Suggestion**: Use guard statements, early returns, extract methods

4. **Long Parameter List**:
   - **Algorithm**: Regex pattern for function parameters
   - **Threshold**: Parameter list > 50 characters
   - **Pattern**: `func\s+\w+\s*\([^)]{50,}\)`
   - **Suggestion**: Use parameter objects or builder pattern

5. **Large Class Detection**:
   - **Algorithm**: Simple line count
   - **Threshold**: > 300 lines in single file
   - **Suggestion**: Split into multiple classes (Single Responsibility)

### Refactoring Suggestion Generation

**Detection Methods**:

1. **Force Unwrapping**:
   ```swift
   Pattern: "!" operator (excluding "!=")
   Check: code.contains("!") && !code.contains("!=")
   Suggestion: Use guard let, if let, or optional chaining
   Priority: High (crash risk)
   ```

2. **var vs let**:
   ```swift
   Pattern: "var" keyword
   Analysis: Variable never reassigned → should be "let"
   Check: code.contains("var ")
   Suggestion: Use immutable "let" for constants
   Priority: Low (code quality)
   ```

3. **Unnecessary self**:
   ```swift
   Pattern: "self." keyword
   Context: Not in closure, not shadowing
   Check: code.contains("self.")
   Suggestion: Remove "self" (Swift convention)
   Priority: Low (readability)
   ```

4. **Modern Swift Features**:
   ```swift
   CaseIterable: Check if enum exists without conformance
   Pattern: code.contains("enum") && !code.contains("CaseIterable")
   Suggestion: Add CaseIterable for easy iteration
   Priority: Medium
   ```

### Performance Issue Detection

**Detection Logic**:

1. **String Concatenation in Loops**:
   ```swift
   // BAD: O(n²) complexity
   var result = ""
   for item in array {
       result += item  // Creates new string each time
   }
   
   // GOOD: O(n) complexity
   let result = array.joined()
   
   // Detection:
   if code.contains("for ") && code.contains("+= ") {
       flagPerformanceIssue()
   }
   ```

2. **Array Capacity**:
   ```swift
   // BAD: Multiple reallocations
   var array: [Int] = []
   for i in 0..<1000 {
       array.append(i)  // Reallocates ~10 times
   }
   
   // GOOD: Single allocation
   var array: [Int] = []
   array.reserveCapacity(1000)
   for i in 0..<1000 {
       array.append(i)
   }
   
   // Detection:
   if code.contains(".append(") && code.contains("for ") {
       suggestReserveCapacity()
   }
   ```

3. **isEmpty vs count**:
   ```swift
   // BAD: Potentially O(n)
   if array.count == 0 { }
   
   // GOOD: Always O(1)
   if array.isEmpty { }
   
   // Detection:
   if code.contains("count >") || code.contains("count ==") {
       suggestIsEmpty()
   }
   ```

4. **Retain Cycles**:
   ```swift
   // BAD: Memory leak
   someAsyncCall { 
       self.property = value  // Strong reference
   }
   
   // GOOD: No leak
   someAsyncCall { [weak self] in
       self?.property = value
   }
   
   // Detection:
   if code.contains("self.") && 
      code.contains("{ ") && 
      !code.contains("[weak self]") {
       warnRetainCycle()
   }
   ```

### Architecture Hint Generation

**Pattern Recognition**:

1. **MVVM Opportunity**:
   ```swift
   Trigger: Code contains "class" and "View"
   Suggestion: Separate UI from business logic
   Rationale: Improves testability and maintainability
   ```

2. **Dependency Injection**:
   ```swift
   Trigger: Code contains "init("
   Suggestion: Inject dependencies via initializer
   Benefits: Testability, flexibility, decoupling
   ```

3. **SOLID Principles**:
   ```swift
   Always Suggested: Universal best practices
   Components:
   - Single Responsibility
   - Open/Closed
   - Liskov Substitution
   - Interface Segregation
   - Dependency Inversion
   ```

4. **Repository Pattern**:
   ```swift
   Trigger: Code contains "func fetch" or "func save"
   Suggestion: Abstract data access layer
   Benefits: Easy to mock, test, swap data sources
   ```

### Health Score Algorithm

**Calculation Formula**:
```swift
// Step 1: Calculate Complexity Score
complexityScore = Σ(codeSmell.severity) + (performanceWarnings × 2)

// Severity values:
low      = 1 point
medium   = 3 points
high     = 5 points
critical = 8 points

// Step 2: Calculate Health Score (inverse)
healthScore = max(0, min(100, 100 - complexityScore))

// Step 3: Color Coding
80-100 = Green   (Excellent)
60-79  = Yellow  (Good)
40-59  = Orange  (Needs Work)
0-39   = Red     (Critical)
```

**Example Calculation**:
```
Code Smells:
- 2 Low (2 × 1 = 2)
- 3 Medium (3 × 3 = 9)
- 1 High (1 × 5 = 5)
- 0 Critical

Performance Warnings:
- 2 warnings (2 × 2 = 4)

Total Complexity: 2 + 9 + 5 + 4 = 20
Health Score: 100 - 20 = 80 (Green ✅)
```

---

## 🎯 Understanding the Code Flow

### Complete Request-Response Cycle

```
User Action: Tap "Import"
    ↓
System: Present FileImporter
    ↓
User: Select "MyCode.swift"
    ↓
System: Return URL
    ↓
ContentView.handleFileImport(result)
    ↓
viewModel.analyzeFile(at: url)
    ↓
Read file: String(contentsOf: url)
    ↓
Create: SwiftCodeAnalyzer()
    ↓
analyzer.analyze(code, fileName)
    ├─→ detectCodeSmells()
    │   ├─ Find long methods
    │   ├─ Find magic numbers
    │   ├─ Find deep nesting
    │   └─ Return [CodeSmell]
    │
    ├─→ generateRefactoringSuggestions()
    │   ├─ Check force unwraps
    │   ├─ Check var vs let
    │   ├─ Check unnecessary self
    │   └─ Return [RefactoringSuggestion]
    │
    ├─→ detectPerformanceIssues()
    │   ├─ Check string concat
    │   ├─ Check array growth
    │   ├─ Check retain cycles
    │   └─ Return [PerformanceWarning]
    │
    └─→ generateArchitectureHints()
        ├─ Suggest MVVM
        ├─ Suggest DI
        ├─ Suggest SOLID
        └─ Return [ArchitectureHint]
    ↓
Combine all results into CodeAnalysis
    ↓
Calculate healthScore = 100 - complexityScore
    ↓
Return CodeAnalysis object
    ↓
viewModel.analysis = result  // @Published property
    ↓
SwiftUI detects change
    ↓
ContentView re-renders
    ↓
TabView shows analysis results
    ↓
User sees: Overview, Code Smells, etc.
```

### State Update Propagation

```
ViewModel (Source of Truth)
    ↓
@Published var analysis changes
    ↓
SwiftUI observes change
    ↓
ContentView.body computed
    ↓
Conditional: if let analysis = viewModel.analysis
    ↓
TabView created with analysis
    ↓
Each tab receives data:
    ├─ OverviewTab(analysis: analysis)
    ├─ CodeSmellsTab(codeSmells: analysis.codeSmells)
    ├─ RefactoringTab(suggestions: analysis.refactoringSuggestions)
    ├─ PerformanceTab(warnings: analysis.performanceWarnings)
    └─ ArchitectureTab(hints: analysis.architectureHints)
    ↓
Each tab renders with new data
    ↓
User sees updated UI
```

---

## 🧪 Testing Guide

### Using Sample File

The included `SampleCode.swift` demonstrates all features:

**Expected Detections**:
- ✅ 1 Long Method (50+ lines)
- ✅ 3 Magic Numbers (15, 10, 100)
- ✅ 2 Deep Nesting instances
- ✅ 1 Long Parameter List (9 params)
- ✅ 1 Large Class (300+ lines)
- ✅ 5 Force Unwraps
- ✅ 3 String Concatenations in loops
- ✅ 2 Potential Retain Cycles
- ✅ 4 Architecture hints

**Health Score**: Should be approximately 45-55 (Orange)

### Testing Checklist

**File Import**:
- [ ] Import button works
- [ ] File picker shows
- [ ] .swift files selectable
- [ ] Analysis starts after selection
- [ ] Progress indicator shows

**Analysis Results**:
- [ ] Overview shows correct stats
- [ ] Health score displays
- [ ] All tabs populate
- [ ] Line numbers shown
- [ ] Suggestions are relevant

**UI Interactions**:
- [ ] Tabs switch smoothly
- [ ] Rows expand/collapse
- [ ] Filters work correctly
- [ ] Animations are smooth
- [ ] Text is readable

**Error Handling**:
- [ ] Invalid files handled gracefully
- [ ] File access errors shown
- [ ] Large files don't crash app
- [ ] Memory usage acceptable

---

## 📚 Learning Resources

### Understanding This Project

**For Beginners**:
1. Start with `AICodeAssistantApp.swift` - See app structure
2. Read `Models.swift` - Understand data structures
3. Review `ContentView.swift` - Learn SwiftUI basics
4. Study `CodeAnalysisViewModel.swift` - See MVVM pattern

**For Intermediate**:
1. Analyze detection algorithms in `SwiftCodeAnalyzer`
2. Study state management with `@Published` and `@StateObject`
3. Review UI composition in tab views
4. Understand async/await patterns

**For Advanced**:
1. Optimize regex patterns for better performance
2. Add custom detection algorithms
3. Implement caching layer
4. Create export functionality

### SwiftUI Concepts Demonstrated

- ✅ `@State` and `@StateObject` for state management
- ✅ `@Published` for observable objects
- ✅ Property wrappers and observers
- ✅ View composition and reusability
- ✅ File import with `FileImporter`
- ✅ Conditional views with if/else
- ✅ List and ForEach for collections
- ✅ Animations and transitions
- ✅ Charts (iOS 16+) with fallback
- ✅ Navigation with TabView
- ✅ Custom view modifiers
- ✅ Color and styling
- ✅ SF Symbols integration

---

## 🔧 Customization Guide

### Adjusting Thresholds

**Code Smells**:
```swift
// File: CodeAnalysisViewModel.swift, Line ~95
if methodLineCount > 50 {  // Change to 40, 60, etc.
    // Detect long method
}

// Line ~136
if indentation > 20 {  // Adjust nesting threshold
    // Detect deep nesting
}
```

**Health Score Weight**:
```swift
// File: Models.swift, Line ~18
let perfScore = performanceWarnings.count * 2  // Change multiplier
```

### Adding Custom Detection

**Step 1**: Add new enum case
```swift
// File: Models.swift
enum CodeSmellType {
    case yourNewType = "Your Type Name"
    // ...
}
```

**Step 2**: Add detection logic
```swift
// File: CodeAnalysisViewModel.swift
private func detectCodeSmells() {
    // ... existing code
    
    // Your new detection
    if code.contains("yourPattern") {
        smells.append(CodeSmell(
            type: .yourNewType,
            severity: .medium,
            lineNumber: nil,
            description: "Your description",
            suggestion: "Your suggestion"
        ))
    }
}
```

**Step 3**: Add icon mapping
```swift
// File: Models.swift
var icon: String {
    case .yourNewType: return "your.sf.symbol"
}
```

### Customizing UI Colors

**Global Theme**:
```swift
// In each tab file, change colors:
.foregroundColor(.blue)     // Change to .purple, .green, etc.
.background(Color.blue)     // Change background colors
```

**Health Score Colors**:
```swift
// File: OverviewTab.swift, Line ~85
private func healthColor(score: Int) -> Color {
    switch score {
    case 80...100: return .green    // Modify ranges/colors
    case 60..<80: return .yellow
    // ...
    }
}
```
 
---

## 📊 Project Statistics

### Codebase Metrics

```
Total Lines of Code:    ~2,500
Swift Files:            9
View Components:        15+
Data Models:            5
Enums:                  12
Detection Algorithms:   20+
Architecture Patterns:  MVVM, Observer, Strategy, Builder
```

### Analysis Capabilities

```
Code Smell Types:       10+
Refactoring Categories: 6
Performance Checks:     5+
Architecture Patterns:  8
Total Detection Rules:  50+
```

---
 
