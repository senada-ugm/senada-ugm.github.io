#!/bin/bash

# Qodo Local Check Script for SENADA-UGM Website
# This script runs the same quality checks that are performed in CI/CD

set -e  # Exit on any error

echo "🔍 SENADA-UGM Website - Qodo Quality Checks"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_dependencies() {
    print_status "Checking dependencies..."
    
    local missing_deps=()
    
    # Python tools
    if ! command -v python3 &> /dev/null; then
        missing_deps+=("python3")
    fi
    
    if ! python3 -c "import pylint" 2>/dev/null; then
        missing_deps+=("pylint")
    fi
    
    if ! python3 -c "import flake8" 2>/dev/null; then
        missing_deps+=("flake8")
    fi
    
    if ! python3 -c "import black" 2>/dev/null; then
        missing_deps+=("black")
    fi
    
    if ! python3 -c "import isort" 2>/dev/null; then
        missing_deps+=("isort")
    fi
    
    # Node.js tools
    if ! command -v node &> /dev/null; then
        missing_deps+=("node.js")
    fi
    
    if ! command -v markdownlint &> /dev/null; then
        missing_deps+=("markdownlint-cli")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        echo ""
        echo "To install missing dependencies:"
        echo "  Python tools: pip install pylint flake8 black isort"
        echo "  Node.js tools: npm install -g markdownlint-cli eslint prettier"
        exit 1
    fi
    
    print_success "All dependencies are installed"
}

# Run Python checks
run_python_checks() {
    print_status "Running Python code quality checks..."
    
    local python_files=$(find . -name "*.py" -not -path "./node_modules/*" -not -path "./_site/*" -not -path "./.git/*")
    
    if [ -z "$python_files" ]; then
        print_warning "No Python files found to check"
        return 0
    fi
    
    echo "Found Python files:"
    echo "$python_files"
    echo ""
    
    # Pylint
    print_status "Running pylint..."
    if pylint $python_files; then
        print_success "Pylint passed"
    else
        print_warning "Pylint found issues (exit code: $?)"
    fi
    echo ""
    
    # Flake8
    print_status "Running flake8..."
    if flake8 $python_files; then
        print_success "Flake8 passed"
    else
        print_warning "Flake8 found issues (exit code: $?)"
    fi
    echo ""
    
    # Black (check only)
    print_status "Checking Python formatting with black..."
    if black --check --diff $python_files; then
        print_success "Black formatting is correct"
    else
        print_warning "Black found formatting issues (exit code: $?)"
        echo "Run 'black .' to fix formatting issues"
    fi
    echo ""
    
    # isort (check only)
    print_status "Checking import sorting with isort..."
    if isort --check-only --diff $python_files; then
        print_success "Import sorting is correct"
    else
        print_warning "isort found sorting issues (exit code: $?)"
        echo "Run 'isort .' to fix import sorting"
    fi
    echo ""
}

# Run JavaScript checks
run_javascript_checks() {
    print_status "Running JavaScript code quality checks..."
    
    local js_files=$(find . -name "*.js" -not -path "./node_modules/*" -not -path "./_site/*" -not -path "./assets/theme/*" -not -path "./.git/*")
    
    if [ -z "$js_files" ]; then
        print_warning "No JavaScript files found to check"
        return 0
    fi
    
    echo "Found JavaScript files:"
    echo "$js_files"
    echo ""
    
    # ESLint (if available)
    if command -v eslint &> /dev/null; then
        print_status "Running eslint..."
        if eslint $js_files; then
            print_success "ESLint passed"
        else
            print_warning "ESLint found issues (exit code: $?)"
        fi
    else
        print_warning "ESLint not available, skipping JavaScript linting"
    fi
    echo ""
}

# Run Markdown checks
run_markdown_checks() {
    print_status "Running Markdown quality checks..."
    
    local md_files=$(find . -name "*.md" -not -path "./node_modules/*" -not -path "./_site/*" -not -path "./.git/*")
    
    if [ -z "$md_files" ]; then
        print_warning "No Markdown files found to check"
        return 0
    fi
    
    print_status "Running markdownlint..."
    if markdownlint . --ignore node_modules --ignore _site --ignore .git; then
        print_success "Markdownlint passed"
    else
        print_warning "Markdownlint found issues (exit code: $?)"
    fi
    echo ""
}

# Run YAML checks
run_yaml_checks() {
    print_status "Running YAML syntax checks..."
    
    local yaml_files=$(find . \( -name "*.yml" -o -name "*.yaml" \) -not -path "./node_modules/*" -not -path "./_site/*" -not -path "./.git/*")
    
    if [ -z "$yaml_files" ]; then
        print_warning "No YAML files found to check"
        return 0
    fi
    
    echo "Found YAML files:"
    echo "$yaml_files"
    echo ""
    
    local yaml_errors=0
    for file in $yaml_files; do
        if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
            echo "✓ $file"
        else
            echo "✗ $file"
            yaml_errors=$((yaml_errors + 1))
        fi
    done
    
    if [ $yaml_errors -eq 0 ]; then
        print_success "All YAML files are valid"
    else
        print_warning "Found $yaml_errors YAML files with syntax errors"
    fi
    echo ""
}

# Run security checks
run_security_checks() {
    print_status "Running basic security checks..."
    
    # Check for potential secrets
    print_status "Checking for potential secrets..."
    if grep -r -i "password\|api_key\|secret\|token" . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=_site --exclude="*.log" 2>/dev/null; then
        print_warning "Found potential secrets in code (review above output)"
    else
        print_success "No obvious secrets found"
    fi
    echo ""
    
    # Check Node.js dependencies
    if [ -f "package.json" ]; then
        print_status "Checking Node.js dependencies for vulnerabilities..."
        if npm audit; then
            print_success "No known vulnerabilities in Node.js dependencies"
        else
            print_warning "Found vulnerabilities in Node.js dependencies (exit code: $?)"
        fi
    fi
    echo ""
}

# Main execution
main() {
    echo "Starting quality checks at $(date)"
    echo ""
    
    # Create reports directory
    mkdir -p .qodo/reports
    
    # Run all checks
    check_dependencies
    echo ""
    
    run_python_checks
    run_javascript_checks
    run_markdown_checks
    run_yaml_checks
    run_security_checks
    
    print_success "Quality checks completed!"
    echo ""
    echo "📊 For detailed reports, check the .qodo/reports/ directory"
    echo "🔧 To fix issues automatically where possible:"
    echo "   - Python formatting: black ."
    echo "   - Python imports: isort ."
    echo "   - JavaScript formatting: prettier --write ."
    echo ""
    echo "For more information, see .qodo/README.md"
}

# Run main function
main "$@"