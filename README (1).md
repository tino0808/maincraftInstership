# Tino Paul — Portfolio Website
> Static portfolio hosted on AWS S3 and served via CloudFront (HTTPS)

🌐 **Live URL:** `https://your-cloudfront-domain.cloudfront.net` *(update after deployment)*

---

## 📁 Project Structure

```
portfolio/
├── index.html      # Main single-page portfolio
├── styles.css      # All styling (responsive, dark theme)
└── README.md       # This file
```

---

## 🛠️ Tech Stack

| Layer      | Technology                          |
|------------|-------------------------------------|
| Frontend   | HTML5, CSS3, FontAwesome, Google Fonts |
| Hosting    | AWS S3 (Static Website Hosting)     |
| CDN + HTTPS| AWS CloudFront                      |
| Version Control | Git + GitHub                   |

---

## 🚀 Deployment Steps

### Step 1 — Create GitHub Repo & Push Code

```bash
git init
git add .
git commit -m "Initial portfolio commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

---

### Step 2 — Create AWS Account

1. Go to [https://aws.amazon.com/free/](https://aws.amazon.com/free/)
2. Sign up with email — the Free Tier is enough for this project
3. Log in to the **AWS Console**

---

### Step 3 — Create S3 Bucket

1. Go to **S3** in the AWS Console
2. Click **"Create bucket"**
3. Bucket name: `tinopaul-portfolio` *(must be globally unique)*
4. Region: choose closest to you (e.g., `ap-south-1` for India)
5. **Uncheck** "Block all public access" → confirm the warning
6. Click **"Create bucket"**

---

### Step 4 — Enable Static Website Hosting

1. Open your bucket → go to **Properties** tab
2. Scroll to **"Static website hosting"** → click **Edit**
3. Enable it → set **Index document:** `index.html`
4. Save changes
5. Note the **Bucket website endpoint** URL (for testing)

---

### Step 5 — Add Bucket Policy (Allow Public Read)

1. Go to **Permissions** tab → **Bucket policy** → Edit
2. Paste this JSON (replace `tinopaul-portfolio` with your bucket name):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::tinopaul-portfolio/*"
    }
  ]
}
```

3. Save changes

---

### Step 6 — Upload Files to S3

**Option A — Using AWS Console (Beginner Friendly):**
1. Go to your bucket → click **Upload**
2. Add `index.html` and `styles.css`
3. Click **Upload**

**Option B — Using AWS CLI:**
```bash
# Install AWS CLI first: https://aws.amazon.com/cli/
aws configure   # enter your Access Key, Secret, region

# Sync all files to S3
aws s3 sync . s3://tinopaul-portfolio --acl public-read
```

---

### Step 7 — Test S3 Endpoint

Visit your S3 website URL (from Step 4). It should look like:
```
http://tinopaul-portfolio.s3-website.ap-south-1.amazonaws.com
```
✅ If you see the portfolio — S3 is working!

---

### Step 8 — Create CloudFront Distribution (HTTPS)

1. Go to **CloudFront** in AWS Console
2. Click **"Create distribution"**
3. **Origin domain:** paste your S3 **website endpoint** (not the S3 bucket URL) — it should end in `.s3-website.region.amazonaws.com`
4. **Viewer protocol policy:** select **"Redirect HTTP to HTTPS"**
5. **Minimum TLS version:** TLSv1.2
6. Default root object: `index.html`
7. Click **"Create distribution"**
8. Wait ~5–10 minutes for deployment to finish

---

### Step 9 — Verify Live HTTPS URL

Your CloudFront domain will look like:
```
https://d1234abcdef.cloudfront.net
```
✅ Open it in browser — your portfolio is live on HTTPS! 🎉

---

## 📸 Screenshots to Include in Submission

- [ ] CloudFront distribution status showing **"Enabled"**
- [ ] S3 bucket policy JSON
- [ ] S3 static website hosting enabled
- [ ] Live portfolio in browser at CloudFront URL

---

## 📌 Helpful CLI Reference

```bash
# Upload/sync files to S3
aws s3 sync . s3://tinopaul-portfolio --acl public-read

# Apply bucket policy from file
aws s3api put-bucket-policy --bucket tinopaul-portfolio --policy file://policy.json

# Invalidate CloudFront cache after updates
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
```

---

## 🔗 Resources

- [AWS S3 Static Hosting Docs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
- [AWS Free Tier](https://aws.amazon.com/free/)

---

*Built by Tino Paul · CSE Student · tinopaul0808@gmail.com*
