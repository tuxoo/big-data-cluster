.PHONY: config
config:
	rm -rf volumes/big-data-cluster-clickhouse

	mkdir -p volumes/big-data-cluster-clickhouse/0/config
	mkdir -p volumes/big-data-cluster-clickhouse/1/config
	mkdir -p volumes/big-data-cluster-clickhouse/2/config
	mkdir -p volumes/big-data-cluster-clickhouse/3/config

	REPLICA=0 SHARD=0 envsubst < config-template.xml > volumes/big-data-cluster-clickhouse/0/config/config.xml
	REPLICA=1 SHARD=0 envsubst < config-template.xml > volumes/big-data-cluster-clickhouse/1/config/config.xml
	REPLICA=2 SHARD=1 envsubst < config-template.xml > volumes/big-data-cluster-clickhouse/2/config/config.xml
	REPLICA=3 SHARD=1 envsubst < config-template.xml > volumes/big-data-cluster-clickhouse/3/config/config.xml

	cp users.xml volumes/big-data-cluster-clickhouse/0/config/users.xml
	cp users.xml volumes/big-data-cluster-clickhouse/1/config/users.xml
	cp users.xml volumes/big-data-cluster-clickhouse/2/config/users.xml
	cp users.xml volumes/big-data-cluster-clickhouse/3/config/users.xml
