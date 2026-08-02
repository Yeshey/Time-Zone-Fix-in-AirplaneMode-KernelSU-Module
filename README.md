# Time-Zone-Fix-in-AirplaneMode-KernelSU-Module

- Airplane mode ON -> reads your current timezone from Settings, saves it to a file, disables auto-timezone, and forces that exact zone. No change, just frozen.
- Airplane mode OFF -> re-enables auto-timezone. Phone can detect new zones normally via cell towers.
- Reboot with airplane mode already on → reads the saved file and freezes to that zone. No default hardcoded.