import fitz  # PyMuPDF
from PIL import Image
import pytesseract
import io
import re
import os
import csv
import time
from pathlib import Path

# Set tesseract executable path for Linux
pytesseract.pytesseract.tesseract_cmd = '/usr/bin/tesseract'

dir_in = '/media/andrewdmarques/Data011/Personal/PDF2Text/rutledgepa.org'
dir_out = '/media/andrewdmarques/Data011/Personal/PDF2Text/Converted-PDF2Text'
os.makedirs(dir_out, exist_ok=True)  # Ensure output directory exists

def find_pdfs(directory):
    """Recursively find all PDF files in the given directory."""
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.pdf'):
                yield os.path.join(root, file)

def extract_text_from_image(image):
    """Perform OCR on the image and return the extracted text."""
    try:
        return pytesseract.image_to_string(image)
    except Exception as e:
        print("Error performing OCR:", e)
        return ""

def rotate_image(image, degree):
    """Rotate image by a given degree and return the rotated image."""
    return image.rotate(degree, expand=True)

def extract_text_from_pdf(pdf_path):
    """Extract text from each page of the PDF file for all four orientations."""
    doc = fitz.open(pdf_path)
    base_name = os.path.basename(pdf_path)

    for page_number in range(len(doc)):
        page = doc.load_page(page_number)
        pix = page.get_pixmap()
        original_img = Image.open(io.BytesIO(pix.tobytes()))

        # Generate text for each orientation and save to a separate file
        for angle in [0, 90, 180, 270]:
            rotated_img = rotate_image(original_img, angle)
            text = "***************" + pdf_path + "***************\n" + extract_text_from_image(rotated_img)
            file_path = os.path.join(dir_out, f'{base_name}_page-{page_number+1}_angle-{angle}.txt')
            save_text_to_file(text, file_path)
            print(f"Text extracted and saved to {file_path}")

    doc.close()

def save_text_to_file(text, file_path):
    """Save extracted text to a file."""
    with open(file_path, 'w') as file:
        file.write(text)

def save_csv_log(data, csv_path):
    """Save log data to a CSV file."""
    with open(csv_path, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['file_name', 'dir_location'])
        writer.writerows(data)

# Processing
start_time = time.time()
pdf_files = list(find_pdfs(dir_in))
csv_data = []

for i, pdf_path in enumerate(pdf_files):
    print(f'Processing {i+1}/{len(pdf_files)}: {pdf_path}')
    extract_text_from_pdf(pdf_path)
    csv_data.append([os.path.basename(pdf_path), pdf_path])

csv_path = os.path.join(dir_out, 'processed_files_log.csv')
save_csv_log(csv_data, csv_path)
elapsed_time = time.time() - start_time
print(f"Completed processing {len(pdf_files)} files in {elapsed_time:.2f} seconds")
