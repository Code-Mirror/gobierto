#!/bin/sh
set -e

bin/rails gobierto_budgets:elastic_search_schemas:manage:reset
bin/rails gobierto_budgets:elastic_search_schemas:manage:create
bin/rails gobierto_budgets:fixtures:load
echo '::BudgetsSeeder.seed!' | bin/rails c
bin/rails test "$@"
