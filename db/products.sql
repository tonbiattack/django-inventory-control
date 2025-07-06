CREATE TABLE products (
    id CHAR(36) NOT NULL COMMENT '一意の製品ID',
    name VARCHAR(100) NOT NULL COMMENT '製品名',
    quantity INT NOT NULL COMMENT '在庫数量',
    price DECIMAL(10, 2) NOT NULL COMMENT '製品の価格',
    PRIMARY KEY (id)
) COMMENT = '製品情報と在庫レベルを管理するテーブル';