# CityForward POC: patient-history summarizer

You are building a proof of concept for CityForward Health. It reads one synthetic patient's chart and writes a short summary a clinician can check, with every statement tied to its source. The client's rules are in `docs/01_POC_REQUIREMENTS.md`. The design you must follow is in `docs/02_POC_HLD.md` and `docs/03_POC_LLD.md`. How the hospital's record system behaves is in `docs/04_EHR_FHIR_NOTES.md`.

## Non-negotiable rules

1. **Synthetic data only.** Never use, invent or paste real patient information.
2. **Follow the LLD.** File names, function names, field names, error messages and prompt text in `docs/03_POC_LLD.md` are the contract. Do not rename, reorganize or "improve" them. If you believe the LLD is wrong, stop and tell me instead of changing it.
3. **Acceptance tests are the definition of done.** The tests in `poc/tests/` are fixed. **Never edit them to make them pass.** Fix the code. If a test seems wrong, tell me.
4. **No extras.** Build only what the LLD lists: no database, no login, no caching layer, no extra pages, no extra dependencies beyond `poc/requirements.txt`, no background jobs.
5. **Nothing may decide, diagnose, predict or recommend treatment.** The summary only reports what the chart says and flags what is missing or pending.
6. **Never show an unchecked AI summary.** Every summary passes the grounding check, or the labelled template is shown instead.
7. **Secrets.** Never write an API key, token or private key into a file that is committed. Read them from environment variables. `.env` and `*.pem` stay out of git.

## Layout (fixed)

```
poc/app.py                     the Streamlit screen
poc/summarizer/__init__.py     empty
poc/summarizer/records.py      FHIR bundle -> typed patient record
poc/summarizer/llm.py          one seam to whichever model answers
poc/summarizer/graph.py        the LangGraph summarizer + grounding checks
poc/summarizer/fhir.py         read-only client for the hospital's FHIR API
poc/requirements.txt
poc/README.md
poc/tests/                     acceptance tests (given, do not edit)
sample_data/bundles/           22 synthetic patient files (given, do not edit)
```

## Commands

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r poc/requirements.txt
bash scripts/verify.sh                    # the whole test suite (16 tests), with a clean environment
bash scripts/verify.sh engine|fhir|app    # one stage at a time while building
streamlit run poc/app.py                  # the screen (from the project root)
```

Run the tests from the project root with `PYTHONPATH=poc`. `scripts/verify.sh` does that for you and clears model settings that would change a test's result.

## How to work

- Build one file at a time, in the order in `docs/03_POC_LLD.md` section 0.
- After each file, run the quickest check that proves it, then say what you ran and what you saw.
- Prefer small, plain Python: type hints, pydantic v2 models, short functions. Add a comment only where the reason is not obvious.
- When a test fails, show me the failure, explain the cause in one or two sentences, fix the code, and rerun.
- Before saying you are done, run `bash scripts/verify.sh` and show the result.

## Definition of done

- `bash scripts/verify.sh` passes with no test edited.
- `streamlit run poc/app.py` shows a patient picker, a Summarize button, the summary with citation ids, and the evidence list. With no model configured it shows a labelled template summary.
- With `POC_EHR_URL` set to the sandbox, it reads patients through the FHIR API only.
- `poc/README.md` says how to run it, which model and prompt version were used, and the shortcuts the POC takes.
