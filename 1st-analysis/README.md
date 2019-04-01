```shell
$ WORKDIR=/tmp/pga/testing
$ OREALY=cf89a75eb8a6eb780cf6adfac4e3537843386777
$ OSHIFT=51fcd980950c660918ded745a186c03b08467f81
$ REDMAT=6348e70daa113e8b3203de8fbc919d08c90d972e
$ ENCRYP=b45b86ddcc98bb9250d29ecad9e5bf570f8ff306

$ function getSiva { \
    pga list -l Go -f json | jq -r ". | select(.sivaFilenames[] == \"$1.siva\") | .url"; \
    echo $1.siva | pga get -i -o $2/$1; \
};


$ getSiva $OREALY $WORKDIR
# https://github.com/bitcoinbook/bitcoinbook

$ gitbase server --directories $WORKDIR/$OREALY --port=3306 --index=/tmp/gitbase
# takes 1s to be ready


$ getSiva $OSHIFT $WORKDIR
# https://github.com/openshift/openshift-tools

$ gitbase server --directories $WORKDIR/$OSHIFT --port=3306 --index=/tmp/gitbase
# takes 33s to be ready


$ getSiva $OREALY $WORKDIR
# https://github.com/friendica/red
# https://github.com/redmatrix/hubzilla
# https://github.com/redmatrix/redmatrix

$ gitbase server --directories $WORKDIR/$REDMAT --port=3306 --index=/tmp/gitbase
# takes 82s to be ready


$ getSiva $ENCRYP $WORKDIR
# https://github.com/letsencrypt/boulder
# https://github.com/letsencrypt/anvil

$ gitbase server --directories $WORKDIR/$ENCRYP --port=3306 --index=/tmp/gitbase
# takes 132s to be ready

```

some insights:

| table        | oreilly | openshift | redmatrix | letsencrypt |
|--------------|---------|-----------|-----------|-------------|
| blobs        |    5263 |     15537 |    134369 |      152485 |
| commits      |    4745 |      9286 |     46473 |       54920 |
| refs         |     620 |      3961 |     10112 |       15030 |
| remotes      |       3 |         1 |         7 |           9 |
| repositories |       1 |         1 |         3 |           4 |
| tree_entries |  153145 |    370024 |   6208289 |     6642434 |
|              | oreilly | openshift | redmatrix | letsencrypt |
| .siva HDD    |   74 MB |     18 MB |    226 MB |       32 MB |










mysql --port=3306 --user=root --host=127.0.0.1 --execute "SELECT count(*) from blobs"
mysql --port=3306 --user=root --host=127.0.0.1 --execute "SELECT count(*) from commits"
mysql --port=3306 --user=root --host=127.0.0.1 --execute "SELECT count(*) from refs"
mysql --port=3306 --user=root --host=127.0.0.1 --execute "SELECT count(*) from remotes"
mysql --port=3306 --user=root --host=127.0.0.1 --execute "SELECT count(*) from repositories"
mysql --port=3306 --user=root --host=127.0.0.1 --execute "SELECT count(*) from tree_entries"

