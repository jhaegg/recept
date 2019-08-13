CREATE DATABASE recept CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE migrations (
    id      INTEGER      NOT NULL PRIMARY KEY,
    name    VARCHAR(255) NOT NULL,
    applied DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id   INTEGER      NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
)

CREATE TABLE languages (
    id   CHAR(2) NOT NULL PRIMARY KEY,
    name TEXT    NOT NULL
);

CREATE TABLE credential_types (
    id  INTEGER     NOT NULL PRIMARY KEY,
    key VARCHAR(63) NOT NULL,

    UNIQUE idx_key (key)
);

CREATE TABLE credential_type_names (
    credential_type_id INTEGER NOT NULL PRIMARY KEY,
    language_id        CHAR(2) NOT NULL,
    name               TEXT    NOT NULL,

    FOREIGN KEY fk_language_id (language_id) REFERENCES language (id) ON DELETE CASCADE
);

CREATE TABLE credentials (
    user_id INTEGER       NOT NULL,
    type_id INTEGER       NOT NULL,
    key     VARCHAR(1023) NOT NULL,
    value   VARCHAR(1023) NOT NULL,

    FOREIGN KEY fk_user_id (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY fk_type_id (type_id) REFERENCES credential_types (id) ON DELETE CASCADE,
    UNIQUE idx_type_id_key (type_id, key)
);

CREATE TABLE ingredients (
    id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT PRIMARY KEY
) AUTO_INCREMENT=1;

CREATE TABLE ingredient_names (
    ingredient_id INTEGER      NOT NULL,
    language_id   CHAR(2)      NOT NULL,
    name          VARCHAR(255) NOT NULL,

    FOREIGN KEY fk_ingredient_id (ingredient_id) REFERENCES ingredients (id) ON DELETE CASCADE,
    FOREIGN KEY fk_language_id (language_id) REFERENCES language (id) ON DELETE CASCADE,
    UNIQUE idx_ingredient_id_language (ingredient_id, language),
    FULLTEXT INDEX idx_language_name (language, name)
);

CREATE TABLE recipes (
    id   INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
) AUTO_INCREMENT=1;


CREATE TABLE recipe_ingredients (
    recipe_id      INTEGER NOT NULL,
    ingredient_id  INTEGER NOT NULL,
    grams          INTEGER NOT NULL,

    FOREIGN KEY fk_recipe_id (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE,
    FOREIGN KEY fk_ingredient_id (ingredient_id) REFERENCES ingredients (id),
    UNIQUE idx_recipe_id_ingredient_id (recipe_id, ingredient_id)
);

CREATE TABLE actions (
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
);

CREATE TABLE action_formats (
    action_id   INTEGER      NOT NULL,
    language_id CHAR(2)      NOT NULL,
    name        VARCHAR(255) NOT NULL,
    format      TEXT         NOT NULL,

    FOREIGN KEY fk_action_id (action_id) REFERENCES actions (id) ON DELETE CASCADE,
    FOREIGN KEY fk_language_id (language_id) REFERENCES language (id) ON DELETE CASCADE,
    UNIQUE idx_ingredient_id_language (action_id, language),
    FULLTEXT INDEX idx_language_name (language, name)
);

CREATE TABLE recipe_steps (
    recipe_id             INTEGER NOT NULL,
    ordinal               INTEGER NOT NULL,
    action_id             INTEGER NOT NULL,
    ingredient_id         INTEGER NOT NULL,
    ingredient_percentage INTEGER NOT NULL,

    FOREIGN KEY fk_recipe_id (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE,
    FOREIGN KEY fk_ingredient_id (ingredient_id) REFERENCES ingredients (id),
    FOREIGN KEY fk_action_id (action_id) REFERENCES actions(id),
    UNIQUE idx_recipe_id_ordinal (recipe_id, ordinal)
);

INSERT INTO migrations (id, name) VALUES (1, "base_tables");
