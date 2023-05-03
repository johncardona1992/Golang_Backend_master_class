postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	goose -dir=./migrations postgres "user=root password=secret host=localhost port=5432 dbname=simple_bank sslmode=disable" up

migratedown:
	@read -p "Are you sure you want to run the migration down? [y/N]: " yn; \
	case $$yn in \
		[Yy]* ) \
			goose -dir=./migrations postgres "user=root password=secret host=localhost port=5432 dbname=simple_bank sslmode=disable" down;; \
		* ) \
			echo "Migration down cancelled";; \
	esac

sqlc:
	sqlc generate

.PHONY: postgres createdb dropdb migrateup migratedown sqlc