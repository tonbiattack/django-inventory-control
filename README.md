# Django 在庫管理システム

DjangoとDjango REST Frameworkを使用して構築された在庫管理アプリケーションのサンプルです。

## 目的

このプロジェクトは、Django REST Frameworkの実践的な利用を想定したテストおよび学習用に作成されました。製品在庫のCRUD（作成、読み取り、更新、削除）操作を実行するWeb APIの基本的なテンプレートとして機能します。

## 主な機能

*   製品を管理するためのAPIエンドポイント（CRUD）
*   基本的なDjangoプロジェクト構成

## セットアップ方法

### 前提条件

*   Python 3.x
*   pip

### インストールと設定

1.  **リポジトリをクローンします:**
    ```bash
    git clone https://github.com/your-username/private-django-inventory-control.git
    cd private-django-inventory-control
    ```

2.  **仮想環境を作成して有効化します:**
    ```bash
    python -m venv venv
    # Windows
    venv/Scripts/activate
    # macOS/Linux
    source venv/bin/activate
    ```

3.  **依存関係をインストールします:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **データベースのマイグレーションを実行します:**
    ```bash
    python manage.py migrate
    ```

5.  **開発サーバーを起動します:**
    ```bash
    python manage.py runserver
    ```

APIは `http://127.0.0.1:8000/` で利用可能になります。
