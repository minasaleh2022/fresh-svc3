# Fresh Admin Web (Flutter)

**Login:** `admin@fresh.dev` / `123456`

## Local run
```bash
cd apps/admin_web
flutter pub get
flutter run -d chrome
```

## Build web
```bash
cd apps/admin_web
flutter build web --release --base-href "/fresh-svc3/"
```

## Deploy on GitHub
- Keep the workflow at `.github/workflows/web-only.yml`
- In repo **Settings → Pages**, set **Source = GitHub Actions**.
