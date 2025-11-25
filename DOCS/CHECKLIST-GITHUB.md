# GitHub Repository Setup & CI/CD Configuration Checklist

## Purpose
Complete checklist for setting up GitHub repositories with proper branching strategy, CI/CD pipelines, and automated deployment after PR merges. Use this when starting new projects or setting up GitHub on a new laptop.

---

## Part 1: Initial Setup on New Laptop/Workstation

### 1.1 Install Required Software

- [ ] **Git for Windows** - https://git-scm.com/download/win
- [ ] **GitHub CLI (gh)** - `winget install --id GitHub.cli`
- [ ] **.NET SDK** (for .NET projects) - https://dotnet.microsoft.com/download
- [ ] **VS Code or Visual Studio** - Your preferred IDE

### 1.2 Configure Git

```bash
# Set your identity
git config --global user.name "your-github-username"
git config --global user.email "your-github-email@example.com"

# Set default branch name to 'master' (or 'main' if you prefer)
git config --global init.defaultBranch master

# Enable colored output
git config --global color.ui auto

# Set default editor (optional)
git config --global core.editor "code --wait"  # For VS Code

# Verify configuration
git config --list
```

### 1.3 Authenticate GitHub CLI

```bash
# Login to GitHub
gh auth login

# Choose:
# - GitHub.com
# - HTTPS protocol
# - Yes (authenticate Git)
# - Login with web browser

# Verify authentication
gh auth status
```

Expected output:
```
✓ Logged in to github.com account username (keyring)
- Active account: true
- Git operations protocol: https
- Token: gho_****
- Token scopes: 'repo', 'workflow', ...
```

### 1.4 Generate SSH Keys (Optional but Recommended)

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your-github-email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub: https://github.com/settings/keys
```

---

## Part 2: Create New Repository with Proper Setup

### 2.1 Initialize Local Git Repository

```bash
# Navigate to your project folder
cd "path/to/your/project"

# Initialize git
git init

# Verify it's initialized
git status
```

### 2.2 Create .gitignore File

For .NET/Blazor projects, create `.gitignore`:

```gitignore
## Build results
[Dd]ebug/
[Rr]elease/
[Bb]in/
[Oo]bj/

## Visual Studio
.vs/
*.user
*.suo

## User-specific files
*.rsuser
*.userosscache

## .NET Core
project.lock.json
project.fragment.lock.json
artifacts/

## Others
*.cache
*.log
*.tmp
```

**Or use a comprehensive .gitignore:**
- Copy from existing project
- Or download: `curl https://www.toptal.com/developers/gitignore/api/visualstudio,dotnet > .gitignore`

### 2.3 Make Initial Commit to Master

```bash
# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Project setup with authentication"

# Verify
git log --oneline
git branch
```

### 2.4 Create GitHub Repository

```bash
# Using GitHub CLI (recommended)
gh repo create YOUR-REPO-NAME \
  --public \
  --source=. \
  --remote=origin \
  --description="Your project description"

# This creates the repo AND sets up the remote
```

**Or manually:**
1. Go to https://github.com/new
2. Enter repository name
3. Choose public/private
4. **DO NOT** initialize with README, .gitignore, or license
5. Click "Create repository"

Then add remote:

```bash
git remote add origin https://github.com/USERNAME/REPO-NAME.git
```

### 2.5 Push Master Branch

```bash
# Push master to GitHub
git push -u origin master

# Verify
gh repo view --web
```

---

## Part 3: Set Up Branching Strategy

### 3.1 Branch Protection (Optional but Recommended)

Protect master branch from direct pushes:

```bash
# Using gh CLI
gh api repos/OWNER/REPO/branches/master/protection -X PUT --input - <<< '{
  "required_pull_request_reviews": {
    "required_approving_review_count": 0
  },
  "enforce_admins": false,
  "required_status_checks": null,
  "restrictions": null
}'
```

**Or via Web UI:**
1. Go to repo Settings → Branches
2. Add rule for `master`
3. Enable "Require pull request before merging"
4. Save

### 3.2 Create Work Branch

```bash
# Create and switch to work branch
git checkout -b work/session-001

# Push work branch to GitHub
git push -u origin work/session-001

# Verify both branches exist
git branch -a
```

### 3.3 Set Up Branch Naming Convention

Standard convention:
- `master` - Production-ready code
- `work/session-XXX` - Development work for each session
- `feature/feature-name` - New features
- `bugfix/issue-name` - Bug fixes
- `hotfix/critical-fix` - Production hotfixes

---

## Part 4: Configure CI/CD Pipeline

### 4.1 Set Up Self-Hosted Runner

Follow **CHECKLIST-ACTIONS-RUNNER.md** to install runner on your VPS.

Verify runner is online:

```bash
gh api repos/OWNER/REPO/actions/runners --jq '.runners[] | {name, status}'
```

### 4.2 Create Deployment Workflow

Create `.github/workflows/deploy-to-vps.yml`:

```yaml
name: Deploy to VPS

on:
  push:
    branches: [ master ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: self-hosted

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: '10.0.x'

    - name: Restore dependencies
      run: dotnet restore
      working-directory: ./path/to/project

    - name: Build
      run: dotnet build --configuration Release --no-restore
      working-directory: ./path/to/project

    - name: Publish
      run: dotnet publish --configuration Release --output ./publish --no-build
      working-directory: ./path/to/project

    - name: Stop IIS App Pool
      shell: powershell
      run: |
        Import-Module WebAdministration
        Stop-WebAppPool -Name "YourAppPoolName"
        Start-Sleep -Seconds 5

    - name: Deploy to IIS
      shell: powershell
      run: |
        $destination = "C:\Websites1\ProjectName"
        if (Test-Path $destination) {
          Remove-Item -Path "$destination\*" -Recurse -Force -Exclude "web.config"
        }
        Copy-Item -Path ./path/to/project/publish/* -Destination $destination -Recurse -Force

    - name: Start IIS App Pool
      shell: powershell
      run: |
        Import-Module WebAdministration
        Start-WebAppPool -Name "YourAppPoolName"

    - name: Verify Deployment
      shell: powershell
      run: |
        Start-Sleep -Seconds 10
        $response = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing
        if ($response.StatusCode -eq 200) {
          Write-Host "✅ Deployment successful!"
        } else {
          Write-Error "Deployment verification failed"
          exit 1
        }
```

Commit and push:

```bash
git add .github/workflows/deploy-to-vps.yml
git commit -m "Add deployment workflow"
git push
```

### 4.3 Configure GitHub Secrets (if needed)

```bash
# Set repository secrets via CLI
gh secret set SECRET_NAME --body "secret-value"

# Or via web UI:
# Settings → Secrets and variables → Actions → New repository secret
```

Common secrets:
- `CONNECTION_STRING`
- `API_KEYS`
- `DEPLOY_PASSWORD`

---

## Part 5: Development Workflow

### 5.1 Daily Development Process

```bash
# 1. Start work on feature branch
git checkout work/session-001

# 2. Make changes to code
# ... edit files ...

# 3. Stage and commit
git add .
git commit -m "Add feature: description"

# 4. Push to GitHub
git push origin work/session-001

# 5. Continue working or create PR when ready
```

### 5.2 Create Pull Request

```bash
# Using GitHub CLI
gh pr create \
  --title "Feature: Add user authentication" \
  --body "## Summary
- Added login page
- Added register page
- Implemented AuthService

## Test Plan
- [x] Login works
- [x] Register works
- [x] Auth persists across sessions" \
  --base master \
  --head work/session-001

# View PR
gh pr view --web
```

**Or via Web UI:**
1. Go to repository on GitHub
2. Click "Pull requests" → "New pull request"
3. Base: `master`, Compare: `work/session-001`
4. Fill in title and description
5. Click "Create pull request"

### 5.3 Merge PR (Triggers Deployment)

```bash
# Review PR
gh pr view 1

# If approved, merge
gh pr merge 1 --merge --delete-branch

# Or squash merge (cleaner history)
gh pr merge 1 --squash --delete-branch
```

**What happens automatically:**
1. ✅ PR merged to `master`
2. ✅ GitHub Actions workflow triggered
3. ✅ Code built on self-hosted runner
4. ✅ Deployed to VPS automatically
5. ✅ IIS app pool restarted
6. ✅ Deployment verified

### 5.4 Verify Deployment

```bash
# Check workflow status
gh run list --workflow=deploy-to-vps.yml --limit 1

# View workflow logs
gh run view --log

# Or visit: https://github.com/OWNER/REPO/actions
```

### 5.5 Create New Work Branch for Next Session

```bash
# Switch back to master
git checkout master

# Pull latest changes
git pull origin master

# Create new work branch
git checkout -b work/session-002

# Push to GitHub
git push -u origin work/session-002
```

---

## Part 6: Common Operations

### 6.1 Clone Repository on New Machine

```bash
# Clone
git clone https://github.com/OWNER/REPO.git
cd REPO

# Verify branches
git branch -a

# Checkout work branch
git checkout work/session-XXX
```

### 6.2 Sync Local with Remote

```bash
# Fetch all branches
git fetch --all

# Pull latest master
git checkout master
git pull origin master

# Update work branch with master changes
git checkout work/session-XXX
git merge master

# Or rebase (cleaner history)
git rebase master
```

### 6.3 Discard Local Changes

```bash
# Discard all uncommitted changes
git reset --hard HEAD

# Discard changes to specific file
git checkout -- filename.cs

# Clean untracked files
git clean -fd
```

### 6.4 View History

```bash
# View commit history
git log --oneline --graph --all

# View specific file history
git log --oneline -- filename.cs

# View changes in last commit
git show HEAD
```

### 6.5 Create Release/Tag

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag to GitHub
git push origin v1.0.0

# Create GitHub release
gh release create v1.0.0 \
  --title "v1.0.0 - Initial Release" \
  --notes "First production release"
```

---

## Part 7: Troubleshooting

### Git Push Rejected

```bash
# Pull latest changes first
git pull origin master --rebase

# Resolve conflicts if any
# ... edit files ...
git add .
git rebase --continue

# Push again
git push origin master
```

### Merge Conflicts

```bash
# During merge
git merge master

# If conflicts:
# 1. Edit files to resolve conflicts
# 2. Stage resolved files
git add resolved-file.cs

# 3. Complete merge
git commit

# Or abort merge
git merge --abort
```

### Reset to Remote State

```bash
# WARNING: This discards ALL local changes

# Reset to match remote master
git fetch origin
git reset --hard origin/master

# Or reset specific branch
git reset --hard origin/work/session-XXX
```

### Undo Last Commit (Not Pushed)

```bash
# Keep changes, undo commit
git reset --soft HEAD~1

# Discard changes and commit
git reset --hard HEAD~1
```

### GitHub CLI Not Authenticated

```bash
# Re-authenticate
gh auth login

# Check status
gh auth status

# Refresh token
gh auth refresh
```

---

## Part 8: Best Practices

### Commit Messages

Good format:
```
Add user authentication feature

- Implemented login page
- Implemented register page
- Added AuthService with interface
- Added translations for 6 languages
```

Bad format:
```
updates
```

### Branch Management

- ✅ Always create feature/work branches
- ✅ Keep master clean and production-ready
- ✅ Delete branches after PR merge
- ✅ Use descriptive branch names
- ❌ Don't commit directly to master

### Pull Requests

- ✅ Write clear PR descriptions
- ✅ Include test plan/checklist
- ✅ Reference related issues
- ✅ Keep PRs focused and small
- ❌ Don't create massive PRs

### Security

- ✅ Never commit passwords/secrets
- ✅ Use .gitignore properly
- ✅ Use GitHub Secrets for sensitive data
- ✅ Rotate tokens regularly
- ❌ Don't commit .env files with real credentials

---

## Quick Reference Commands

```bash
# Setup
git init
gh repo create REPO --public --source=.
git push -u origin master

# Daily workflow
git checkout work/session-XXX
git add .
git commit -m "message"
git push

# Create PR
gh pr create --title "Title" --body "Body"

# Merge PR (triggers deployment)
gh pr merge 1 --squash --delete-branch

# Check deployment
gh run list --limit 1
gh run view --log

# New session
git checkout master
git pull
git checkout -b work/session-002
git push -u origin work/session-002
```

---

## Checklist Summary

- [ ] Git installed and configured
- [ ] GitHub CLI installed and authenticated
- [ ] Repository created on GitHub
- [ ] Master branch pushed
- [ ] Work branch created
- [ ] Self-hosted runner installed and online
- [ ] Deployment workflow created
- [ ] Test deployment successful
- [ ] Branch protection configured (optional)
- [ ] Team members have access (if applicable)

---

## Document History

- **Created:** 2025-11-25
- **Last Updated:** 2025-11-25
- **Tested On:** Windows 11, Git 2.51, GitHub CLI 2.x
- **Status:** Production Ready ✅
