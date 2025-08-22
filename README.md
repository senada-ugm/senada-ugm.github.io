# SENADA-UGM Lab Website

This is the official website for the Software Engineering and Data Lab (SENADA) at Universitas Gadjah Mada (UGM), Indonesia.

## About SENADA-UGM

SENADA (Software Engineering and Data Lab) is a research laboratory in the Department of Computer Science and Electronics, Faculty of Mathematics and Natural Sciences, Universitas Gadjah Mada. The lab focuses on cutting-edge research in:

- **Medical Informatics**
- **Data Mining and Machine Learning**
- **Natural Language Processing** (especially for Indonesian language)
- **Semantic Web & Knowledge Graph Technologies**
- **Software Engineering and Mining Software Repositories**
- **Cybersecurity and Privacy Engineering**
- **Augmented/Virtual/Mixed Reality**
- **Mobile Software Engineering**

## Lab Head

**Assoc. Prof. Lukman Heryawan, Ph.D.**  
Head of Software Engineering and Data Lab  
Email: lukmanh@ugm.ac.id

## Technical Details

This website is built using Jekyll and is based on the [petridish](https://github.com/peterdesmet/petridish) theme with extensive modifications. It is hosted on [GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages).

## Development

To run the website locally:

```bash
bundle install
bundle exec jekyll serve
```

The website will be available at `http://localhost:4000`.

### Code Quality with Qodo

This project uses [Qodo](https://qodo.ai) for comprehensive code quality analysis. The setup includes:

- **Automated CI/CD checks** via GitHub Actions
- **Multi-language support** (Python, JavaScript, Markdown, YAML)
- **Security scanning** for dependencies and potential secrets
- **Jekyll-specific rules** for front matter and content validation

#### Running Quality Checks Locally

```bash
# Install dependencies
pip install pylint flake8 black isort
npm install -g markdownlint-cli eslint prettier

# Run all checks
./scripts/run-qodo-checks.sh
```

#### Configuration Files

- `.qodo.yml` - Main Qodo configuration
- `.qodoignore` - Files to exclude from analysis
- `.github/workflows/qodo.yml` - CI/CD workflow
- Language-specific configs: `.pylintrc`, `.flake8`, `pyproject.toml`, `.markdownlint.json`

For detailed information about the Qodo setup, see [.qodo/README.md](.qodo/README.md).

## License

This theme is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Please see 'LICENSE-petridish' for the license of the parent theme 
and LICENSE for the license of modifications and additions made in umich-labs.
