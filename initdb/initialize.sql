CREATE DATABASE gtfs_jp;

\c gtfs_jp

CREATE TABLE agency (
  agency_id VARCHAR(64) PRIMARY KEY,
  agency_name TEXT NOT NULL,
  agency_url TEXT NOT NULL,
  agency_timezone VARCHAR(16) NOT NULL DEFAULT 'Asia/Tokyo',
  agency_lang VARCHAR(8) NOT NULL DEFAULT 'ja',
  agency_phone VARCHAR(32),
  agency_fare_url TEXT,
  agency_email TEXT
);
COMMENT ON TABLE agency IS '事業者情報';
COMMENT ON COLUMN agency.agency_id IS '事業者ID';
COMMENT ON COLUMN agency.agency_name IS '事業者名称';
COMMENT ON COLUMN agency.agency_url IS '事業者URL';
COMMENT ON COLUMN agency.agency_timezone IS '【固定】タイムゾーン';
COMMENT ON COLUMN agency.agency_lang IS '【固定】言語';
COMMENT ON COLUMN agency.agency_phone IS '電話番号';
COMMENT ON COLUMN agency.agency_fare_url IS 'オンライン購入URL';
COMMENT ON COLUMN agency.agency_email IS '事業者Eメール';

CREATE TABLE agency_jp (
  agency_id VARCHAR(64) PRIMARY KEY,
  agency_official_name TEXT,
  agency_zip_number VARCHAR(7),
  agency_address TEXT,
  agency_president_pos TEXT,
  agency_president_name TEXT
);
ALTER TABLE agency_jp ADD FOREIGN KEY (agency_id) REFERENCES agency (agency_id);
COMMENT ON TABLE agency_jp IS '事業者追加情報';
COMMENT ON COLUMN agency_jp.agency_id IS '事業者ID';
COMMENT ON COLUMN agency_jp.agency_official_name IS '事業者正式名称';
COMMENT ON COLUMN agency_jp.agency_zip_number IS '事業者郵便番号';
COMMENT ON COLUMN agency_jp.agency_address IS '事業者住所';
COMMENT ON COLUMN agency_jp.agency_president_pos IS '代表者肩書';
COMMENT ON COLUMN agency_jp.agency_president_name IS '代表者氏名';

CREATE TABLE stops (
  stop_id VARCHAR(64) PRIMARY KEY,
  stop_code VARCHAR(64),
  stop_name TEXT NOT NULL,
  stop_desc TEXT,
  stop_lat DOUBLE PRECISION NOT NULL,
  stop_lon DOUBLE PRECISION NOT NULL,
  zone_id VARCHAR(64),
  stop_url TEXT,
  location_type SMALLINT NOT NULL CHECK (location_type IN (0, 1)),
  parent_station VARCHAR(64),
  stop_timezone VARCHAR(16),
  wheelchair_boarding TEXT,
  platform_code VARCHAR(64)
);
COMMENT ON TABLE stops IS '停留所・標柱情報';
COMMENT ON COLUMN stops.stop_id IS '停留所・標柱ID';
COMMENT ON COLUMN stops.stop_code IS '停留所・標柱番号';
COMMENT ON COLUMN stops.stop_name IS '停留所・標柱名称';
COMMENT ON COLUMN stops.stop_desc IS '停留所・標柱付加情報';
COMMENT ON COLUMN stops.stop_lat IS '緯度';
COMMENT ON COLUMN stops.stop_lon IS '経度';
COMMENT ON COLUMN stops.zone_id IS '運賃エリアID';
COMMENT ON COLUMN stops.stop_url IS '停留所・標柱URL';
COMMENT ON COLUMN stops.location_type IS '停留所・標柱区分';
COMMENT ON COLUMN stops.parent_station IS '親停留所情報';
COMMENT ON COLUMN stops.stop_timezone IS '【設定不要】タイムゾーン';
COMMENT ON COLUMN stops.wheelchair_boarding IS '【設定不要】車椅子情報';
COMMENT ON COLUMN stops.platform_code IS 'のりば情報';

CREATE TABLE routes (
  route_id VARCHAR(64) PRIMARY KEY,
  agency_id VARCHAR(64) NOT NULL,
  route_short_name VARCHAR(64),
  route_long_name TEXT,
  route_desc TEXT,
  route_type SMALLINT NOT NULL DEFAULT 3,
  route_url TEXT,
  route_color VARCHAR(6),
  route_text_color VARCHAR(6),
  jp_parent_route_id VARCHAR(64)
);
ALTER TABLE routes ADD FOREIGN KEY (agency_id) REFERENCES agency (agency_id);
COMMENT ON TABLE routes IS '経路情報';
COMMENT ON COLUMN routes.route_id IS '経路ID';
COMMENT ON COLUMN routes.agency_id IS '事業者ID';
COMMENT ON COLUMN routes.route_short_name IS '経路略称';
COMMENT ON COLUMN routes.route_long_name IS '経路名';
COMMENT ON COLUMN routes.route_desc IS '経路情報';
COMMENT ON COLUMN routes.route_type IS '【固定】経路タイプ';
COMMENT ON COLUMN routes.route_url IS '経路URL';
COMMENT ON COLUMN routes.route_color IS '経路色';
COMMENT ON COLUMN routes.route_text_color IS '経路文字色';
COMMENT ON COLUMN routes.jp_parent_route_id IS '方面・路線ID';

CREATE TABLE shapes (
  shape_id VARCHAR(64) NOT NULL PRIMARY KEY,
  shape_pt_lat DOUBLE PRECISION NOT NULL,
  shape_pt_lon DOUBLE PRECISION NOT NULL,
  shape_pt_sequence INTEGER NOT NULL,
  shape_dist_traveled DOUBLE PRECISION
);
COMMENT ON TABLE shapes IS '描画情報';
COMMENT ON COLUMN shapes.shape_id IS '描画ID';
COMMENT ON COLUMN shapes.shape_pt_lat IS '描画緯度';
COMMENT ON COLUMN shapes.shape_pt_lon IS '描画経度';
COMMENT ON COLUMN shapes.shape_pt_sequence IS '描画順序';
COMMENT ON COLUMN shapes.shape_dist_traveled IS '【設定不要】描画距離';

CREATE TABLE office_jp (
  office_id VARCHAR(64) PRIMARY KEY,
  office_name TEXT NOT NULL,
  office_url TEXT,
  office_phone VARCHAR(32)
);
COMMENT ON TABLE office_jp IS '営業所情報';
COMMENT ON COLUMN office_jp.office_id IS '営業所ID';
COMMENT ON COLUMN office_jp.office_name IS '営業所名';
COMMENT ON COLUMN office_jp.office_url IS '営業所URL';
COMMENT ON COLUMN office_jp.office_phone IS '営業所電話番号';

CREATE TABLE pattern_jp (
  jp_pattern_id VARCHAR(64) PRIMARY KEY,
  route_update_date VARCHAR(8),
  origin_stop VARCHAR(64),
  via_stop VARCHAR(64),
  destination_stop VARCHAR(64)
);
COMMENT ON TABLE pattern_jp IS '停車パターン情報';
COMMENT ON COLUMN pattern_jp.jp_pattern_id IS '停車パターンID';
COMMENT ON COLUMN pattern_jp.route_update_date IS 'ダイヤ改正日';
COMMENT ON COLUMN pattern_jp.origin_stop IS '起点';
COMMENT ON COLUMN pattern_jp.via_stop IS '経過地';
COMMENT ON COLUMN pattern_jp.destination_stop IS '終点';

CREATE TABLE calendar (
  service_id VARCHAR(64) NOT NULL PRIMARY KEY,
  monday SMALLINT NOT NULL CHECK (monday IN (0, 1)),
  tuesday SMALLINT NOT NULL CHECK (tuesday IN (0, 1)),
  wednesday SMALLINT NOT NULL CHECK (wednesday IN (0, 1)),
  thursday SMALLINT NOT NULL CHECK (thursday IN (0, 1)),
  friday SMALLINT NOT NULL CHECK (friday IN (0, 1)),
  saturday SMALLINT NOT NULL CHECK (saturday IN (0, 1)),
  sunday SMALLINT NOT NULL CHECK (sunday IN (0, 1)),
  start_date VARCHAR(8) NOT NULL,
  end_date VARCHAR(8) NOT NULL
);
COMMENT ON TABLE calendar IS '運行区分情報';
COMMENT ON COLUMN calendar.service_id IS '運行日ID';
COMMENT ON COLUMN calendar.monday IS '月曜日';
COMMENT ON COLUMN calendar.tuesday IS '火曜日';
COMMENT ON COLUMN calendar.wednesday IS '水曜日';
COMMENT ON COLUMN calendar.thursday IS '木曜日';
COMMENT ON COLUMN calendar.friday IS '金曜日';
COMMENT ON COLUMN calendar.saturday IS '土曜日';
COMMENT ON COLUMN calendar.sunday IS '日曜日';
COMMENT ON COLUMN calendar.start_date IS 'サービス開始日';
COMMENT ON COLUMN calendar.end_date IS 'サービス終了日';

CREATE TABLE trips (
  trip_id VARCHAR(64) PRIMARY KEY,
  route_id VARCHAR(64) NOT NULL,
  service_id VARCHAR(64) NOT NULL,
  trip_headsign TEXT,
  trip_short_name VARCHAR(64),
  direction_id SMALLINT CHECK (direction_id IN (0, 1)),
  block_id VARCHAR(64),
  shape_id VARCHAR(64),
  wheelchair_accessible SMALLINT CHECK (wheelchair_accessible IN (0, 1, 2)),
  bikes_allowed SMALLINT CHECK (bikes_allowed IN (0, 1, 2)),
  jp_trip_desc TEXT,
  jp_trip_desc_symbol TEXT,
  jp_office_id VARCHAR(64),
  jp_pattern_id VARCHAR(64)
);
ALTER TABLE trips ADD FOREIGN KEY (route_id) REFERENCES routes (route_id);
ALTER TABLE trips ADD FOREIGN KEY (service_id) REFERENCES calendar (service_id);
ALTER TABLE trips ADD FOREIGN KEY (shape_id) REFERENCES shapes (shape_id);
ALTER TABLE trips ADD FOREIGN KEY (jp_office_id) REFERENCES office_jp (office_id);
ALTER TABLE trips ADD FOREIGN KEY (jp_pattern_id) REFERENCES pattern_jp (jp_pattern_id);
COMMENT ON TABLE trips IS '便情報';
COMMENT ON COLUMN trips.trip_id IS '便ID';
COMMENT ON COLUMN trips.route_id IS '経路ID';
COMMENT ON COLUMN trips.service_id IS '運行日ID';
COMMENT ON COLUMN trips.trip_headsign IS '便行先';
COMMENT ON COLUMN trips.trip_short_name IS '便名称';
COMMENT ON COLUMN trips.direction_id IS '往復区分';
COMMENT ON COLUMN trips.block_id IS '便結合区分';
COMMENT ON COLUMN trips.shape_id IS '描画 ID';
COMMENT ON COLUMN trips.wheelchair_accessible IS '車いす利用区分';
COMMENT ON COLUMN trips.bikes_allowed IS '自転車持込区分';
COMMENT ON COLUMN trips.jp_trip_desc IS '便情報';
COMMENT ON COLUMN trips.jp_trip_desc_symbol IS '便記号';
COMMENT ON COLUMN trips.jp_office_id IS '営業所ID';
COMMENT ON COLUMN trips.jp_pattern_id IS '停車パターンID';

CREATE TABLE stop_times (
  trip_id VARCHAR(64) NOT NULL,
  arrival_time VARCHAR(8) NOT NULL,
  departure_time VARCHAR(8) NOT NULL,
  stop_id VARCHAR(64) NOT NULL,
  stop_sequence INTEGER NOT NULL,
  stop_headsign TEXT,
  pickup_type SMALLINT CHECK (pickup_type IN (0, 1, 2, 3)),
  drop_off_type SMALLINT CHECK (drop_off_type IN (0, 1, 2, 3)),
  shape_dist_traveled DOUBLE PRECISION,
  timepoint SMALLINT
);
ALTER TABLE stop_times ADD PRIMARY KEY (trip_id, stop_sequence);
ALTER TABLE stop_times ADD FOREIGN KEY (trip_id) REFERENCES trips (trip_id);
ALTER TABLE stop_times ADD FOREIGN KEY (stop_id) REFERENCES stops (stop_id);
COMMENT ON TABLE stop_times IS '通過時刻情報';
COMMENT ON COLUMN stop_times.trip_id IS '便ID';
COMMENT ON COLUMN stop_times.arrival_time IS '到着時刻';
COMMENT ON COLUMN stop_times.departure_time IS '出発時刻';
COMMENT ON COLUMN stop_times.stop_id IS '標柱ID';
COMMENT ON COLUMN stop_times.stop_sequence IS '通過順位';
COMMENT ON COLUMN stop_times.stop_headsign IS '停留所行先';
COMMENT ON COLUMN stop_times.pickup_type IS '乗車区分';
COMMENT ON COLUMN stop_times.drop_off_type IS '降車区分';
COMMENT ON COLUMN stop_times.shape_dist_traveled IS '通算距離';
COMMENT ON COLUMN stop_times.timepoint IS '発着時間精度';

CREATE TABLE calendar_dates (
  service_id VARCHAR(64) NOT NULL PRIMARY KEY,
  date VARCHAR(8) NOT NULL,
  exception_type SMALLINT NOT NULL CHECK (exception_type IN (1, 2))
);
COMMENT ON TABLE calendar_dates IS '運行日情報';
COMMENT ON COLUMN calendar_dates.service_id IS '運行日ID';
COMMENT ON COLUMN calendar_dates.date IS '日付';
COMMENT ON COLUMN calendar_dates.exception_type IS '利用タイプ';

CREATE TABLE fare_attributes (
  fare_id VARCHAR(64) NOT NULL PRIMARY KEY,
  price NUMERIC(10,2) NOT NULL,
  currency_type VARCHAR(3) NOT NULL DEFAULT 'JPY',
  payment_method SMALLINT NOT NULL CHECK (payment_method IN (0, 1)),
  transfers SMALLINT CHECK (transfers IN (0, 1, 2, NULL)),
  transfer_duration INTEGER
);
COMMENT ON TABLE fare_attributes IS '運賃属性情報';
COMMENT ON COLUMN fare_attributes.fare_id IS '運賃ID';
COMMENT ON COLUMN fare_attributes.price IS '運賃';
COMMENT ON COLUMN fare_attributes.currency_type IS '【固定】通貨';
COMMENT ON COLUMN fare_attributes.payment_method IS '支払いタイミング';
COMMENT ON COLUMN fare_attributes.transfers IS '乗換';
COMMENT ON COLUMN fare_attributes.transfer_duration IS '乗換有効期限';

CREATE TABLE fare_rules (
  fare_id VARCHAR(64) NOT NULL PRIMARY KEY,
  route_id VARCHAR(64),
  origin_id VARCHAR(64),
  destination_id VARCHAR(64),
  contains_id VARCHAR(64)
);
ALTER TABLE fare_rules ADD FOREIGN KEY (fare_id) REFERENCES fare_attributes (fare_id);
ALTER TABLE fare_rules ADD FOREIGN KEY (route_id) REFERENCES routes (route_id);
ALTER TABLE fare_rules ADD FOREIGN KEY (origin_id) REFERENCES stops (stop_id);
ALTER TABLE fare_rules ADD FOREIGN KEY (destination_id) REFERENCES stops (stop_id);
COMMENT ON TABLE fare_rules IS '運賃定義情報';
COMMENT ON COLUMN fare_rules.fare_id IS '運賃ID';
COMMENT ON COLUMN fare_rules.route_id IS '経路ID';
COMMENT ON COLUMN fare_rules.origin_id IS '乗車地ゾーン';
COMMENT ON COLUMN fare_rules.destination_id IS '降車地ゾーン';
COMMENT ON COLUMN fare_rules.contains_id IS '【設定不要】通過ゾーン';

CREATE TABLE frequencies (
  trip_id VARCHAR(64) NOT NULL,
  start_time VARCHAR(8) NOT NULL,
  end_time VARCHAR(8) NOT NULL,
  headway_secs INTEGER NOT NULL,
  exact_times SMALLINT CHECK (exact_times IN (0, 1))
);
ALTER TABLE frequencies ADD FOREIGN KEY (trip_id) REFERENCES trips (trip_id);
COMMENT ON TABLE frequencies IS '運行間隔情報';
COMMENT ON COLUMN frequencies.trip_id IS '便ID';
COMMENT ON COLUMN frequencies.start_time IS '開始時刻';
COMMENT ON COLUMN frequencies.end_time IS '終了時刻';
COMMENT ON COLUMN frequencies.headway_secs IS '運行間隔';
COMMENT ON COLUMN frequencies.exact_times IS '案内精度';

CREATE TABLE transfers (
  from_stop_id VARCHAR(64) NOT NULL,
  to_stop_id VARCHAR(64) NOT NULL,
  transfer_type SMALLINT NOT NULL CHECK (transfer_type IN (0, 1, 2, 3)),
  min_transfer_time INTEGER
);
ALTER TABLE transfers ADD PRIMARY KEY (from_stop_id, to_stop_id);
ALTER TABLE transfers ADD FOREIGN KEY (from_stop_id) REFERENCES stops (stop_id);
ALTER TABLE transfers ADD FOREIGN KEY (to_stop_id) REFERENCES stops (stop_id);
COMMENT ON TABLE transfers IS '乗換情報';
COMMENT ON COLUMN transfers.from_stop_id IS '乗換元標柱ID';
COMMENT ON COLUMN transfers.to_stop_id IS '乗換先標柱ID';
COMMENT ON COLUMN transfers.transfer_type IS '乗換タイプ';
COMMENT ON COLUMN transfers.min_transfer_time IS '乗換時間';

CREATE TABLE feed_info (
  feed_publisher_name TEXT NOT NULL,
  feed_publisher_url TEXT NOT NULL,
  feed_lang VARCHAR(8) NOT NULL DEFAULT 'ja',
  feed_start_date VARCHAR(8),
  feed_end_date VARCHAR(8),
  feed_version VARCHAR(32)
);
COMMENT ON TABLE feed_info IS '提供情報';
COMMENT ON COLUMN feed_info.feed_publisher_name IS '提供組織名';
COMMENT ON COLUMN feed_info.feed_publisher_url IS '提供組織URL';
COMMENT ON COLUMN feed_info.feed_lang IS '【固定】提供言語';
COMMENT ON COLUMN feed_info.feed_start_date IS '有効期間開始日';
COMMENT ON COLUMN feed_info.feed_end_date IS '有効期間終了日';
COMMENT ON COLUMN feed_info.feed_version IS '提供データバージョン';

CREATE TABLE translations (
  table_name VARCHAR(64) NOT NULL CHECK (table_name IN ('agency', 'stops', 'routes', 'trips', 'stop̲times', 'feed̲info')),
  field_name VARCHAR(64) NOT NULL,
  language VARCHAR(8) NOT NULL,
  translation VARCHAR(128) NOT NULL,
  record_id VARCHAR(64),
  record_sub_id VARCHAR(64),
  field_value VARCHAR(128)
);
ALTER TABLE translations ADD PRIMARY KEY (language, record_id, record_sub_id, field_value);
COMMENT ON TABLE translations IS '翻訳情報';
COMMENT ON COLUMN translations.table_name IS 'テーブル名';
COMMENT ON COLUMN translations.field_name IS 'フィールド名';
COMMENT ON COLUMN translations.language IS '言語';
COMMENT ON COLUMN translations.translation IS '翻訳先言語';