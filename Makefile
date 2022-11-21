test:
	rm -rf node_modules
	docker run --rm -it -v $$PWD:/usr/src/app -v $$PWD/.cache:/root/.npm -w /usr/src/app node:18-slim bash -c "time npm install"

test-cpu:
	time node cpu-bench.js
	docker run --rm -it -v $$PWD:/usr/src/app -v $$PWD/.cache:/root/.npm -w /usr/src/app node:18-slim bash -c "time node cpu-bench.js"

test-nfs:
	rm -rf node_modules
	docker-compose run --rm app bash -c "time npm install"


