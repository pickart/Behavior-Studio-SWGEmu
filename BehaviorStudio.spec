# -*- mode: python ; coding: utf-8 -*-
from PyInstaller.utils.hooks import collect_submodules

hidden = []
hidden += collect_submodules('PySide6')

analysis = Analysis(
    ['source/behavior_studio_win11.py'],
    pathex=['source'],
    binaries=[],
    datas=[],
    hiddenimports=hidden + ['lxml', 'regex', 'sortedcontainers'],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)
pyz = PYZ(a.pure)
exe = EXE(pyz, a.binaries, a.datas, name='BehaviorStudio', icon=None, console=False, debug=False, strip=False, upx=True)
coll = COLLECT(exe, a.binaries, a.datas, strip=False, upx=True, name='BehaviorStudio')
