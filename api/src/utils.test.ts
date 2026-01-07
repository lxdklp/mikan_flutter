import { describe, it, expect } from 'vitest';
import { formatPublishAt, parseTagsAndTitle } from './utils';

describe('formatPublishAt', () => {
  it('should format valid date correctly', () => {
    const result = formatPublishAt('2024/03/15 18:30');
    expect(result).toBe('3月15日周五 18:30');
  });

  it('should handle Monday', () => {
    const result = formatPublishAt('2024/03/11 18:30');
    expect(result).toBe('3月11日周一 18:30');
  });

  it('should handle Sunday', () => {
    const result = formatPublishAt('2024/03/10 18:30');
    expect(result).toBe('3月10日周日 18:30');
  });

  it('should return original string for invalid date', () => {
    const result = formatPublishAt('invalid-date');
    expect(result).toBe('invalid-date');
  });

  it('should handle empty string', () => {
    const result = formatPublishAt('');
    expect(result).toBe('');
  });

  it('should handle different time formats', () => {
    const result = formatPublishAt('2024/03/15 08:05');
    expect(result).toBe('3月15日周五 08:05');
  });

  it('should handle late night hours', () => {
    const result = formatPublishAt('2024/03/15 23:59');
    expect(result).toBe('3月15日周五 23:59');
  });

  it('should handle leap year dates', () => {
    const result = formatPublishAt('2024/02/29 12:00');
    expect(result).toBe('2月29日周四 12:00');
  });
});

describe('parseTagsAndTitle', () => {
  it('should extract big5 and 繁体 tags', () => {
    const result = parseTagsAndTitle('[big5][繁体]字幕组 番剧名称 - 01');
    expect(result.title).toBe('[big5][繁体]字幕组 番剧名称 - 01');
    expect(result.tags).toContain('繁');
  });

  it('should extract mp4 tag', () => {
    const result = parseTagsAndTitle('[mp4]测试内容');
    expect(result.title).toBe('[mp4]测试内容');
    expect(result.tags).toContain('MP4');
  });

  it('should handle no known tags', () => {
    const result = parseTagsAndTitle('纯标题内容');
    expect(result.title).toBe('纯标题内容');
    expect(result.tags).toEqual([]);
  });

  it('should handle empty string', () => {
    const result = parseTagsAndTitle('');
    expect(result.title).toBe('');
    expect(result.tags).toEqual([]);
  });

  it('should extract 1080p and x265 tags', () => {
    const result = parseTagsAndTitle('[1080p][x265]动画名称');
    expect(result.title).toBe('[1080p][x265]动画名称');
    expect(result.tags).toContain('1080P');
    expect(result.tags).toContain('x265');
  });

  it('should convert bracket styles', () => {
    const result = parseTagsAndTitle('【繁体】【简体】测试番剧');
    expect(result.title).toBe('[繁体][简体]测试番剧');
    expect(result.tags).toContain('繁');
    expect(result.tags).toContain('简');
  });

  it('should extract HEVC tag', () => {
    const result = parseTagsAndTitle('[hevc]测试视频');
    expect(result.tags).toContain('HEVC');
  });

  it('should extract multiple video quality tags', () => {
    const result = parseTagsAndTitle('[720p][1080p][x264]视频名称');
    expect(result.tags).toContain('720P');
    expect(result.tags).toContain('1080P');
    expect(result.tags).toContain('x264');
  });

  it('should handle 4K resolution tags', () => {
    const result = parseTagsAndTitle('[4k][2160p]测试内容');
    expect(result.tags).toContain('4K');
  });

  it('should extract audio codec tags', () => {
    const result = parseTagsAndTitle('[aac][flac]音频测试');
    expect(result.tags).toContain('AAC');
    expect(result.tags).toContain('FLAC');
  });

  it('should handle subtitle language tags', () => {
    const result = parseTagsAndTitle('[chs][cht][双语]字幕测试');
    expect(result.tags).toContain('简');
    expect(result.tags).toContain('繁');
    expect(result.tags).toContain('双语');
  });
});
