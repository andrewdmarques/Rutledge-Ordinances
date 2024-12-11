# Rutledge Ordinance Project 2024
## Overview
This repository houses the scripts developed for the codification project of Rutledge Borough, Pennsylvania. The tools here were designed and implemented by Andrew D. Marques, who served as a part-time temporary Clerical Assistant for the Borough of Rutledge. The project's scope spans the collection and organization of borough ordinances passed from 2001 to 2024, facilitating their digital availability.
## Project Objectives
The primary goal of this initiative is to modernize access to municipal legislation, thereby supporting Rutledge Borough in addressing any legislative discrepancies and aligning local laws with those of Delaware County and the State of Pennsylvania. This effort is in collaboration with General Code (eCode360), enhancing the borough’s legal framework for improved governance and public access.
## Impact
The successful implementation of these scripts ensures comprehensive legal transparency but also makes these ordinances accessible to all residents former, present, and future.

# Task-01: Optical Character Recognition to Identify Relevant PDFs

This repository contains a Python script that extracts text from PDF files using Optical Character Recognition (OCR). The script supports processing PDFs stored in a specified input directory and outputs text files for each page in four orientations. Additionally, it generates a CSV log detailing the files processed.

## Features

- **Recursive PDF Search:** Automatically locates and processes all PDF files within the specified input directory, including its subdirectories.
- **Multiple Orientations:** Converts each page of the PDF files into text at 0°, 90°, 180°, and 270° rotations.
- **Logging:** Outputs a CSV file with the list of processed PDFs along with their original locations.
- **Progress Reporting:** Displays real-time processing information and summary statistics upon completion.

## Requirements

- Python 3.6+
- PyMuPDF
- Pillow
- pytesseract
- Tesseract-OCR

Ensure that Tesseract-OCR is installed on your system and accessible via the system PATH or configured directly in the script.

## Download Borough Ordinances

Download all digital files freely accessible online. 

```
wget --recursive --no-parent --no-clobber --directory-prefix=./ https://rutledgepa.org/wp-content/uploads/
```
Alternatively, an archived version may be accessed at [doi:10.5281/zenodo.14056462](https://zenodo.org/records/14056462)

## Usage

Set the `dir_in` and `dir_out` variables in the script to your desired input and output directories, respectively:

```
dir_in = '/path/to/your/input/directory'
dir_out = '/path/to/your/output/directory'
```

Run the script with:

```
python3 pdf2text_v2.04.py
```

## Output

- Text files for each PDF page, saved in four orientations, in the specified output directory.
- A CSV log file `processed_files_log.csv` in the output directory, recording each processed PDF's file name and directory location.

## Example 

![Example Image 1](Images/example_original.jpg)

![Example Image 1](Images/example_angle-180.jpg)

## Custom Configuration

- Modify `tesseract_cmd` path in the script if Tesseract-OCR is not in your system PATH:
  ```
  pytesseract.pytesseract.tesseract_cmd = '/path/to/tesseract'
  ```

- Change the page orientations as needed by modifying the `angle` list in the `extract_text_from_pdf` function.

## License

This project is open source and available under the [MIT License](LICENSE).

