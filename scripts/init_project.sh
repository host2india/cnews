#!/bin/bash
set -e

echo "======================================"
echo " 🚀 SaaS Command Core – Project Init"
echo "======================================"
echo ""

read -p "Project Name (e.g. C-NEWS): " PROJECT_NAME
read -p "Project Slug (e.g. cnews): " PROJECT_SLUG
read -p "Primary Domain (e.g. demo.example.com): " PRIMARY_DOMAIN

if [ -z "$PROJECT_NAME" ] || [ -z "$PROJECT_SLUG" ]; then
  echo "❌ Project name and slug are required"
  exit 1
fi

echo ""
echo "Initializing project: $PROJECT_NAME"
echo "--------------------------------------"

ROOT_DIR=$(pwd)
TARGET_DIR="../$PROJECT_SLUG"

if [ -d "$TARGET_DIR" ]; then
  echo "❌ Target directory already exists: $TARGET_DIR"
  exit 1
fi

echo "📁 Creating project directory..."
cp -R "$ROOT_DIR" "$TARGET_DIR"
cd "$TARGET_DIR"

echo "🧹 Removing template git history..."
rm -rf .git

echo "✏️ Replacing placeholders..."

grep -rl "C-NEWS" . | xargs sed -i "s/C-NEWS/$PROJECT_NAME/g"
grep -rl "cnews" . | xargs sed -i "s/cnews/$PROJECT_SLUG/g"
grep -rl "cnews.demo.local" . | xargs sed -i "s/cnews.demo.local/$PRIMARY_DOMAIN/g"

if [ ! -f ".env" ]; then
  cp .env.example .env 2>/dev/null || true
fi

sed -i "s|APP_NAME=.*|APP_NAME=\"$PROJECT_NAME\"|g" .env 2>/dev/null || true
sed -i "s|APP_SLUG=.*|APP_SLUG=\"$PROJECT_SLUG\"|g" .env 2>/dev/null || true
sed -i "s|APP_DOMAIN=.*|APP_DOMAIN=\"$PRIMARY_DOMAIN\"|g" .env 2>/dev/null || true

echo "🔧 Initializing new git repository..."
git init
git add .
git commit -m "Initial commit for $PROJECT_NAME"

echo ""
echo "✅ Project successfully initialized!"
echo ""
echo "📌 Next Steps:"
echo "1️⃣ Review docs/PHASE-0-FRAMING.md"
echo "2️⃣ Customize README.md"
echo "3️⃣ Build MVP UI in frontend/public/index.html"
echo "4️⃣ Run demo in browser"
echo ""
echo "🚀 Happy building, Captain."
