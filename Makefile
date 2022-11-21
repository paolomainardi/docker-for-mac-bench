all: test-native test-docker-nomount test-docker-nodemodule-mount test-docker-mount

build:
	@docker-compose build -q

up:
	@docker-compose up -d &> /dev/null

test-native: build
	@echo "Testing: Native installation..."
	@echo ""
	@cd create-react-app && rm -rf node_modules
	@cd create-react-app && /usr/bin/time -p npm install --silent --no-progress --no-audit 2>&1 | grep real
	@echo ""

test-docker-nomount: build
	@echo "Testing: Docker without volume mount..."
	@echo ""
	@docker-compose run --rm app-nomount -c "time npm install --silent --no-progress --no-audit 2>&1 | grep real"
	@echo ""

test-docker-mount: build up
	@echo "Testing: Docker with volume mount..."
	@echo ""
	@docker-compose run --rm app-mount -c "rm -rf node_modules && time npm install --silent --no-progress --no-audit 2>&1 | grep real"
	@echo ""

test-docker-nodemodule-mount: build up
	@echo "Testing: Docker with node_modules mounted as a named volume..."
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
	@rm -rf node_modules
	@docker-compose run --rm app-nfs -c "time npm install --silent --no-progress --no-audit 2>&1 | grep real"
	@echo ""

test-cpu:
	time node cpu-bench.js
	docker run --rm -it -v $$PWD:/usr/src/app -v $$PWD/.cache:/root/.npm -w /usr/src/app node:18-slim bash -c "time node cpu-bench.js"
