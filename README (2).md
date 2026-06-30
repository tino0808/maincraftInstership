# Task 3 — CI/CD Automation for Dockerized Applications Using GitHub Actions
> Tino Paul — Cloud Computing & DevOps Internship · Maincrafts Technology

This task automates the Docker build-and-push workflow from Task 2 using **GitHub Actions**. Instead of manually running `docker build` and `docker push` every time, the pipeline does it automatically on every push to the `main` branch.

---

## 🎯 What Changed from Task 2 → Task 3

| | Task 2 (Manual) | Task 3 (Automated CI) |
|---|---|---|
| Build image | `docker build` typed by hand | GitHub Actions runs it for you |
| Push image | Not pushed anywhere centrally | Pushed to Docker Hub automatically |
| Trigger | You SSH in and run commands | Just `git push` — that's it |
| Consistency | Depends on you remembering steps | Same steps every time, no human error |

> **Note:** This task automates **building and pushing the image**, not deploying it to EC2. That's what makes it CI (Continuous Integration), not full CD. EC2 deployment automation typically comes in a later task.

---

## 📁 Final Repository Structure

```
project-root/
├── index.html
├── styles.css
├── Dockerfile
├── .dockerignore
├── README.md
└── .github/
    └── workflows/
        └── docker-ci.yml
```

---

## ✅ Prerequisites Checklist

Before starting, confirm:
- [x] Task 2 completed (Docker image runs correctly on EC2 manually)
- [x] Project already pushed to GitHub
- [ ] **Docker Hub account created** ← do this first if you haven't
- [x] Dockerfile verified and working

---

## 🚀 Part A — Create a Docker Hub Account

1. Go to [https://hub.docker.com](https://hub.docker.com)
2. Sign up for a **free account** (if you don't have one)
3. Once logged in, note your **Docker Hub username** — you'll need it everywhere below
4. *(Optional but recommended)* Create a repository named `portfolio-website` under your account — though the pipeline will also auto-create it on first push if it doesn't exist

---

## 🚀 Part B — Add the GitHub Actions Workflow File

### Step 1 — Create the workflow folder structure

In your local project folder (the same one with `index.html`, `Dockerfile`, etc.), create these nested folders:

```bash
mkdir -p .github/workflows
```

This creates `.github/workflows/` — GitHub Actions only looks for workflow files in this exact path.

### Step 2 — Add the workflow file

Create a file named `docker-ci.yml` inside `.github/workflows/` with this content:

```yaml
name: Docker CI Pipeline

on:
  push:
    branches:
      - main

jobs:
  docker-build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build Docker Image
        run: docker build -t ${{ secrets.DOCKER_USERNAME }}/portfolio-website:latest .

      - name: Push Docker Image
        run: docker push ${{ secrets.DOCKER_USERNAME }}/portfolio-website:latest
```

**What each part does:**
- `on: push: branches: [main]` → pipeline runs automatically every time you push to `main`
- `actions/checkout@v3` → pulls your repo's code into the GitHub-hosted runner
- `docker/login-action@v2` → logs into Docker Hub using your secret credentials (never hardcoded)
- `Build Docker Image` → runs the same `docker build` you did manually in Task 2, but on GitHub's servers
- `Push Docker Image` → uploads the built image to your Docker Hub account

---

## 🔐 Part C — Configure GitHub Secrets (Critical Step)

Never hardcode your Docker Hub password in the YAML file. Instead:

1. Go to your **GitHub repository** in the browser
2. Click **Settings** (top menu of the repo, not your profile settings)
3. In the left sidebar, click **Secrets and variables → Actions**
4. Click **New repository secret**
5. Add the first secret:
   - **Name:** `DOCKER_USERNAME`
   - **Value:** your Docker Hub username
   - Click **Add secret**
6. Click **New repository secret** again, add the second:
   - **Name:** `DOCKER_PASSWORD`
   - **Value:** your Docker Hub password *(or better — a [Docker Hub Access Token](https://hub.docker.com/settings/security), which is safer than your real password)*
   - Click **Add secret**

You should now see both `DOCKER_USERNAME` and `DOCKER_PASSWORD` listed (values hidden) under repository secrets.

> 💡 **Why an Access Token instead of your password?** Docker Hub lets you generate a token scoped only for pushing/pulling, which you can revoke anytime without changing your main password. Go to Docker Hub → Account Settings → Security → New Access Token.

---

## 🏃 Part D — Trigger the Pipeline

### Step 1 — Commit and push your changes

From your project folder (local machine):

```bash
git add .
git commit -m "Added Docker CI pipeline"
git push origin main
```

This push is what **triggers** the workflow — GitHub detects the push to `main` and automatically starts running `docker-ci.yml`.

### Step 2 — Watch it run

1. Go to your GitHub repository in the browser
2. Click the **Actions** tab (top menu)
3. You'll see your workflow run listed — click on it
4. Watch each step execute live: Checkout Code → Login to Docker Hub → Build Docker Image → Push Docker Image
5. A ✅ green checkmark means success; a ❌ red X means something failed (see troubleshooting below)

**📸 Screenshot this** — the successful green run is one of your required deliverables.

---

## 🔍 Part E — Validate the Image on Docker Hub

### Step 1 — Check Docker Hub

Go to [https://hub.docker.com](https://hub.docker.com), log in, and check your repositories — you should see `portfolio-website` listed with a recent "last pushed" timestamp.

**📸 Screenshot this too** — and copy the image link, e.g.:
```
https://hub.docker.com/r/YOUR_DOCKERHUB_USERNAME/portfolio-website
```

### Step 2 — Pull and run it anywhere (proof it actually works)

This is the real test — pull the image from Docker Hub on any machine (your EC2 VM is perfect for this) and confirm it runs:

```bash
docker pull YOUR_DOCKERHUB_USERNAME/portfolio-website:latest
docker run -d -p 80:80 YOUR_DOCKERHUB_USERNAME/portfolio-website:latest
```

If the site loads in your browser, your CI pipeline is fully working end-to-end.

---

## 📋 Deliverables Checklist

**Mandatory:**
- [ ] GitHub repository with the CI workflow (`.github/workflows/docker-ci.yml`)
- [ ] Screenshot of a successful GitHub Actions run (all green checkmarks)
- [ ] Docker Hub image link
- [ ] This README explaining the CI process

**Optional (bonus points):**
- [ ] Versioned Docker tags (e.g. `:v1`, `:v2` instead of just `:latest`)
- [ ] A CI status badge in your README (see below)

---

## 🏷️ Optional — Add a CI Status Badge

Add this to the top of your repo's main README to show a live "passing/failing" badge:

```markdown
![Docker CI](https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME/actions/workflows/docker-ci.yml/badge.svg)
```

Replace `YOUR_GITHUB_USERNAME` and `YOUR_REPO_NAME` with your actual values. This badge automatically turns green/red based on your latest pipeline run — a nice professional touch.

---

## ⚠️ Common Issues & Fixes

| Issue | Likely Cause | Fix |
|---|---|---|
| `Error: Username and password required` | Secrets not set or named incorrectly | Double-check secret names are exactly `DOCKER_USERNAME` and `DOCKER_PASSWORD` (case-sensitive) |
| `denied: requested access to the resource is denied` | Wrong Docker Hub password, or repo doesn't exist | Use an Access Token instead of your real password; verify username spelling |
| Workflow doesn't trigger at all | `.github/workflows/docker-ci.yml` not in the exact right path, or pushed to wrong branch | Confirm path is `.github/workflows/docker-ci.yml` exactly, and you pushed to `main` |
| `docker: command not found` (on runner) | Shouldn't happen — `ubuntu-latest` runners have Docker pre-installed | If it does, double check `runs-on: ubuntu-latest` is spelled correctly |
| Build succeeds but push fails | Login step failed silently, or network hiccup | Check the "Login to Docker Hub" step logs specifically for the real error |
| YAML syntax error / workflow won't even start | Indentation issue (YAML is whitespace-sensitive) | Copy the YAML exactly as given — don't use tabs, only spaces |

---

## 🧠 Key Concepts Recap

| Term | Meaning |
|---|---|
| **CI (Continuous Integration)** | Automatically building & testing code every time it changes |
| **CD (Continuous Deployment)** | Automatically *deploying* that build — not covered in this task yet |
| **GitHub Actions** | GitHub's built-in automation tool that runs workflows on events like `push` |
| **Workflow** | A YAML file defining what automated steps to run and when |
| **Runner** | The virtual machine (provided free by GitHub) that executes your workflow steps |
| **GitHub Secrets** | Encrypted variables GitHub injects into the workflow — keeps credentials out of your code |
| **Docker Hub** | A public registry to store and share Docker images, similar to GitHub but for containers |

---

## 🔗 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Docker Login GitHub Action](https://github.com/docker/login-action)
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com)

---

*Built by Tino Paul · CSE Student · tinopaul0808@gmail.com*
