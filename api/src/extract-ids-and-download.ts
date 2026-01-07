// Extract real IDs from HTML and download detail pages
import * as cheerio from 'cheerio';
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
    const filePath = path.join(__dirname, 'fixtures', filename);
    fs.writeFileSync(filePath, html, 'utf-8');
    console.log(`✅ Downloaded: ${filename} (${html.length} bytes)`);
    return html;
  } catch (error) {
    console.error(`❌ Failed to download ${filename}:`, error);
    return '';
  }
}

async function main() {
  console.log('Extracting real IDs from existing HTML...\n');

  // Extract bangumi ID from search.html
  const searchHtml = fs.readFileSync(path.join(__dirname, 'fixtures/search.html'), 'utf-8');
  const $search = cheerio.load(searchHtml);
  const bangumiLink = $search('a[href*="/Home/Bangumi/"]').first();
  const bangumiId = bangumiLink.attr('href')?.match(/\/Home\/Bangumi\/(\d+)/)?.[1];
  console.log('Found bangumi ID:', bangumiId);

  // Extract episode ID from search.html
  const episodeLink = $search('a[href*="/Home/Episode/"]').first();
  const episodeId = episodeLink.attr('href')?.match(/\/Home\/Episode\/(\d+)/)?.[1];
  console.log('Found episode ID:', episodeId);

  if (bangumiId) {
    await downloadHtml(`${BASE_URL}/Home/Bangumi/${bangumiId}`, 'bangumi.html');
  }
  if (episodeId) {
    await downloadHtml(`${BASE_URL}/Home/Episode/${episodeId}`, 'episode.html');
  }

  console.log('\nDone!');
}

main();
