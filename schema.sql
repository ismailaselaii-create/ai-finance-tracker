CREATE TABLE users (
  id            BIGSERIAL     PRIMARY KEY,
  chat_id       BIGINT        UNIQUE NOT NULL,
  username      VARCHAR(64),
  first_name    VARCHAR(128),
  currency      CHAR(3)       DEFAULT 'KZT',
  timezone      VARCHAR(64)   DEFAULT 'Asia/Almaty',
  language      VARCHAR(10)   DEFAULT 'en',
  created_at    TIMESTAMPTZ   DEFAULT NOW(),
  updated_at    TIMESTAMPTZ   DEFAULT NOW()
);

CREATE TABLE categories (
  id          SERIAL       PRIMARY KEY,
  user_id     BIGINT       REFERENCES users(id) ON DELETE CASCADE,
  name        VARCHAR(64)  NOT NULL,
  type        VARCHAR(10)  NOT NULL CHECK (type IN ('expense','income')),
  emoji       VARCHAR(10)  DEFAULT '💰',
  is_default  BOOLEAN      DEFAULT FALSE,
  UNIQUE(user_id, name)
);

CREATE TABLE transactions (
  id                BIGSERIAL      PRIMARY KEY,
  user_id           BIGINT         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category_id       INT            REFERENCES categories(id),
  type              VARCHAR(10)    NOT NULL CHECK (type IN ('income','expense')),
  amount            NUMERIC(15,2)  NOT NULL CHECK (amount > 0),
  note              TEXT,
  transaction_date  DATE           NOT NULL DEFAULT CURRENT_DATE,
  idempotency_key   VARCHAR(64)    UNIQUE,
  raw_input         TEXT,
  ai_confidence     NUMERIC(4,3),
  created_at        TIMESTAMPTZ    DEFAULT NOW()
);

CREATE TABLE budgets (
  id            SERIAL         PRIMARY KEY,
  user_id       BIGINT         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category_id   INT            REFERENCES categories(id),
  period        VARCHAR(10)    NOT NULL CHECK (period IN ('daily','weekly','monthly')),
  limit_amount  NUMERIC(15,2)  NOT NULL CHECK (limit_amount > 0),
  alert_at_pct  INT            DEFAULT 80,
  is_active     BOOLEAN        DEFAULT TRUE,
  created_at    TIMESTAMPTZ    DEFAULT NOW(),
  UNIQUE(user_id, category_id, period)
);

CREATE TABLE sessions (
  id          BIGSERIAL    PRIMARY KEY,
  user_id     BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  state       VARCHAR(32),
  context     JSONB,
  expires_at  TIMESTAMPTZ,
  created_at  TIMESTAMPTZ  DEFAULT NOW()
);

INSERT INTO categories (user_id, name, type, emoji, is_default) VALUES
  (NULL, 'food',          'expense', '🍕', TRUE),
  (NULL, 'transport',     'expense', '🚗', TRUE),
  (NULL, 'housing',       'expense', '🏠', TRUE),
  (NULL, 'health',        'expense', '💊', TRUE),
  (NULL, 'education',     'expense', '📚', TRUE),
  (NULL, 'entertainment', 'expense', '🎮', TRUE),
  (NULL, 'shopping',      'expense', '🛍️', TRUE),
  (NULL, 'utilities',     'expense', '⚡', TRUE),
  (NULL, 'salary',        'income',  '💼', TRUE),
  (NULL, 'other',         'expense', '💳', TRUE);
