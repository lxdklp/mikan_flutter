// Data Models

export interface Bangumi {
  id: string;
  cover: string;
  name: string;
  subscribed: boolean;
  grey: boolean;
  num?: number;
  updateAt: string;
  week: string;
}

export interface BangumiRow {
  name: string;
  sname: string;
  num: number;
  updatedNum: number;
  subscribedNum: number;
  subscribedUpdatedNum: number;
  bangumis: Bangumi[];
}

export interface RecordItem {
  id?: string;
  name?: string;
  cover?: string;
  title?: string;
  publishAt?: string;
  groups?: Subgroup[];
  url?: string;
  magnet?: string;
  size?: string;
  torrent?: string;
  tags?: string[];
}

export interface Subgroup {
  id?: string;
  name: string;
}

export interface User {
  name?: string;
  avatar?: string;
  token?: string;
  rss?: string;
}

export interface SearchResult {
  bangumis: Bangumi[];
  subgroups: Subgroup[];
  records: RecordItem[];
}

export interface SeasonGallery {
  year: string;
  season: string;
  title: string;
  active: boolean;
  bangumis: Bangumi[];
}

export interface BangumiDetail {
  id: string;
  cover: string;
  name: string;
  intro: string;
  subscribed: boolean;
  more: Record<string, string>;
  subgroupBangumis: Record<string, SubgroupBangumi>;
}

export interface SubgroupBangumi {
  dataId: string;
  name: string;
  subscribed: boolean;
  sublang?: string;
  rss?: string;
  state: number;
  subgroups: Subgroup[];
  records: RecordItem[];
}

export interface Carousel {
  id: string;
  cover: string;
}

export interface YearSeason {
  year: string;
  seasons: Season[];
}

export interface Season {
  year: string;
  season: string;
  title: string;
  active: boolean;
}

export interface AnnouncementNode {
  text: string;
  type?: string;
  place?: string;
}

export interface Announcement {
  date: string;
  nodes: AnnouncementNode[];
}

export interface RecordDetail {
  id?: string;
  cover?: string;
  name?: string;
  title?: string;
  tags?: string[];
  subscribed?: boolean;
  more?: Record<string, string>;
  intro?: string;
  torrent?: string;
  magnet?: string;
}

export interface Index {
  years: YearSeason[];
  bangumiRows: BangumiRow[];
  rss: Record<string, RecordItem[]>;
  carousels: Carousel[];
  user?: User;
  announcements?: Announcement[];
}

// FJS Bridge types
export interface BridgeCallAction {
  action: 'saveCookie' | 'getCookies' | 'loadCookies';
  domain?: string;
  cookie?: { name: string; value: string };
}

declare global {
  const fjs: {
    bridge_call: (action: BridgeCallAction) => any;
  };
}

export {};
