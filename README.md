# Behavior Studio — SWGEmu / SWGWorld

Behavior Studio és un editor gràfic d’**arbres de comportament (Behavior Trees)** utilitzat per treballar amb la lògica d’IA de **SWGEmu/Core3**. Aquesta branca manté l’estructura del projecte original i incorpora una modernització perquè es pugui executar i compilar en **Windows 11 x64** amb Python modern i Qt 6.

> **Estat actual:** v0.1.5 — port Windows 11 en validació. La modernització del runtime està feta, però abans de considerar-la una release estable cal completar les proves funcionals de GUI, càrrega de projectes Ground/Space, desat i generació Lua.

## Què permet fer

Behavior Studio permet:

- obrir projectes de Behavior Trees de SWGEmu;
- visualitzar gràficament la jerarquia dels arbres;
- editar nodes i propietats;
- treballar amb projectes **Ground** i **Space**;
- desar l’estructura editable de l’arbre;
- mantenir la disposició visual del diagrama;
- regenerar la sortida **Lua** utilitzada per SWGEmu/Core3;
- compilar una versió distribuïble per a Windows 11.

## Projectes SWGEmu inclosos

### Ground

~~~text
data\SWGEmu\SWGEmu.btproj
~~~

Inclou arbres com:

~~~text
default
pet
static
escort
deathWatch
enclaveSentinel
villageRaider
crackdown
cityPatrol
eventControl
herd
~~~

### Space

~~~text
data\SWGEmuSpace\SWGEmuSpace.btproj
~~~

Inclou, entre d’altres:

~~~text
default
spaceStations
escort
turretship
waveAttack
attackableSpaceStation
~~~

## Fitxers que utilitza Behavior Studio

Behavior Studio treballa principalment amb aquests formats:

| Extensió | Funció |
|---|---|
| `.btproj` | Manifest del projecte i llista d’arbres |
| `.xml` | Estructura editable del Behavior Tree |
| `.dgm` | Posició i representació visual dels nodes |
| `.lua` | Sortida generada per al runtime SWGEmu/Core3 |
| `node_library.xml` | Definició dels tipus de nodes disponibles |

Quan es desa un arbre, cal mantenir sincronitzats:

~~~text
XML + DGM + LUA
~~~

No és recomanable versionar només el Lua generat si també ha canviat la font editable de l’arbre.

## Modernització Windows 11

La versió original estava basada en una pila ja obsoleta:

~~~text
Python 2.7 32-bit
PySide 1.2.2
Qt 4
~~~

La branca actual s’ha adaptat a:

~~~text
Windows 11 x64
Python 3.10–3.14 x64
PySide6
Qt 6
lxml
sortedcontainers
regex
PyInstaller 6
~~~

S’ha intentat conservar al màxim el codi original. La compatibilitat entre els imports antics de PySide i PySide6 s’encapsula en una capa específica dins de `source\PySide\`.

També s’ha corregit el parser Lua perquè utilitzi el paquet `regex`, necessari per a les expressions regulars recursives emprades pel parser.

## Instal·lació a Windows 11

### 1. Crear l’entorn

Executa:

~~~bat
00_CREATE_ENV_WIN11.bat
~~~

Aquest script:

1. detecta un Python x64 compatible;
2. valida que sigui Python 3.10–3.14;
3. crea un entorn virtual local `.venv`;
4. actualitza pip/setuptools/wheel;
5. instal·la les dependències;
6. comprova PySide6/Qt6 i la resta del runtime.

Les dependències s’instal·len dins del projecte i no cal modificar el Python global del sistema.

### 2. Executar en mode desenvolupament

~~~bat
01_RUN_DEV_WIN11.bat
~~~

Aquest és el mode recomanat per diagnosticar errors perquè manté disponible la consola de Python.

### 3. Compilar l’executable

~~~bat
02_BUILD_EXE_WIN11.bat
~~~

PyInstaller genera una distribució de tipus **onedir**:

~~~text
dist\BehaviorStudio\
~~~

L’executable principal és:

~~~text
dist\BehaviorStudio\BehaviorStudio.exe
~~~

### 4. Executar la versió compilada

~~~bat
03_RUN_BUILT_EXE.bat
~~~

> **Important:** no s’ha de distribuir només `BehaviorStudio.exe`. Cal conservar tota la carpeta `dist\BehaviorStudio`, perquè conté les llibreries i els recursos externs necessaris.

## Obrir un projecte

Des de l’aplicació:

~~~text
File → Open project...
~~~

Per treballar amb IA terrestre:

~~~text
data\SWGEmu\SWGEmu.btproj
~~~

Per treballar amb IA espacial:

~~~text
data\SWGEmuSpace\SWGEmuSpace.btproj
~~~

La llista d’arbres apareixerà al panell **Behavior Trees**.

## Flux de treball recomanat

~~~text
SWGEmu.btproj / SWGEmuSpace.btproj
                │
                ▼
          Behavior Studio
                │
       editar Behavior Tree
                │
                ▼
       XML + DGM + Lua
                │
                ▼
         revisió amb Git
                │
                ▼
          SWGEmu / Core3
~~~

Behavior Studio **no** desplega automàticament els fitxers al servidor, no fa commits Git i no reinicia Core3.

Abans i després d’una modificació és recomanable revisar:

~~~bash
git status
git diff
~~~

## Estructura del repositori

~~~text
Behavior-Studio-SWGEmu/
├── config/
├── data/
│   ├── SWGEmu/
│   ├── SWGEmuSpace/
│   ├── icons/
│   └── signs/
├── source/
│   ├── PySide/
│   └── project/
├── tutorials/
├── 00_CREATE_ENV_WIN11.bat
├── 01_RUN_DEV_WIN11.bat
├── 02_BUILD_EXE_WIN11.bat
├── 03_RUN_BUILT_EXE.bat
├── BehaviorStudio.spec
├── requirements_win11.txt
├── CHANGELOG.md
├── COPYING
└── README.md
~~~

## Crear una Release de Windows

Després de validar el build, cal comprimir **tota** la carpeta:

~~~text
dist\BehaviorStudio
~~~

Nom recomanat:

~~~text
Behavior-Studio-SWGEmu-v0.1.5-Windows-x64.zip
~~~

Al Release de GitHub:

~~~text
Tag: v0.1.5
Títol: Behavior Studio SWGEmu v0.1.5 - Windows 11 x64
~~~

GitHub genera automàticament el codi font en ZIP i TAR.GZ associat al tag.

## Checklist abans de marcar una versió com estable

- [ ] `00_CREATE_ENV_WIN11.bat` finalitza correctament
- [ ] `01_RUN_DEV_WIN11.bat` obre la GUI
- [ ] `SWGEmu.btproj` carrega correctament
- [ ] `SWGEmuSpace.btproj` carrega correctament
- [ ] un arbre Ground es pot obrir i desar
- [ ] un arbre Space es pot obrir i desar
- [ ] XML generat correcte
- [ ] DGM generat correcte
- [ ] Lua generat correcte
- [ ] Undo / Redo funcional
- [ ] `02_BUILD_EXE_WIN11.bat` genera el build
- [ ] `BehaviorStudio.exe` arrenca correctament
- [ ] el build troba `config/`, `data/` i `tutorials/`

## Historial de la modernització

### v0.1.0
Primera adaptació per Windows 11, scripts d’entorn i primer build PyInstaller.

### v0.1.1
Millora del control d’errors durant la creació de l’entorn virtual.

### v0.1.2
Intent d’instal·lació automàtica de Python 3.10.11 x64.

### v0.1.3
Canvi a **PySide6 / Qt6** i compatibilitat amb Python 3.10–3.14 x64.

### v0.1.4
Normalització dels BAT a **CRLF** i simplificació del detector de Python.

### v0.1.5
Validació robusta de versió i arquitectura de Python mitjançant el mateix intèrpret.

Consulta també `CHANGELOG.md` per al detall de canvis.

## Llicència

Behavior Studio es distribueix sota **GNU General Public License v3 (GPLv3)** segons el fitxer `COPYING` del projecte original.

Aquesta branca:

- conserva la llicència original;
- manté l’atribució del projecte original;
- publica el codi font de les modificacions;
- documenta la modernització realitzada per a Windows 11 i l’ecosistema SWGEmu/SWGWorld.

Els fitxers procedents de projectes externs com SWGEmu/Core3 han de conservar, quan correspongui, la seva pròpia atribució i llicència.

## Objectiu del projecte

L’objectiu d’aquesta branca no és redissenyar Behavior Studio des de zero, sinó **preservar una eina útil de l’ecosistema SWGEmu i fer-la executable, mantenible i compilable en sistemes Windows actuals**.
