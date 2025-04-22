-- Create the taskmaster database if it doesn't exist
CREATE DATABASE IF NOT EXISTS taskmaster CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Use the taskmaster database
USE taskmaster;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- Create tasks table
CREATE TABLE IF NOT EXISTS tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    priority VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    duration INT,
    completed BOOLEAN DEFAULT FALSE,
    created_at DATETIME,
    completed_at DATETIME,
    user_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create achievements table
CREATE TABLE IF NOT EXISTS achievements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    achievement_id VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    icon VARCHAR(255) NOT NULL,
    points INT NOT NULL,
    category VARCHAR(255) NOT NULL,
    unlocked_at DATETIME NOT NULL,
    user_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create a test user with an encrypted password
-- Password is 'password' encrypted with BCrypt
INSERT INTO users (name, email, password) VALUES 
('Test User', 'test@example.com', '$2a$10$aCvAGxXhYSMmXs7yN2gP0.Tln5UBUbj56AYxgzrKa/AuWnf5zTXeS');