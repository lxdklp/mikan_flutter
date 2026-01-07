import { describe, it, expect, beforeEach, vi } from 'vitest';
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

// Mock fetch globally
global.fetch = vi.fn();

describe('MikanApi - Real HTML Integration Tests', () => {
  beforeEach(() => {
    MikanApi.setBaseUrl('https://mikanani.me');
  });

  describe('parseIndex with real HTML', () => {
    it('should parse index page without errors', () => {
      const $ = cheerio.load(indexHtml);
      const result = () => (MikanApi as any)['parseIndex']($);

      expect(() => result()).not.toThrow();
    });

    it('should extract years from index page', () => {
      const $ = cheerio.load(indexHtml);
      const result = (MikanApi as any)['parseYearSeason']($);

      expect(Array.isArray(result)).toBe(true);
    });

    it('should extract bangumi rows from index page', () => {
      const $ = cheerio.load(indexHtml);
      const result = (MikanApi as any)['parseSeason']($);

      expect(Array.isArray(result)).toBe(true);
    });
  });

  describe('parseSeason with real HTML', () => {
    it('should parse season page without errors', () => {
      const $ = cheerio.load(seasonHtml);
      const result = () => (MikanApi as any)['parseSeason']($);

      expect(() => result()).not.toThrow();
    });

    it('should return array of bangumi rows', () => {
      const $ = cheerio.load(seasonHtml);
      const result = (MikanApi as any)['parseSeason']($);

      expect(Array.isArray(result)).toBe(true);
    });
  });

  describe('parseDay with real HTML', () => {
    it('should handle empty day page', () => {
      const $ = cheerio.load(dayHtml);
      const result = (MikanApi as any)['parseDay']($);

      expect(Array.isArray(result)).toBe(true);
    });
  });

  describe('parseSearch with real HTML', () => {
    it('should parse search page without errors', () => {
      const $ = cheerio.load(searchHtml);
      const result = () => (MikanApi as any)['parseSearch']($);

      expect(() => result()).not.toThrow();
    });

    it('should return search result structure', () => {
      const $ = cheerio.load(searchHtml);
      const result = (MikanApi as any)['parseSearch']($);

      expect(result).toHaveProperty('bangumis');
      expect(result).toHaveProperty('subgroups');
      expect(result).toHaveProperty('records');
    });
  });

  describe('parseBangumi with real HTML', () => {
    it('should parse bangumi detail page without errors', () => {
      const $ = cheerio.load(bangumiHtml);
      const result = () => (MikanApi as any)['parseBangumi']($);

      expect(() => result()).not.toThrow();
    });

    it('should return bangumi detail structure', () => {
      const $ = cheerio.load(bangumiHtml);
      const result = (MikanApi as any)['parseBangumi']($);

      expect(result).toHaveProperty('id');
      expect(result).toHaveProperty('name');
      expect(result).toHaveProperty('subgroupBangumis');
    });
  });

  describe('parseRecordDetail with real HTML', () => {
    it('should parse episode detail page without errors', () => {
      const $ = cheerio.load(episodeHtml);
      const result = () => (MikanApi as any)['parseRecordDetail']($);

      expect(() => result()).not.toThrow();
    });

    it('should return record detail structure', () => {
      const $ = cheerio.load(episodeHtml);
      const result = (MikanApi as any)['parseRecordDetail']($);

      expect(result).toHaveProperty('id');
      expect(result).toHaveProperty('name');
    });
  });

  describe('parseList with real HTML', () => {
    it('should parse list page without errors', () => {
      const $ = cheerio.load(listHtml);
      const result = () => (MikanApi as any)['parseList']($);

      expect(() => result()).not.toThrow();
    });

    it('should return array of records', () => {
      const $ = cheerio.load(listHtml);
      const result = (MikanApi as any)['parseList']($);

      expect(Array.isArray(result)).toBe(true);
    });
  });

  describe('parseMySubscribed with real HTML', () => {
    it('should parse subscription page without errors', () => {
      const $ = cheerio.load(myBangumiHtml);
      const result = () => (MikanApi as any)['parseMySubscribed']($);

      expect(() => result()).not.toThrow();
    });

    it('should return array of subscribed bangumi', () => {
      const $ = cheerio.load(myBangumiHtml);
      const result = (MikanApi as any)['parseMySubscribed']($);

      expect(Array.isArray(result)).toBe(true);
    });

    it('should parse subscribed bangumi with correct structure', () => {
      const $ = cheerio.load(myBangumiHtml);
      const result = (MikanApi as any)['parseMySubscribed']($);

      if (result.length > 0) {
        const first = result[0];
        expect(first).toHaveProperty('id');
        expect(first).toHaveProperty('name');
        expect(first).toHaveProperty('cover');
        expect(first).toHaveProperty('subscribed');
        expect(first).toHaveProperty('updateAt');
        expect(first.subscribed).toBe(true);
      }
    });
  });
});
