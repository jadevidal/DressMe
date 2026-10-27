
CREATE TABLE IF NOT EXISTS clothing_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    color VARCHAR(50),
    brand VARCHAR(100),
    season VARCHAR(50),
    image_path VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS outfits (
    outfit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    outfit_name VARCHAR(100) NOT NULL,
    occasion VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS outfit_items (
    outfit_id INT NOT NULL,
    item_id INT NOT NULL,
    PRIMARY KEY (outfit_id, item_id),
    FOREIGN KEY (outfit_id) REFERENCES outfits(outfit_id)
        ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES clothing_items(item_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS favorites (
    favorite_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    outfit_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, outfit_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (outfit_id) REFERENCES outfits(outfit_id)
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS style_preferences (
    preference_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    favorite_style VARCHAR(100),
    favorite_color VARCHAR(50),
    preferred_fit VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    UNIQUE (user_id, category_name)
);
