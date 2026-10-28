# transformer

**One capability bit from GBT V8, packaged standalone.** No. 148 of 341,
`llm` domain (LLM).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 变压器（**核心已按成熟成品吃透后重做** 2026-09-27）：LLMLingua 的「显式预算 + 段落保护」（`compress=False` 思想 ⇒ **指令/结构段一字不动**，只压参考叙述，支持 rate/target_chars）+ GPTCache 的「近似命中」本地近似（simhash 汉明距离；**假命中禁令**：近似默认只报告不返答案，要答案须 allow_approx）+ autosize（上下文快满自动压 + **原文先落 spill 资料不丢**）；**可旁路 fail-open**（关键信息丢或没省下来 ⇒ 回原样）；**必给前后两个数**并记台账。op=compress/cache_get/cache_put/autosize/stats/selftest

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-transformer.git
cd gbt-transformer
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_transformer info                  # capability card
python -m gbt_transformer spec --json           # machine-readable contract
python -m gbt_transformer check --payload '{}'
python -m gbt_transformer run   --payload '{}'
```

Real `info` output from this machine:

```text
transformer  (llm)  v1.0.0
----------------------------------------
变压器（**核心已按成熟成品吃透后重做** 2026-09-27）：LLMLingua 的「显式预算 + 段落保护」（`compress=False` 思想 ⇒ **指令/结构段一字不动**，只压参考叙述，支持 rate/target_chars）+ GPTCache 的「近似命中」本地近似（simhash 汉明距离；**假命中禁令**：近似默认只报告不返答案，要答案须 allow_approx）+ autosize（上下文快满自动压 + **原文先落 spill 资料不丢**）；**可旁路 fail-open**（关键信息丢或没省下来 ⇒ 回原样）；**必给前后两个数**并记台账。op=compress/cache_get/cache_put/autosize/stats/selftest

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : compress, cache_get, cache_put, autosize, stats, selftest
```

Wire a real implementation:

```python
from gbt_transformer import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`compress`、`cache_get`、`cache_put`、`autosize`、`stats`、`selftest`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `transformer` |
| domain | `llm` |
| handler | `transformer` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [llm/transformer](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/llm/transformer.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
