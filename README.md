
# Bakemonogatari PSP Model Importer for 3ds Max

This repository provides a **MaxScript** for importing 3D models from the PlayStation Portable (PSP) game **Bakemonogatari Portable** into Autodesk 3ds Max. The script processes `.amo` (mesh) and `.amt` (texture) files extracted from the game's CRI Ware CPK archives, converting them into editable 3D meshes within 3ds Max.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [File Extraction](#file-extraction)
- [Acknowledgments](#acknowledgments)
- [Additional Resources](#additional-resources)

## Features

- **Mesh Importing**: Parses `.amo` files to extract vertex, UV, normal, and face data.
- **Texture Handling**: Processes `.amt` files to apply textures to imported models.
- **Automatic Mesh Creation**: Generates 3D mesh objects in 3ds Max with proper scaling and orientation.
- **Support for Multiple Objects**: Handles models with multiple mesh sections and groups.
- **Backface Culling**: Applies backface culling to enhance model rendering.
- **Integration with Existing Tools**: Works alongside Python scripts like `fmt_BakemonogatariPSP_amo.py` for extended functionality.

## Prerequisites

- **Autodesk 3ds Max**: Ensure you have a compatible version of 3ds Max installed.
- **MaxScript**: Familiarity with running MaxScripts within 3ds Max.
- **QuickBMS**: Required for extracting files from CRI Ware CPK archives.
- **QuickBMS CPK Script**: [Download here](https://aluigi.altervista.org/bms/cpk.bms).
- **Python Environment** (Optional): For using additional import scripts like `fmt_BakemonogatariPSP_amo.py`.

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/coreynguyen/mxs_bakemonogatari_psp.git
   ```

2. **Copy the MaxScript File**

   Place the `imp_bakemonogatari.ms` script into your 3ds Max `Scripts` directory.

3. **Install QuickBMS**

   - Download QuickBMS from [aluigi's website](https://aluigi.altervista.org/quickbms.htm).
   - Extract the contents to a directory of your choice.

4. **Download the CPK Extraction Script**

   - Obtain the `cpk.bms` script from [here](https://aluigi.altervista.org/bms/cpk.bms).
   - Place it in the same directory as QuickBMS.

## Usage

### 1. Extracting Model Files

The game stores model data within CRI Ware CPK archives. To access `.amo` and `.amt` files:

1. **Run QuickBMS**

   Open QuickBMS and select the `cpk.bms` script.

2. **Select the CPK Archive**

   Choose the CPK file from the game directory, typically found in:
   
   ```
   \USRDIR\rom\rom.cpk
   ```

3. **Choose Output Directory**

   Specify a folder where the extracted files will be saved.

4. **Extract Files**

   QuickBMS will unpack the CPK archive, extracting files like `_NULL_` which contain `.amo` and `.amt` data.

### 2. Importing Models into 3ds Max

1. **Open 3ds Max**

2. **Run the MaxScript**

   - Navigate to `Scripting > Run Script`.
   - Select the `BakemonogatariImporter.ms` file.

3. **Select the `.amo` File**

   When prompted, navigate to the extracted `.amo` file, for example:

   ```
   .\PSP_GAME\USRDIR\rom\rom\_NULL\_NULL__00000b0a.amo
   ```

4. **Import Process**

   The script will parse the `.amo` and `.amt` files, creating mesh objects in your current 3ds Max scene.

## File Extraction

### Understanding `.amo` and `.amt` Files

- **`.amo` Files**: Contain mesh data including vertices, UV coordinates, normals, and face indices.
- **`.amt` Files**: Hold texture information associated with the models.

### Existing Tools and Scripts

- **Python Import Script**: [fmt_BakemonogatariPSP_amo.py](https://github.com/RoadTrain/noesis-plugins-official/blob/master/finale00/fmt_BakemonogatariPSP_amo.py) by finale00 is available for users preferring Python-based workflows.
- **Additional Resources**: Discussions and scripts by community members like finale00 and chrrox provide deeper insights into the model formats and extraction techniques.

### Handling CRI Ware CPK Files

The game utilizes CRI Ware's CPK format for asset storage. To extract these files:

1. **Use QuickBMS with `cpk.bms` Script**

   This combination effectively unpacks CPK archives, revealing the underlying `.amo` and `.amt` files.

2. **Dealing with `_NULL_` Files**

   Post-extraction, you may encounter files named `_NULL_`. These are containers for `.amo` and `.amt` data. Rename them accordingly or use scripts to automate the process.

## Acknowledgments

- **Community Contributions**: Special thanks to [finale00](https://github.com/finale00) and [chrrox](https://github.com/chrrox) for their Python import scripts and invaluable research on the Bakemonogatari model formats.
- **QuickBMS and Its Developers**: For providing powerful tools to extract game assets.
- **Noesis Team**: For creating versatile tools that complement this workflow.

## Additional Resources

For more technical details, research, and discussions related to the Bakemonogatari PSP model formats, please refer to the [Wiki](https://github.com/yourusername/bakemonogatari-psp-importer/wiki).

- **Bakemonogatari Model Formats**: Detailed exploration of `.amo` and `.amt` structures.
- **Vertex and Face Data**: Understanding how vertices, normals, and faces are stored and processed.
- **Community Forums**: Links to relevant threads and discussions for troubleshooting and advanced techniques.

---

*Happy modeling! If you encounter any issues or have suggestions, feel free to open an issue or contact the maintainers.*
