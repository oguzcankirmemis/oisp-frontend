#!/bin/bash

# Copyright (c) 2017 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

TEST_DB="test"
psql=( psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" )

"${psql[@]}" <<-EOSQL
    CREATE DATABASE $TEST_DB;
    GRANT ALL PRIVILEGES ON DATABASE $TEST_DB TO $POSTGRES_USER;
    GRANT CONNECT ON DATABASE $TEST_DB TO oisp_user;
EOSQL
if [ "$(ls -A | grep \\.sql\$)" ]; then
    for f in /docker-entrypoint-initdb.d/*.sql; do
        echo "$0: running $f"; "${psql[@]}" --dbname ${TEST_DB} -f "$f"; echo ;
    done
fi
