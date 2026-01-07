// Utility Functions
import dayjs from 'dayjs';
import weekday from 'dayjs/plugin/weekday';

dayjs.extend(weekday);

export function trim(v: unknown): string {
  return typeof v === 'string' ? v.trim() : String(v);
}

export function isBlank(v: unknown): boolean {
  return v === null || v === undefined || (typeof v === 'string' && v.trim() === '');
}

const keywords: Record<string, string> = {
  '720p': '720P',
  '1080p': '1080P',
  '480p': '480P',
  'big5': '繁',
  'mp4': 'MP4',
  'mkv': 'MKV',
  'hevc': 'HEVC',
  '简日': '简日',
  '双语': '双语',
  'chs': '简',
  'gb': '简',
  'web-dl': 'WEB-DL',
  'avc': 'AVC',
  '繁体': '繁',
  'cht': '繁',
  '简体': '简',
  '合集': '合集',
  '内封': '内嵌',
  '内挂': '内嵌',
  '内嵌': '内嵌',
  '繁日': '繁日',
  '10bit': '10bit',
  '外挂': '外挂',
  '简繁': '简繁',
  '搬运': '搬运',
  '简中': '简中',
  '繁中': '繁中',
  '国漫': '国漫',
  'x264': 'x264',
  'x265': 'x265',
  'dvdrip': 'DVDRip',
  '8bit': '8bit',
  'aac': 'AAC',
  'flac': 'FLAC',
  '粤语': '粤语',
  'tvb': 'TVB',
  'srt': 'SRT',
  '2160p': '2160P',
  'web-rip': 'WEB-Rip',
  'webrip': 'WEB-Rip',
  'opusx2': 'OPUSx2',
  'opusx3': 'OPUSx3',
  'opus': 'OPUS',
  'opus 5.1': 'OPUS 5.1',
  'h264': 'H264',
  'h.264': 'H264',
  'h.265': 'HEVC',
  'ova': 'OVA',
  'bd': 'BD',
  'bdrip': 'BDrip',
  '无修版': '无修版',
  '无修正': '无修正',
  '怀旧老番': '怀旧老番',
  '剧场版': '剧场版',
  'tvrip': 'TVrip',
  '国语': '国语',
  '60fps': '60FPS',
  'sp': 'SP',
  'hdr': 'HDR',
  'ost': 'OST',
  'oad': 'OAD',
  'movie': 'Movie',
  'ac3': 'AC3',
  'hdtv-rip': 'HDTV-Rip',
  '3840x2160': '4K',
  '4k': '4K',
  'truehd': 'TrueHD',
  'main10p': 'Main10P',
  'yuv420p8': 'YUV420P8',
  '重制版': '重制版',
  '50fps': '50FPS',
  'tv未放送': 'TV未放送',
  '特别篇': '特别篇',
  '网盘': '网盘',
  '網盤': '网盘',
  'baha': '巴哈',
  '1920x1080': '1080P',
  '1280x720': '720P',
  'ass': 'ASS',
};

const weekSectionNames: Record<string, string> = {
  '星期一': '星期一',
  '星期二': '星期二',
  '星期三': '星期三',
  '星期四': '星期四',
  '星期五': '星期五',
  '星期六': '星期六',
  '星期日': '星期日',
  '月': '星期一',
  '火': '星期二',
  '水': '星期三',
  '木': '星期四',
  '金': '星期五',
  '土': '星期六',
  '日': '星期日',
  '剧场版': '剧场版',
  '剧': '剧场版',
  'ova': 'OVA',
  'o': 'OVA',
};

export { weekSectionNames };

export function formatPublishAt(dateStr: string): string {
  if (!dateStr) return dateStr;

  const date = dayjs(dateStr, 'YYYY/MM/DD HH:mm');
  if (!date.isValid()) return dateStr;

  const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  const weekday = weekdays[date.day()];

  return `${date.format('M月D日')}${weekday} ${date.format('HH:mm')}`;
}

export function parseTagsAndTitle(text: string): { title: string; tags: string[] } {
  let temp = text.replace(/【/g, '[').replace(/】/g, ']');
  const tags = new Set<string>();
  const lower = temp.toLowerCase();
  for (const [k, v] of Object.entries(keywords)) {
    if (lower.includes(k)) tags.add(v);
  }
  return {
    title: temp,
    tags: Array.from(tags).sort((a, b) => b.localeCompare(a)),
  };
}

export function getWeekSectionName(name: string): string {
  return weekSectionNames[name] || name;
}
