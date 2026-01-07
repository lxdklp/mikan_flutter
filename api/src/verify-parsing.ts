// Verify parsing results with real data
import * as cheerio from 'cheerio';
import MikanApi from './mikan';
import {
  indexHtml,
  seasonHtml,
  dayHtml,
  searchHtml,
  bangumiHtml,
  episodeHtml,
  listHtml,
  myBangumiHtml
} from './fixtures/html-samples';

function logSection(title: string) {
  console.log(`\n${'='.repeat(60)}`);
  console.log(`  ${title}`);
  console.log('='.repeat(60));
}

function verifyIndex() {
  logSection('parseIndex');
  const $ = cheerio.load(indexHtml);
  const result = (MikanApi as any)['parseIndex']($);

  console.log('Years:', result.years?.length || 0);
  if (result.years?.length) {
    console.log('  First year:', result.years[0]);
  }

  console.log('BangumiRows:', result.bangumiRows?.length || 0);
  if (result.bangumiRows?.length) {
    console.log('  First row name:', result.bangumiRows[0].name);
    console.log('  First row bangumis:', result.bangumiRows[0].bangumis?.length || 0);
    if (result.bangumiRows[0].bangumis?.length) {
      console.log('    First bangumi:', {
        id: result.bangumiRows[0].bangumis[0].id,
        name: result.bangumiRows[0].bangumis[0].name,
        num: result.bangumiRows[0].bangumis[0].num
      });
    }
  }

  console.log('RSS (Day):', result.rss?.length || 0);
  if (result.rss?.length) {
    console.log('  First RSS:', result.rss[0]);
  }

  console.log('Carousels:', result.carousels?.length || 0);
  if (result.carousels?.length) {
    console.log('  First carousel:', {
      id: result.carousels[0].id,
      name: result.carousels[0].name
    });
  }

  console.log('User:', result.user ? 'Found' : 'Not found');
  console.log('Announcements:', result.announcements?.length || 0);
}

function verifySeason() {
  logSection('parseSeason');
  const $ = cheerio.load(seasonHtml);
  const result = (MikanApi as any)['parseSeason']($);

  console.log('Total rows (days of week):', result.length);
  if (result.length) {
    console.log('  First row name:', result[0].name);
    console.log('  First row bangumis:', result[0].bangumis?.length || 0);
    if (result[0].bangumis?.length) {
      console.log('    First bangumi:', {
        id: result[0].bangumis[0].id,
        name: result[0].bangumis[0].name,
        num: result[0].bangumis[0].num
      });
    }
  }
}

function verifyDay() {
  logSection('parseDay');
  const $ = cheerio.load(dayHtml);
  const result = (MikanApi as any)['parseDay']($);

  console.log('Records:', result.length);
  if (result.length) {
    console.log('  First record:', {
      title: result[0].title,
      publishAt: result[0].publishAt
    });
  }
}

function verifySearch() {
  logSection('parseSearch');
  const $ = cheerio.load(searchHtml);
  const result = (MikanApi as any)['parseSearch']($);

  console.log('Bangumis:', result.bangumis?.length || 0);
  if (result.bangumis?.length) {
    console.log('  First bangumi:', {
      id: result.bangumis[0].id,
      name: result.bangumis[0].name
    });
  }

  console.log('Subgroups:', result.subgroups?.length || 0);
  if (result.subgroups?.length) {
    console.log('  First subgroup:', {
      name: result.subgroups[0].name,
      count: result.subgroups[0].count
    });
  }

  console.log('Records:', result.records?.length || 0);
  if (result.records?.length) {
    console.log('  First record:', {
      title: result.records[0].title,
      team: result.records[0].team
    });
  }
}

function verifyBangumi() {
  logSection('parseBangumi');
  const $ = cheerio.load(bangumiHtml);
  const result = (MikanApi as any)['parseBangumi']($);

  console.log('ID:', result.id);
  console.log('Name:', result.name);
  console.log('Intro:', result.intro?.substring(0, 50) + '...');
  console.log('Subscribed:', result.subscribed);
  console.log('More info:', Object.keys(result.more || {}).length);
  console.log('SubgroupBangumis:', Object.keys(result.subgroupBangumis || {}).length);
}

function verifyRecordDetail() {
  logSection('parseRecordDetail');
  const $ = cheerio.load(episodeHtml);
  const result = (MikanApi as any)['parseRecordDetail']($);

  console.log('ID:', result.id || '(empty - episode page has no bangumi ID)');
  console.log('Name:', result.name || '(empty - episode page has no bangumi name)');
  console.log('Title:', result.title?.substring(0, 50) + '...');
  console.log('Cover:', result.cover?.substring(0, 50) + '...');
  console.log('Magnet:', result.magnet?.substring(0, 30) + '...');
  console.log('Torrent:', result.torrent?.substring(0, 50) + '...');
  console.log('Tags:', result.tags);
  console.log('Subscribed:', result.subscribed);
  console.log('More info keys:', Object.keys(result.more || {}).length);
  console.log('Intro length:', result.intro?.length || 0);
}

function verifyList() {
  logSection('parseList');
  const $ = cheerio.load(listHtml);
  const result = (MikanApi as any)['parseList']($);

  console.log('Records:', result.length);
  if (result.length) {
    console.log('  First record:', {
      title: result[0].title,
      publishAt: result[0].publishAt,
      team: result[0].team
    });
  }
}

function verifyMySubscribed() {
  logSection('parseMySubscribed');
  const $ = cheerio.load(myBangumiHtml);
  const result = (MikanApi as any)['parseMySubscribed']($);

  console.log('Subscribed bangumis:', result.length);
  if (result.length) {
    console.log('  First bangumi:', {
      id: result[0].id,
      name: result[0].name,
      episode: result[0].episode
    });
  }
}

async function main() {
  console.log('Verifying all parsing methods with real HTML...\n');

  verifyIndex();
  verifySeason();
  verifyDay();
  verifySearch();
  verifyBangumi();
  verifyRecordDetail();
  verifyList();
  verifyMySubscribed();

  console.log('\n' + '='.repeat(60));
  console.log('  Verification complete!');
  console.log('='.repeat(60) + '\n');
}

main();
