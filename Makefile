all: test-native test-docker-nomount test-docker-nodemodule-mount test-docker-mount

build:
	@docker-compose build -q

up:
	@docker-compose up -d &> /dev/null

test-native: build
	@echo "Testing: Native installation..."
	@echo ""
	@docker-compose run --rm app-mount -c "rm -rf node_modules"
	@cd create-react-app && npm install --silent --no-progress && rm -rf node_modules
	@cd create-react-app && /usr/bin/time -p npm install --silent --no-progress --no-audit 2>&1 | grep real
	@echo ""

test-docker-nomount: build
	@echo "Testing: Docker without volumes..."
	@echo ""
	@docker-compose run --rm app-nomount -c "time npm install --silent --no-progress --no-audit 2>&1 | grep real"
	@echo ""

test-docker-mount: build up
	@echo "Testing: Docker with a bind mount: ./create-react-app:/usr/src/app"
	@echo ""
	@rm -rf create-react-app/node_modules
	@docker-compose run --rm app-mount -c "time npm install --silent --no-progress --no-audit 2>&1 | grep real"
	@echo ""

test-docker-nodemodule-mount: build up
	@echo "Testing: Docker with a bind mount: './create/react/app:/usr/src/app' and a volume on: 'nodemodules:/usr/src/app/node_modules'"
	@echo ""
	@docker-compose down -v &> /dev/null
	@docker-compose up -d &> /dev/null
	@docker-compose run --rm app-mount-nodemodule-volume -c "time npm install --silent --no-progress --no-audit 2>&1 | grep real"
	@echo ""

test-docker-nfs-mount: build up
	@echo "Testing: Docker with nfs mount..."
	@echo ""
	@docker-compose down -v &> /dev/null
	@docker-compose up -d &> /dev/null
	@rm -rf create-react-app/node_modules
	@docker-compose run --rm app-nfs -c "time npm install --silent --no-progress --no-audit 2>&1 | grep real"
	@echo ""

test-cpu:
	time node cpu-bench.js
	docker run --rm -it -v $$PWD:/usr/src/app -v $$PWD/.cache:/root/.npm -w /usr/src/app node:18-slim bash -c "time node cpu-bench.js"
