/* users */
DROP   TABLE users CASCADE;
CREATE TABLE users
(
    user_id     serial     NOT NULL  PRIMARY KEY,
    login       text       NOT NULL,
    passwd      text       NOT NULL,
    session_id  text,

    /* personal information */
    civility     integer,   /* handled in translations */
    first_name   text,
    last_name    text,
    nick_name    text,
    pseudonymous text,
    country      text       NOT NULL,
    town         text,

    /* online indentity */
    web_page     text,
    pm_group     text,
    pm_group_url text,
    email        text                       NOT NULL,
    email_hide   boolean      DEFAULT TRUE  NOT NULL,
    gpg_pub_key  text,
    pause_id     text,
    monk_id      text,
    icq          text,
    bio          integer,    /* handled in translations? */

    /* website preferences */
    lang         text         DEFAULT 'Browser select' NOT NULL,
    timezone     text         DEFAULT 'Europe/Paris'   NOT NULL,
);
CREATE INDEX users_session_id ON users (session_id);

/* users' rights */
DROP   TABLE rights;
CREATE TABLE rights
(
    name        text       NOT NULL,
    conf_id     text       NOT NULL,
    user_id     integer    NOT NULL,

    FOREIGN KEY( user_id  ) REFERENCES users( user_id  )
);
CREATE INDEX rights_idx ON rights (conf_id);

/* multilingual entries */
DROP   TABLE translations;
CREATE TABLE translations
(
    tbl      text,
    col      text,           
    id       integer,
    lang     text,
    text     text
);
CREATE INDEX translations_idx ON translations ( tbl, col, id );
