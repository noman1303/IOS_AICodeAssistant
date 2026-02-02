import Foundation
import SwiftUI

@MainActor
class CodeAnalysisViewModel: ObservableObject {
    @Published var analysis: CodeAnalysis?
    @Published var isAnalyzing = false
    @Published var errorMessage: String?
    
    func analyzeFile(at url: URL) {
        isAnalyzing = true
        errorMessage = nil
        
        Task {
            do {
                // Start accessing security-scoped resource
                guard url.startAccessingSecurityScopedResource() else {
                    throw NSError(domain: "FileAccess", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot access file"])
                }
                
                defer { url.stopAccessingSecurityScopedResource() }
                
                let content = try String(contentsOf: url, encoding: .utf8)
                let analyzer = SwiftCodeAnalyzer()
                let analysis = analyzer.analyze(code: content, fileName: url.lastPathComponent)
                
                await MainActor.run {
                    self.analysis = analysis
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

// MARK: - Swift Code Analyzer

class SwiftCodeAnalyzer {
    func analyze(code: String, fileName: String) -> CodeAnalysis {
        let lines = code.components(separatedBy: .newlines)
        let linesOfCode = lines.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count
        
        let codeSmells = detectCodeSmells(code: code, lines: lines)
        let refactoringSuggestions = generateRefactoringSuggestions(code: code, lines: lines)
        let performanceWarnings = detectPerformanceIssues(code: code, lines: lines)
        let architectureHints = generateArchitectureHints(code: code)
        
        return CodeAnalysis(
            fileName: fileName,
            fileSize: code.count,
            linesOfCode: linesOfCode,
            analyzedAt: Date(),
            codeSmells: codeSmells,
            refactoringSuggestions: refactoringSuggestions,
            performanceWarnings: performanceWarnings,
            architectureHints: architectureHints
        )
    }
    
    // MARK: - Code Smell Detection
    
    private func detectCodeSmells(code: String, lines: [String]) -> [CodeSmell] {
        var smells: [CodeSmell] = []
        
        // Detect long methods
        let methodPattern = /func\s+\w+/
        var methodLineCount = 0
        var inMethod = false
        var methodStartLine = 0
        var braceCount = 0
        
        for (index, line) in lines.enumerated() {
            if line.contains(methodPattern) {
                inMethod = true
                methodStartLine = index + 1
                methodLineCount = 0
                braceCount = 0
            }
            
            if inMethod {
                methodLineCount += 1
                braceCount += line.filter { $0 == "{" }.count
                braceCount -= line.filter { $0 == "}" }.count
                
                if braceCount == 0 && methodLineCount > 1 {
                    if methodLineCount > 50 {
                        smells.append(CodeSmell(
                            type: .longMethod,
                            severity: .high,
                            lineNumber: methodStartLine,
                            description: "Method spans \(methodLineCount) lines",
                            suggestion: "Consider breaking this method into smaller, focused functions. Aim for methods under 30 lines."
                        ))
                    } else if methodLineCount > 30 {
                        smells.append(CodeSmell(
                            type: .longMethod,
                            severity: .medium,
                            lineNumber: methodStartLine,
                            description: "Method spans \(methodLineCount) lines",
                            suggestion: "This method is getting long. Consider extracting some logic into separate methods."
                        ))
                    }
                    inMethod = false
                }
            }
        }
        
        // Detect magic numbers
        for (index, line) in lines.enumerated() {
            let numberPattern = /\s+(\d+\.?\d*)\s*/
            if let match = line.firstMatch(of: numberPattern) {
                let number = String(match.1)
                if number != "0" && number != "1" && !line.contains("//") {
                    smells.append(CodeSmell(
                        type: .magicNumbers,
                        severity: .low,
                        lineNumber: index + 1,
                        description: "Magic number '\(number)' found",
                        suggestion: "Replace with a named constant to improve code readability and maintainability."
                    ))
                }
            }
        }
        
        // Detect deep nesting
        for (index, line) in lines.enumerated() {
            let indentation = line.prefix(while: { $0 == " " || $0 == "\t" }).count
            if indentation > 20 {
                smells.append(CodeSmell(
                    type: .deepNesting,
                    severity: .medium,
                    lineNumber: index + 1,
                    description: "Deep nesting detected (indentation: \(indentation))",
                    suggestion: "Reduce nesting by using guard statements, early returns, or extracting methods."
                ))
            }
        }
        
        // Detect long parameter lists
        let funcPattern = /func\s+\w+\s*\([^)]{50,}\)/
        for (index, line) in lines.enumerated() {
            if line.contains(funcPattern) {
                smells.append(CodeSmell(
                    type: .longParameterList,
                    severity: .medium,
                    lineNumber: index + 1,
                    description: "Function has a long parameter list",
                    suggestion: "Consider using a parameter object or builder pattern to reduce parameters."
                ))
            }
        }
        
        // Check for large classes
        if lines.count > 300 {
            smells.append(CodeSmell(
                type: .largeClass,
                severity: .high,
                lineNumber: nil,
                description: "File contains \(lines.count) lines",
                suggestion: "This file is very large. Consider splitting it into multiple smaller, focused classes following Single Responsibility Principle."
            ))
        }
        
        return smells
    }
    
    // MARK: - Refactoring Suggestions
    
    private func generateRefactoringSuggestions(code: String, lines: [String]) -> [RefactoringSuggestion] {
        var suggestions: [RefactoringSuggestion] = []
        
        // Check for forced unwrapping
        if code.contains("!") && !code.contains("!=") {
            suggestions.append(RefactoringSuggestion(
                title: "Replace Force Unwrapping with Safe Unwrapping",
                category: .errorHandling,
                priority: .high,
                description: "Detected force unwrapping operators which can cause runtime crashes.",
                beforeCode: "let value = optionalValue!",
                afterCode: """
                guard let value = optionalValue else {
                    return
                }
                // or use: if let value = optionalValue { }
                """,
                benefits: [
                    "Prevents runtime crashes",
                    "Makes error handling explicit",
                    "Improves code safety"
                ]
            ))
        }
        
        // Check for var when let could be used
        if code.contains("var ") {
            suggestions.append(RefactoringSuggestion(
                title: "Use 'let' Instead of 'var' for Immutable Values",
                category: .modernization,
                priority: .low,
                description: "Consider using 'let' for values that don't change to improve code safety and clarity.",
                beforeCode: "var constant = 42\nreturn constant",
                afterCode: "let constant = 42\nreturn constant",
                benefits: [
                    "Prevents accidental mutations",
                    "Improves code clarity",
                    "Compiler optimizations"
                ]
            ))
        }
        
        // Check for explicit self
        if code.contains("self.") {
            suggestions.append(RefactoringSuggestion(
                title: "Remove Unnecessary 'self' Keywords",
                category: .simplification,
                priority: .low,
                description: "Swift doesn't require 'self' in most cases. Remove it to reduce code noise.",
                beforeCode: "self.property = value\nself.method()",
                afterCode: "property = value\nmethod()",
                benefits: [
                    "Cleaner, more readable code",
                    "Follows Swift conventions",
                    "Reduces visual clutter"
                ]
            ))
        }
        
        // Suggest modern Swift features
        if code.contains("enum") && !code.contains("CaseIterable") {
            suggestions.append(RefactoringSuggestion(
                title: "Adopt CaseIterable for Enums",
                category: .modernization,
                priority: .medium,
                description: "Make enums conform to CaseIterable for automatic access to all cases.",
                beforeCode: "enum Status {\n    case active, inactive\n}",
                afterCode: "enum Status: CaseIterable {\n    case active, inactive\n}\n// Access via Status.allCases",
                benefits: [
                    "Easy iteration over all cases",
                    "Automatic case listing",
                    "Type-safe enumeration"
                ]
            ))
        }
        
        // Check for naming conventions
        if code.contains("func ") && code.lowercased().contains("get") {
            suggestions.append(RefactoringSuggestion(
                title: "Remove 'get' Prefix from Method Names",
                category: .naming,
                priority: .low,
                description: "Swift convention is to omit 'get' prefix from method names.",
                beforeCode: "func getUserName() -> String",
                afterCode: "func userName() -> String\n// or better: var userName: String",
                benefits: [
                    "Follows Swift naming conventions",
                    "More concise and readable",
                    "Better Swift API design"
                ]
            ))
        }
        
        return suggestions
    }
    
    // MARK: - Performance Detection
    
    private func detectPerformanceIssues(code: String, lines: [String]) -> [PerformanceWarning] {
        var warnings: [PerformanceWarning] = []
        
        // Check for String concatenation in loops
        if code.contains("for ") && code.contains("+= ") {
            warnings.append(PerformanceWarning(
                issue: "String Concatenation in Loop",
                impact: .significant,
                lineNumber: nil,
                description: "String concatenation using += in loops creates multiple string copies.",
                optimization: "Use String array and join(), or use String interpolation",
                estimatedImprovement: "Up to 10x faster for large loops"
            ))
        }
        
        // Check for array operations
        if code.contains(".append(") && code.contains("for ") {
            warnings.append(PerformanceWarning(
                issue: "Consider Array Capacity Pre-allocation",
                impact: .moderate,
                lineNumber: nil,
                description: "Arrays that grow dynamically may cause multiple reallocations.",
                optimization: "Use array.reserveCapacity(n) before the loop",
                estimatedImprovement: "Reduces memory allocations by ~50%"
            ))
        }
        
        // Check for unnecessary computations
        if code.contains("count >") || code.contains("count ==") {
            warnings.append(PerformanceWarning(
                issue: "Use isEmpty Instead of count == 0",
                impact: .minor,
                lineNumber: nil,
                description: "Checking count for emptiness can be O(n) for some collections.",
                optimization: "Use .isEmpty property instead of count comparisons",
                estimatedImprovement: "O(1) instead of potentially O(n)"
            ))
        }
        
        // Check for NSObject subclassing
        if code.contains(": NSObject") {
            warnings.append(PerformanceWarning(
                issue: "Unnecessary NSObject Inheritance",
                impact: .moderate,
                lineNumber: nil,
                description: "NSObject adds overhead. Use pure Swift classes when possible.",
                optimization: "Remove NSObject inheritance if not needed for Objective-C interop",
                estimatedImprovement: "Reduced memory footprint and faster initialization"
            ))
        }
        
        // Check for retain cycles potential
        if code.contains("self.") && code.contains("{ ") && !code.contains("[weak self]") {
            warnings.append(PerformanceWarning(
                issue: "Potential Retain Cycle in Closure",
                impact: .critical,
                lineNumber: nil,
                description: "Capturing self in closures without weak reference can cause memory leaks.",
                optimization: "Use [weak self] or [unowned self] in closure capture lists",
                estimatedImprovement: "Prevents memory leaks"
            ))
        }
        
        return warnings
    }
    
    // MARK: - Architecture Hints
    
    private func generateArchitectureHints(code: String) -> [ArchitectureHint] {
        var hints: [ArchitectureHint] = []
        
        // MVVM pattern suggestion
        if code.contains("class") && code.contains("View") {
            hints.append(ArchitectureHint(
                pattern: .mvvm,
                recommendation: "Consider MVVM Architecture",
                rationale: "MVVM separates UI logic from business logic, making code more testable and maintainable.",
                implementationSteps: [
                    "Create a ViewModel class with @Published properties",
                    "Move business logic from View to ViewModel",
                    "Use @StateObject in SwiftUI views",
                    "Make ViewModel conform to ObservableObject"
                ],
                resources: [
                    "Apple's SwiftUI Data Flow documentation",
                    "WWDC sessions on SwiftUI architecture"
                ]
            ))
        }
        
        // Dependency Injection
        if code.contains("init(") {
            hints.append(ArchitectureHint(
                pattern: .dependency,
                recommendation: "Implement Dependency Injection",
                rationale: "DI makes code more testable, flexible, and reduces coupling between components.",
                implementationSteps: [
                    "Define protocol for dependencies",
                    "Inject dependencies through initializer",
                    "Use protocols instead of concrete types",
                    "Consider using a DI container for complex apps"
                ],
                resources: [
                    "Protocol-Oriented Programming in Swift",
                    "Swift Dependency Injection patterns"
                ]
            ))
        }
        
        // SOLID principles
        hints.append(ArchitectureHint(
            pattern: .solid,
            recommendation: "Apply SOLID Principles",
            rationale: "SOLID principles lead to more maintainable, flexible, and scalable code.",
            implementationSteps: [
                "Single Responsibility: One class, one purpose",
                "Open/Closed: Open for extension, closed for modification",
                "Liskov Substitution: Subtypes must be substitutable",
                "Interface Segregation: Many specific protocols over one general",
                "Dependency Inversion: Depend on abstractions, not concretions"
            ],
            resources: [
                "SOLID Principles in Swift",
                "Clean Code by Robert C. Martin"
            ]
        ))
        
        // Repository pattern for data
        if code.contains("func fetch") || code.contains("func save") {
            hints.append(ArchitectureHint(
                pattern: .repository,
                recommendation: "Implement Repository Pattern",
                rationale: "Repository pattern abstracts data access, making it easier to switch data sources and test.",
                implementationSteps: [
                    "Create a protocol defining data operations",
                    "Implement concrete repository classes",
                    "Inject repository into ViewModels",
                    "Mock repositories for testing"
                ],
                resources: [
                    "Repository Pattern in Swift",
                    "Data Layer Architecture best practices"
                ]
            ))
        }
        
        return hints
    }
}
