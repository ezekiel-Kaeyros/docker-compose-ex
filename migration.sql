CREATE DATABASE EU_backup

CREATE TABLE IF NOT EXISTS countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    code VARCHAR NOT NULL UNIQUE,
    flag VARCHAR,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    description VARCHAR,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    description VARCHAR,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS telecom_operator (
    id SERIAL PRIMARY KEY,
    operator_name VARCHAR NOT NULL,
    description VARCHAR,
    is_active BOOLEAN,
    country VARCHAR NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    is_phone_number_before_amount BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS ussd (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL,
    description VARCHAR,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS addresses (
    id SERIAL PRIMARY KEY,
    street VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    state VARCHAR,
    postal_code VARCHAR,
    region VARCHAR,
    zip_code VARCHAR,
    quater VARCHAR,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    country_id INTEGER REFERENCES countries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS operation (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    description VARCHAR,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    ussd_code VARCHAR UNIQUE,
    waiting_time INTEGER,
    telecom_operator_id INTEGER REFERENCES telecom_operator(id)
);

CREATE TABLE IF NOT EXISTS role_permission (
    role_id INTEGER REFERENCES roles(id) ON DELETE CASCADE,
    permission_id INTEGER REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS sim_cart (
    id SERIAL PRIMARY KEY,
    phone_number VARCHAR NOT NULL UNIQUE,
    description VARCHAR,
    usb_port VARCHAR UNIQUE,
    current_solde VARCHAR,
    password VARCHAR NOT NULL,
    is_active BOOLEAN NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    telecom_operator_id INTEGER REFERENCES telecom_operator(id)
);

CREATE TABLE IF NOT EXISTS company (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    description VARCHAR NOT NULL,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    address_id INTEGER REFERENCES addresses(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS transaction (
    id SERIAL PRIMARY KEY,
    receiver_phone_number VARCHAR NOT NULL,
    receiver_name VARCHAR,
    amount INTEGER,
    raison VARCHAR,
    origin VARCHAR,
    telecom_operator_id INTEGER NOT NULL REFERENCES telecom_operator(id),
    operation_id INTEGER NOT NULL REFERENCES operation(id),
    operation VARCHAR NOT NULL,
    current_balance VARCHAR,
    transaction_reference VARCHAR NOT NULL,
    status VARCHAR,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS agency (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    agency_code VARCHAR NOT NULL UNIQUE,
    description VARCHAR NOT NULL,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    address_id INTEGER UNIQUE REFERENCES addresses(id) ON DELETE CASCADE,
    company_id INTEGER REFERENCES company(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR NOT NULL UNIQUE,
    password VARCHAR NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    agency_id INTEGER REFERENCES agency(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS profiles (
    id SERIAL PRIMARY KEY,
    phone_number VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    user_id INTEGER UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    address_id INTEGER UNIQUE REFERENCES addresses(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_role (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    role_id INTEGER REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);
