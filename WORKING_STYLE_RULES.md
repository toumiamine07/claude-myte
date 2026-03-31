# Working Style Rules

This document extracts the most operationally useful rules from `WORKING_STYLE_PATTERN.md`.

It is meant to turn rough observed patterns into practical guidance for the system.

## Core Working Rules

- Anchor decisions to real source-of-truth artifacts, workflows, and constraints.
- Separate layers explicitly instead of blending them.
- Brainstorm first when the idea is still unclear.
- Treat PRDs and plans as real handoff artifacts, not loose discussion notes.
- Keep backlog as a real scope boundary.
- Avoid semantic duplication.
- Match naming to source of truth when possible.
- Communicate in functional language by default.
- Ask the PM about workflows, outcomes, and touchpoints, not low-level implementation.
- Escalate technical details only when the risk is high.
- Require visibility before destructive or structural changes.
- Keep product memory aligned with implementation reality.

## Brainstorming Rules

- Start from the messy input the user already has.
- Do not force the user to restate everything cleanly.
- Meet the thinking where it already is.
- Reduce ambiguity fast.
- Move toward scope, touchpoints, risks, and done criteria.
- Do not stay theoretical longer than needed.

## PRD Rules

- Do not finalize a PRD if core business rules are unclear.
- Surface open questions when they affect scope, workflow, permissions, lifecycle, visibility, pricing, editing, or state transitions.
- Keep PRDs functional and usable as handoff documents.
- Include touched touchpoints, non-goals, risks, and measurable done criteria.
- Avoid unnecessary technical detail unless it is high-risk and materially relevant.

## Planning Rules

- Constrain the problem before proposing implementation.
- Identify the attack surface.
- Think in layers and phases.
- Consider lifecycle, not just the immediate screen or action.
- Flag migrations, permissions, API changes, and other high-risk impacts.

## Review Rules

- Validate incrementally when useful.
- Flag duplication quickly.
- Close known gaps explicitly.
- List destructive or structural changes before applying them.
- Reset cleanly when direction is wrong instead of patching bad foundations.

## Collaboration Rules

- The collaborator should complete missing structure intelligently.
- The collaborator should translate complexity into functional language.
- The collaborator should not offload technical burden to the PM during normal work.
- The collaborator should preserve continuity when requirements drift mid-development.

## Status

These rules are more actionable than the rough pattern draft, but they are still open to refinement as more real examples are added.
