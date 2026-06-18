# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A **dbt Mesh** showcase built on the Northwind dataset. It exists to demonstrate dbt mesh features: model **grouping**, **governance** (`access`), **versioning**, and **cross-project `ref`**. It is a monorepo containing two independent dbt projects that form a producer → consumer mesh:

| Path | dbt project name | profile | dbt Cloud project-id | Role |
|------|------------------|---------|----------------------|------|
| `projects/foundational/dbt` | `dbt_data` | `dbt_data` | 448668 | **Producer** — core ERP staging, intermediate, and marts (dims/facts) |
| `projects/sales/dbt` | `dbt_regulated_data` | `dbt_regulated_data` | 448671 | **Consumer** — references the foundational project cross-project |

The cross-project dependency is declared in `projects/sales/dbt/dependencies.yml` (`projects: - name: dbt_data`) and consumed in SQL via a two-argument ref, e.g. `{{ ref('dbt_data', 'int_order_items__metrics') }}`. The consumer can only reference foundational models marked `access: public`.

## Commands

This is a **dbt Cloud** project — there is no committed `profiles.yml`. Run dbt from inside the specific project directory you are working on (`projects/foundational/dbt` or `projects/sales/dbt`).

```bash
dbt deps              # install packages (dbt_utils) — run once per project
dbt seed              # load the CSV seeds in seeds/ (the raw data source for this repo)
dbt build             # run + test all models
dbt run               # run models only
dbt test              # run tests only

dbt build --select stg_erp__orders          # single model
dbt build --select +int_order_items__metrics # a model and its upstream
dbt build --select tag:erp                    # by tag
dbt test  --select dim_customers              # tests for one model
```

For the **sales** consumer project, the foundational project must be built first (or resolvable via dbt Cloud defer) because of the cross-project `ref`.

## Data source

There is no live warehouse source. The "raw" layer is the **CSV seeds** in each project's `seeds/` directory (Northwind data). The `_source_erp.yml` source definition is intentionally commented out; staging models read seeds with `{{ ref('orders') }}`, **not** `source()`.

## Layering & conventions

Models flow **staging → intermediate → marts**. Schemas and materializations are set in each `dbt_project.yml`:

- **staging** (`stg` schema): one model per source entity, only renames/casts. Materialized as **view** in foundational, **table** in sales. Tagged `erp`. Naming: `stg_erp__<entity>`.
- **intermediate** (`int` schema, **view**): joins/derivations. Naming: `int_<entity>__<transform>` (e.g. `int_order_items__metrics`).
- **marts** (`marts` schema, **table**, foundational only): `dim_*` and `fct_*`.

Key/column naming: primary key `_pk`, foreign key `_fk`, surrogate key `_sk`.

SQL style (match existing models): a leading-comma CTE chain where each CTE imports a `ref`, with a final `select * from <last_cte>`. Both projects set `+static_analysis: strict`.

Every model has a matching YAML in a sibling `schema/` directory documenting all columns; PK/unique columns carry `unique` + `not_null` tests.

## Governance (mesh features — preserve these)

- **`config: access: public`** in a model's schema YAML is what makes a foundational model referenceable from the sales project. Currently public: `stg_erp__orders`, `stg_erp__order_items`, `int_order_items__metrics`, `int_orders__metrics`. Do not remove `access: public` from a model the sales project references, and do not cross-project-ref a model that isn't public.
- **Semantic models & metrics** live inline in `fct_orders.yml` (`semantic_model`, `metrics`, column-level `entity`/`dimension` blocks). Keep `agg_time_dimension` and metric `expr` columns in sync with the model's actual columns.
- **`common_data_model` meta** (business questions, grain, related tables, ownership) is documented in `dim_customers.yml`.

## Custom schema macro

Both projects override `generate_schema_name` (`macros/generate_custom_schema.sql`): the `+schema:` config (`stg`/`int`/`marts`) is **only** applied when `target.name == 'prod'`; in all other targets everything lands in the default schema. Account for this when looking for built tables in dev.

## PRs

Follow `.github/pull_request_template.md`. New code is expected to follow Indicium's dbt coding conventions and SQL style guide (linked in the template); all added/modified models and columns must be documented and tested in `schema.yml` files.
