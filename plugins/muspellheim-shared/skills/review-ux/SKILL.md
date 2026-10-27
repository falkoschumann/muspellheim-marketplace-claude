---
name: review-ux
description:
  Reviews UI code or screens for usability against the dialogue principles of
  ISO 9241-110 (heuristic evaluation). Use for reviews of components, forms, and
  flows, or when the user asks for a UX review.
---

# UX Review per ISO 9241-110

Goal: Find usability problems in UI code before users run into them, and propose
concrete, actionable improvements. The yardstick is the dialogue principles of
ISO 9241-110 and the context of use of the application, not personal taste.

Only report findings. Do not change code unless the user asks for it.

## Procedure

1. **Clarify the context of use:** Who uses the feature, what task are they
   trying to accomplish, and in what environment? Derive it from the backlog,
   the domain model, and the README. Ask briefly only when it cannot be derived;
   otherwise state your assumptions.
2. **Inspect the UI:** Read the affected components. When possible, also look at
   the running application, because layout, contrast, and focus are hard to
   judge from code alone.
3. **Check each principle:**
   - Suitability for the task: Does the UI support the task without unnecessary
     steps?
   - Self-descriptiveness: Is it clear at all times where the user is and what
     is possible?
   - Conformity with user expectations: Consistent with conventions, with the
     rest of the app, and with the users' domain terms?
   - Learnability: Is learning supported (hints, examples, sensible defaults)?
   - Controllability: Can the user control pace, order, and cancellation?
   - Use error robustness: Are errors prevented, detected, and easy to correct?
   - User engagement: Does the UI appear trustworthy and treat users with
     respect (tone of texts, no dark patterns)?
   - Accessibility (beyond ISO 9241-110): Is everything operable by keyboard,
     with visible focus and accessible names?

   For new or rarely used flows, also walk through them as a first-time user
   without prior knowledge: Where do they get stuck, which terms do they not
   understand, which next step is unclear?

4. **Record the findings.**

## Output format

For each finding:

- Location (file/line or screen)
- Affected principle (only the primary one, to avoid duplicates)
- Problem
- Severity:
  - critical: the task cannot be completed, or data is lost
  - serious: the task is considerably harder or error-prone, but a workaround
    exists
  - minor: irritating, but costs little time
- Concrete suggestion for improvement

Sorted by severity. At the end: what is already done well.

## Limits

The result is an expert judgment, not a user test. Mark assumptions about user
behavior as such, and recommend testing with representative users when findings
are uncertain.
