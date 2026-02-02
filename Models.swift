import Foundation

// MARK: - Analysis Models

struct CodeAnalysis: Identifiable {
    let id = UUID()
    let fileName: String
    let fileSize: Int
    let linesOfCode: Int
    let analyzedAt: Date
    let codeSmells: [CodeSmell]
    let refactoringSuggestions: [RefactoringSuggestion]
    let performanceWarnings: [PerformanceWarning]
    let architectureHints: [ArchitectureHint]
    
    var complexityScore: Int {
        let smellScore = codeSmells.reduce(0) { $0 + $1.severity.rawValue }
        let perfScore = performanceWarnings.count * 2
        return min(100, smellScore + perfScore)
    }
    
    var healthScore: Int {
        return max(0, 100 - complexityScore)
    }
}

// MARK: - Code Smell

struct CodeSmell: Identifiable {
    let id = UUID()
    let type: CodeSmellType
    let severity: Severity
    let lineNumber: Int?
    let description: String
    let suggestion: String
    
    enum CodeSmellType: String, CaseIterable {
        case longMethod = "Long Method"
        case largeClass = "Large Class"
        case duplicateCode = "Duplicate Code"
        case longParameterList = "Long Parameter List"
        case deadCode = "Dead Code"
        case magicNumbers = "Magic Numbers"
        case deepNesting = "Deep Nesting"
        case godObject = "God Object"
        case featureEnvy = "Feature Envy"
        case dataClump = "Data Clump"
        
        var icon: String {
            switch self {
            case .longMethod: return "doc.text"
            case .largeClass: return "square.stack.3d.up"
            case .duplicateCode: return "doc.on.doc"
            case .longParameterList: return "list.bullet"
            case .deadCode: return "trash"
            case .magicNumbers: return "number"
            case .deepNesting: return "arrow.down.right.and.arrow.up.left"
            case .godObject: return "crown"
            case .featureEnvy: return "arrow.right.arrow.left"
            case .dataClump: return "circle.grid.3x3"
            }
        }
    }
}

// MARK: - Refactoring Suggestion

struct RefactoringSuggestion: Identifiable {
    let id = UUID()
    let title: String
    let category: RefactoringCategory
    let priority: Priority
    let description: String
    let beforeCode: String?
    let afterCode: String?
    let benefits: [String]
    
    enum RefactoringCategory: String, CaseIterable {
        case extraction = "Extract Method/Class"
        case simplification = "Simplification"
        case naming = "Naming Improvement"
        case organization = "Code Organization"
        case modernization = "Swift Modernization"
        case errorHandling = "Error Handling"
        
        var icon: String {
            switch self {
            case .extraction: return "scissors"
            case .simplification: return "wand.and.stars"
            case .naming: return "textformat"
            case .organization: return "folder"
            case .modernization: return "sparkles"
            case .errorHandling: return "exclamationmark.shield"
            }
        }
    }
    
    enum Priority: Int, CaseIterable {
        case low = 1
        case medium = 2
        case high = 3
        case critical = 4
        
        var color: String {
            switch self {
            case .low: return "green"
            case .medium: return "yellow"
            case .high: return "orange"
            case .critical: return "red"
            }
        }
        
        var label: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .critical: return "Critical"
            }
        }
    }
}

// MARK: - Performance Warning

struct PerformanceWarning: Identifiable {
    let id = UUID()
    let issue: String
    let impact: Impact
    let lineNumber: Int?
    let description: String
    let optimization: String
    let estimatedImprovement: String?
    
    enum Impact: String, CaseIterable {
        case minor = "Minor"
        case moderate = "Moderate"
        case significant = "Significant"
        case critical = "Critical"
        
        var color: String {
            switch self {
            case .minor: return "green"
            case .moderate: return "yellow"
            case .significant: return "orange"
            case .critical: return "red"
            }
        }
        
        var icon: String {
            switch self {
            case .minor: return "gauge.low"
            case .moderate: return "gauge.medium"
            case .significant: return "gauge.high"
            case .critical: return "exclamationmark.octagon"
            }
        }
    }
}

// MARK: - Architecture Hint

struct ArchitectureHint: Identifiable {
    let id = UUID()
    let pattern: ArchitecturePattern
    let recommendation: String
    let rationale: String
    let implementationSteps: [String]
    let resources: [String]
    
    enum ArchitecturePattern: String, CaseIterable {
        case mvvm = "MVVM"
        case viper = "VIPER"
        case clean = "Clean Architecture"
        case coordinator = "Coordinator Pattern"
        case repository = "Repository Pattern"
        case dependency = "Dependency Injection"
        case solid = "SOLID Principles"
        case composition = "Composition over Inheritance"
        
        var icon: String {
            switch self {
            case .mvvm: return "square.split.2x2"
            case .viper: return "hexagon"
            case .clean: return "sparkles"
            case .coordinator: return "map"
            case .repository: return "tray.2"
            case .dependency: return "arrow.triangle.branch"
            case .solid: return "building.columns"
            case .composition: return "square.stack.3d.up"
            }
        }
    }
}

// MARK: - Common Severity

enum Severity: Int, CaseIterable {
    case low = 1
    case medium = 3
    case high = 5
    case critical = 8
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "yellow"
        case .high: return "orange"
        case .critical: return "red"
        }
    }
    
    var label: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .critical: return "Critical"
        }
    }
}
