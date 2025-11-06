# Fresh Admin Dashboard (Flutter Web)

Minimal Flutter **web** dashboard scaffold (no third‑party packages).

**Includes**: Login (mock/localStorage), Dashboard, Sidebar (NavigationRail/Drawer), Reports, Settings, and GitHub Pages CI.

## Run
```bash
flutter run -d chrome
```

## Build
```bash
flutter build web
```

## Deploy to GitHub Pages
1. Enable **Settings → Pages → Source = GitHub Actions**.
2. Keep `.github/workflows/web-only.yml` as-is.
3. Push to `main` and wait for the action to finish.
