# Django REST API構築の概要

このドキュメントは、DjangoとDjango REST Frameworkを使用して在庫管理APIを構築するプロセスをまとめたものです。

## 1. プロジェクトのセットアップ

### 1.1. 依存関係のインストール

まず、プロジェクトに必要なライブラリを定義した `requirements.txt` を作成し、`pip` を使ってインストールしました。

**`requirements.txt`**:
```
Django
djangorestframework
```

**実行コマンド**:
```bash
pip install -r requirements.txt
```

### 1.2. Djangoプロジェクトとアプリケーションの作成

次に、`inventory_control` という名前のDjangoプロジェクトと、製品情報を管理するための `products` という名前のアプリケーションを作成しました。

**実行コマンド**:
```bash
django-admin startproject inventory_control .
python manage.py startapp products
```

### 1.3. 設定の変更

作成したアプリケーションとDjango REST Frameworkをプロジェクトに認識させるため、`inventory_control/settings.py` の `INSTALLED_APPS` に以下を追加しました。

**`inventory_control/settings.py` の変更箇所**:
```python
INSTALLED_APPS = [
    # ... (既存のアプリ)
    'rest_framework',
    'products',
]
```

## 2. データベースとモデル

### 2.1. モデルの定義

提供された `db/products.sql` のスキーマに基づき、`products/models.py` に `Product` モデルを定義しました。

**`products/models.py`**:
```python
from django.db import models

class Product(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    name = models.CharField(max_length=100)
    quantity = models.IntegerField()
    price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = 'products'
```

### 2.2. データベース設定とマイグレーション

当初、MySQLを使用する設定を行いましたが、接続エラーが発生したため、開発をスムーズに進めるために一時的にデフォルトのSQLite3に戻しました。

**`inventory_control/settings.py` のデータベース設定**:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```

その後、データベーススキーマを適用するためにマイグレーションを実行しました。

**実行コマンド**:
```bash
python manage.py makemigrations
python manage.py migrate
```

これにより、`products/migrations/0001_initial.py` が生成され、データベースに `products` テーブルが作成されました。

## 3. APIの実装

Django REST Frameworkの主要なコンポーネントである「Serializer」、「ViewSet」、「Router」を使用してAPIを構築しました。

### 3.1. Serializer (シリアライザー)

モデルインスタンスとPythonのネイティブデータ型（およびJSON）との相互変換を担当します。

**`products/serializers.py`**:
```python
from rest_framework import serializers
from .models import Product

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'
```

### 3.2. ViewSet (ビューセット)

CRUD（作成、読み取り、更新、削除）操作のロジックをまとめたものです。`ModelViewSet` を使用することで、定型的な処理を自動で実装できます。

**`products/views.py`**:
```python
from rest_framework import viewsets
from .models import Product
from .serializers import ProductSerializer

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
```

### 3.3. URLとRouter (ルーティング)

RouterはViewSetに基づいて、APIのエンドポイント（URL）を自動的に生成します。

**`products/urls.py`**:
```python
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProductViewSet

router = DefaultRouter()
router.register(r'products', ProductViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
```

そして、プロジェクト全体の `inventory_control/urls.py` で、この `products` アプリケーションのURLを `/api/` というパスに紐付けました。

**`inventory_control/urls.py`**:
```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('products.urls')),
]
```

## 4. APIの利用方法

開発サーバーを起動すると、以下のエンドポイントにアクセスできるようになります。

**サーバー起動コマンド**:
```bash
python manage.py runserver
```

**APIエンドポイント**:
- `GET /api/products/`: 全製品の一覧を取得
- `POST /api/products/`: 新しい製品を登録
- `GET /api/products/{id}/`: 特定の製品の詳細を取得
- `PUT /api/products/{id}/`: 特定の製品の情報を更新
- `DELETE /api/products/{id}/`: 特定の製品を削除

これらの操作は、cURLやPostmanのようなAPIテストツールで確認できます。

## 5. Djangoの主要機能と開発ツール

このセクションでは、DjangoおよびDjango REST Frameworkが提供する、開発を効率化するための重要な概念とツールについて解説します。

### 5.1. プロジェクトとアプリケーションの概念

Djangoでは、ウェブサイトの構成要素を「プロジェクト」と「アプリケーション」という2つの単位で管理します。

*   **プロジェクト (Project)**: ウェブサイト全体を指す大きな入れ物です。サイト全体の設定（データベース接続、URL設定など）を管理します。今回の例では `inventory_control` がこれにあたります。
*   **アプリケーション (Application)**: 特定の機能を実現するための再利用可能な部品です。「ブログ機能」や「ユーザー認証機能」のように、役割ごとに作成します。今回の例では `products` がこれにあたります。

この構造により、機能ごとにコードが整理され、大規模な開発でもメンテナンスしやすくなります。

### 5.2. Browsable API (ブラウザブルAPI)

*   **アクセスURL**: `http://127.0.0.1:8000/api/products/`
*   **目的**: **開発者**がAPIの動作をブラウザ上で直接テストするためのGUI（グラフィカル・ユーザー・インターフェース）です。
*   **特徴**:
    *   APIから返されるJSONデータを整形して表示します。
    *   HTMLフォームを通じて、データの登録(POST)や更新(PUT)が可能です。
    *   Postmanのような専用ツールを使わずに、APIの全機能（CRUD）をブラウザだけで迅速にテストできます。

### 5.3. Django Admin (管理画面)

*   **アクセスURL**: `http://127.0.0.1:8000/admin/`
*   **目的**: **サイト管理者**が、データベースの中身を安全かつグラフィカルに管理するためのコントロールパネルです。
*   **利用方法**:
    1.  `python manage.py createsuperuser` コマンドで管理者アカウントを作成します。
    2.  管理したいモデルを `admin.py` ファイルに `admin.site.register(YourModel)` のように登録します。
    3.  ログイン後、プログラミングの知識がなくても、データの追加・編集・削除が直感的に行えます。