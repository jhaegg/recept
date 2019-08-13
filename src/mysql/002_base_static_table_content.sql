BEGIN();

INSERT INTO languages (id, name) VALUES ("en", "english");

INSERT INTO credential_types (id, key) VALUES (1, "email+password");

INSERT INTO credential_type_names (credential_type_id, language_id, name)
VALUES (1, "en", "email and password");

INSERT INTO migrations (id, name) VALUES (2, "base_static_table_content");

COMMIT();
