// Download real HTML from Mikan for testing
import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const BASE_URL = 'https://mikanani.me';

async function downloadHtml(url: string, filename: string) {
  try {
    const headers: Record<string, string> = {};
    headers['user-agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36 MikanProject/1.0.0';

    const response = await fetch(url, { headers });

    if (!response.ok) {
      throw new Error(`Failed to fetch ${url}: ${response.status}`);
    }

    const html = await response.text();
    const filePath = path.join(__dirname, filename);
    fs.writeFileSync(filePath, html, 'utf-8');
    console.log(`✅ Downloaded: ${filename} (${html.length} bytes)`);
  } catch (error) {
    console.error(`❌ Failed to download ${filename}:`, error);
  }
}

async function downloadHtmlWithAuth(url: string, filename: string, cookie: string) {
  try {
    const headers: Record<string, string> = {};
    headers['user-agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36 MikanProject/1.0.0';
    headers['cookie'] = cookie;

    const response = await fetch(url, { headers });

    if (!response.ok) {
      throw new Error(`Failed to fetch ${url}: ${response.status}`);
    }

    const html = await response.text();
    const filePath = path.join(__dirname, filename);
    fs.writeFileSync(filePath, html, 'utf-8');
    console.log(`✅ Downloaded (auth): ${filename} (${html.length} bytes)`);
  } catch (error) {
    console.error(`❌ Failed to download ${filename}:`, error);
  }
}

async function main(cookie?: string) {
  console.log('Downloading real HTML fixtures from Mikan...');

  // Public pages
  await downloadHtml(BASE_URL, 'index.html');
  await downloadHtml(`${BASE_URL}/Home/BangumiCoverFlowByDayOfWeek?year=2024&seasonStr=03`, 'season.html');
  await downloadHtml(`${BASE_URL}/Home/EpisodeUpdateRows?predate=0&enddate=1`, 'day.html');
  await downloadHtml(`${BASE_URL}/Home/Search?searchstr=test`, 'search.html');
  await downloadHtml(`${BASE_URL}/Home/Bangumi/123`, 'bangumi.html');
  await downloadHtml(`${BASE_URL}/Home/Episode/456`, 'episode.html');
  await downloadHtml(`${BASE_URL}/Home/Classic/1`, 'list.html');

  // Authenticated pages (requires cookie)
  if (cookie) {
    console.log('\nDownloading authenticated pages...');
    await downloadHtmlWithAuth(`${BASE_URL}/Home/MyBangumi`, 'my-bangumi.html', cookie);
  }

  console.log('\nDone!');
}

// Get cookie from command line argument: pnpm run download-fixtures -- "cookie_here"
const cookie = process.argv[2];
main(cookie);
