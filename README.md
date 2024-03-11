# VHDX-toolbox-from-batch
Create, expand, compacting, differencing and merge VHDX (Virtual Hard Disk v2) files with one click.

> **For existing VHDX file:** \
> You can create, expand, and compacting it direcly. \
> You can differencing/merge them as long as it meets the following rules:
### 1. Within the differencing chain:
`<vhdName>_v0.vhdx` → `<vhdName>_v1.vhdx` → ... → `<vhdName>_vN.vhdx` → `<vhdName>.vhdx` (current)
### 2. Out of the differencing chain:
`<vhdName>_v0_archived.vhdx` → ... → `<vhdName>_vM_archived.vhdx` → \
[ `<vhdName>_v{M+1}.vhdx` → ... → `<vhdName>_vN.vhdx` → `<vhdName>.vhdx` (active chain) ]

## Notes
A fully merge operation on above sisuation will reserve the `<vhdName>_v{M+1}.vhdx` file and rename it to `<vhdName>_v{M+1}_archived.vhdx`.
