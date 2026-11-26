#!/usr/bin/env bash
# Run the acceptance tests from the project root with a clean model environment.
#
#   bash scripts/verify.sh           everything (16 tests)
#   bash scripts/verify.sh engine    records, model seam and graph (13 tests)
#   bash scripts/verify.sh fhir      the EHR client (2 tests)
#   bash scripts/verify.sh app       the Streamlit screen (1 test)
#
# Model and EHR settings from your shell would change what some tests expect, so they are cleared first.
# If the project has a virtual environment (.venv) its Python is used, so forgetting to activate it cannot run the tests on another Python.
set -euo pipefail
cd "$(dirname "$0")/.."
APP_TEST="poc/tests/test_poc.py::test_streamlit_app_renders_a_labelled_fallback_without_a_model"
PY=python
if [ -x .venv/bin/python ]; then PY=.venv/bin/python; fi
case "${1:-all}" in
  engine) targets=(poc/tests/test_poc.py poc/tests/test_foundry_identity.py --deselect "$APP_TEST") ;;
  fhir)   targets=(poc/tests/test_fhir.py) ;;
  app)    targets=("$APP_TEST") ;;
  all)    targets=(poc/tests) ;;
  *)      echo "usage: bash scripts/verify.sh [engine|fhir|app]"; exit 2 ;;
esac
env -u LLM_PROVIDER -u LLM_MODEL -u LLM_BASE_URL -u LLM_API_KEY -u GROQ_API_KEY -u FOUNDRY_AUTH \
    -u POC_EHR_URL -u POC_EHR_PUBLIC_URL -u POC_FHIR_CLIENT_ID -u POC_FHIR_KEY_FILE -u BUNDLES_DIR \
    PYTHONPATH=poc "$PY" -m pytest "${targets[@]}" -q -W ignore
