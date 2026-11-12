# CityForward Health: requirements for the proof of concept

**DRAFT: adjust to what the proposal call actually produced.** Sent by Dr. Naomi Feldman after the call to turn our questions into requirements. Items marked (Q) came from a question we raised on the call.

## 1. Purpose

Show, on synthetic patients, that a tool can read a patient's chart through our interfaces and give a clinician a **short, cited summary of the stay**. We want to judge whether this earns a pilot. We are not buying a product at this stage.

## 2. Users

- Primary: an attending physician or nurse taking over a patient's care.
- Secondary: our case manager and prior-authorization coordinator, who read the summary to prepare discharge.

## 3. Functional requirements

| # | Requirement | Why |
|---|---|---|
| F1 | Read the chart **only** through MediTrack's FHIR API with a registered read-only client | We will not give a proof of concept database access |
| F2 | Produce a summary of one patient's stay: reason for admission, key events, results that matter, medicines, current status, what is pending | The clinician's first question is "what happened?" |
| F3 | **Every statement shows its source** in the chart (note, result or document) and the clinician can open it (Q) | We dropped a vendor for invented facts |
| F4 | Say "not documented" when the chart does not say, and never fill a gap by guessing (Q) | Trust |
| F5 | List what looks missing or pending (for example a result still outstanding) | This is what the insurer asks about |
| F6 | No diagnosis, no risk score, no treatment recommendation, no prediction | Outside our regulatory boundary |
| F7 | Read-only: nothing is written to the chart | Safety |
| F8 | Work for the three hand-written patients first (Hale, Doyle, Whitaker) and then for the full synthetic cohort | Known stories let us judge quality |

## 4. Non-functional requirements

| # | Requirement |
|---|---|
| N1 | Synthetic data only, in every environment, until our security review is passed |
| N2 | A model that runs under a signed business associate agreement if you want to move beyond synthetic data later; for the proof of concept a public model is acceptable on synthetic data only |
| N3 | A summary should appear in under about 30 seconds for the proof of concept |
| N4 | Show how long each summary took |
| N5 | Runs on your laptop or a demo machine; no deployment into our cluster yet |
| N6 | The model and prompt versions are written down so a result can be reproduced |

## 5. How we will judge it (acceptance)

1. For each of the three golden patients, two of our clinicians read the summary against the chart.
2. **Zero fabricated facts.** One invented fact fails the proof of concept for that patient.
3. Clinicians rate usefulness and accuracy from 1 to 5; we will agree the passing score when we see the first results.
4. You show us at least one case where the tool said "not documented" correctly.
5. You tell us honestly where it failed.

## 6. Out of scope for the proof of concept

Prior-authorization drafting, coding suggestions, a screen inside MediTrack, events, access control by ward, de-identification, audit, deployment, and a clinician-facing dashboard. These come later if the proof of concept earns them.

## 7. What we will provide

- The registered read-only FHIR client for the sandbox and a base address (Sam Whitlock).
- Two clinicians for one hour of grading each (Dr. Priya Raman on 4 West and Dr. Laura Whitfield on 5 South).
- Answers to questions within two working days.

## 8. What we need from you

- A short design document for the proof of concept before you build (high-level and low-level), for Sam and Walter.
- A weekly update, and a slide presentation to the sponsor group when it is ready.

## 9. Decisions this proof of concept will inform

Whether to proceed to a pilot on 4 West and 5 South, which of the three features (summary, prior-authorization drafting, coding suggestions) to build first, and how big the security review needs to be.
