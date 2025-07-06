from django.db import models

class Product(models.Model):
    id = models.CharField(max_length=36, primary_key=True)
    name = models.CharField(max_length=100)
    quantity = models.IntegerField()
    price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = 'products'