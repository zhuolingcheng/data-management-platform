# Data Management Platform

This folder is ready for GitHub Pages deployment.

## Files

- `index.html`: default entry for GitHub Pages.
- `data-management-platform.html`: same dashboard page, kept for direct links.
- `xlsx.full.min.js`: Excel upload parser.
- `supabase-config.js`: Supabase project URL and publishable key.
- `consumption-detail-data.js`: empty placeholder. Real consumption data is loaded from Supabase after login.
- `direct-channel-mapping-data.js`: empty placeholder. Real mapping data is loaded from Supabase after login.

## Important

Do not upload the original large `consumption-detail-data.js` to a public GitHub repository because it contains business detail data.

## GitHub Pages

After uploading these files to the repository root:

1. Open repository `Settings`.
2. Open `Pages`.
3. Source: `Deploy from a branch`.
4. Branch: `main`, folder: `/root`.
5. Save and wait for GitHub Pages to publish.

Expected URL:

`https://zhuolingcheng.github.io/data-management-platform/`
