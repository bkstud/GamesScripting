#!/bin/bash

echo "CREATE 2 categories and items assigned to them"
curl -s -X POST   -H "Content-type: application/json" \
-d '{"name": "groceries"}' \
http://localhost:8080/category | jq

curl -s -X POST   -H "Content-type: application/json" \
-d '{"name": "category 2"}' \
http://localhost:8080/category | jq


echo -e "\nCreating items...\n"
curl -s -X POST   -H "Content-type: application/json" \
-d '{"name": "water", "price": 10, "picture_url": "https://media.istockphoto.com/id/105951730/pl/zdj%c4%99cie/butelka-wody-gazowanej-z-pust%c4%85-etykiet%c4%99.webp?s=2048x2048&w=is&k=20&c=19-wdy3dnniu7n61prqao_fo_rmh4mf4aeegkkykf7s=", "category_id": 1}' \
http://localhost:8080/item | jq

curl -s -X POST   -H "Content-type: application/json" \
-d '{"name": "some_item", "price": 20, "category_id": 2}' \
http://localhost:8080/item | jq
echo -e "\n------------------------------------\n"

echo "READ ALL items"
curl -s -X GET localhost:8080/item | jq
echo -e "\n------------------------------------\n"


echo "READ ONE /item/1 "
curl -s -X GET localhost:8080/item/1 | jq
echo -e "\n------------------------------------\n"

echo "READ ALL categories"
curl -s -X GET localhost:8080/category | jq
echo -e "\n------------------------------------\n"


echo "READ ONE /category/2 "
curl -s -X GET localhost:8080/category/1 | jq

echo "UPDATE /item/2"
curl -s -X PUT -H "Content-type: application/json" \
-d '{"name": "new_name", "price": 420, "picture_url": "new_url"}' \
localhost:8080/item/2 | jq
echo -e "\n------------------------------------\n"

echo "UPDATE /category/2"
curl -s -X PUT -H "Content-type: application/json" \
-d '{"name": "new_name"}' \
localhost:8080/category/2 | jq

echo -e "\n------------------------------------\n"
echo "DELETE /item/1"
curl -s -X DELETE localhost:8080/item/1 | jq
echo -e "\n------------------------------------"


echo "AFTER OPERATIONS:"
curl -s -X GET localhost:8080/item | jq
echo "categories.."
curl -s -X GET localhost:8080/category | jq
echo -e "\n------------------------------------\n"
