# Qodo Configuration for SENADA-UGM Website

This directory contains the Qodo configuration and reports for the SENADA-UGM GitHub Pages website.

## Overview

Qodo has been configured to provide comprehensive code quality analysis for this Jekyll-based website project. The configuration includes checks for:

- **Python code** (extract_images.py script)
- **JavaScript files** (theme and custom scripts)
- **Markdown content** (documentation and content files)
- **YAML configuration** (Jekyll config and data files)
- **CSS/SCSS styles** (custom styling)

## Configuration Files

- `.qodo.yml` - Main Qodo configuration
- `.qodoignore` - Files and directories to exclude from analysis
- `.pylintrc` - Python linting configuration
- `.flake8` - Python style checking configuration
- `pyproject.toml` - Black formatter and isort configuration
- `.markdownlint.json` - Markdown linting rules

## GitHub Actions Integration

The project includes a GitHub Actions workflow (`.github/workflows/qodo.yml`) that:

- Runs on every push and pull request
- Performs comprehensive code quality checks
- Generates security scans
- Creates automated PR comments with results
- Uploads detailed reports as artifacts

## Local Development

To run Qodo checks locally:

### Prerequisites

Install the required tools:

```bash
# Python tools
pip install pylint flake8 black isort

# Node.js tools
npm install -g eslint prettier markdownlint-cli stylelint

# Ruby tools (for Jekyll)
bundle install
```

### Running Checks

```bash
# Python code quality
pylint extract_images.py
flake8 extract_images.py
black --check extract_images.py
isort --check-only extract_images.py

# JavaScript linting
eslint assets/theme/js/*.js

# Markdown linting
markdownlint .

# YAML validation
python -c "import yaml; yaml.safe_load(open('_config.yml'))"
```

## Project-Specific Rules

### Jekyll-Specific Checks

The configuration includes custom rules for Jekyll projects:

1. **Front Matter Validation** - Ensures all markdown files have proper YAML front matter
2. **Image Path Validation** - Verifies that image links are correct
3. **Collection Structure** - Validates Jekyll collection structure in the `content/` directory

### Excluded Files

The following are excluded from analysis:
- Third-party dependencies (`node_modules/`, `vendor/`)
- Generated files (`_site/`, build outputs)
- Theme assets (`assets/theme/`, `_sass/bootstrap/`)
- Minified files (`*.min.js`, `*.min.css`)

## Reports

Qodo generates reports in multiple formats:
- JSON format for programmatic access
- HTML format for human-readable reports
- GitHub Actions artifacts for CI/CD integration

Reports are stored in `.qodo/reports/` and are automatically uploaded as GitHub Actions artifacts.

## Customization

To customize the Qodo configuration:

1. Edit `.qodo.yml` for main settings
2. Modify language-specific config files (`.pylintrc`, `.flake8`, etc.)
3. Update `.qodoignore` to exclude additional files
4. Adjust GitHub Actions workflow in `.github/workflows/qodo.yml`

## Support

For issues with the Qodo configuration:

1. Check the GitHub Actions logs for detailed error messages
2. Review the configuration files for any syntax errors
3. Ensure all required dependencies are installed
4. Consult the Qodo documentation for advanced configuration options

## Project Structure

```
.qodo/
├── README.md           # This file
└── reports/           # Generated reports (created automatically)
    ├── *.json         # JSON format reports
    └── *.html         # HTML format reports
```

The Qodo configuration is designed to maintain high code quality standards while being flexible enough to accommodate the specific needs of a Jekyll-based academic website.