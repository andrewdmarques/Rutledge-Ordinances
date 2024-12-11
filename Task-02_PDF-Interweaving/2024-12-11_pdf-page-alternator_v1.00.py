# This code is to combine a large set of PDFs where the first PDF is the odd pages and the second PDF is the even pages.
import PyPDF2

def alternate_pdf_pages(pdf1, pdf2, output_pdf):
    # Open both PDFs in read-binary mode
    with open(pdf1, 'rb') as file1, open(pdf2, 'rb') as file2:
        reader1 = PyPDF2.PdfReader(file1)
        reader2 = PyPDF2.PdfReader(file2)
        
        # Create a PDF writer object to write the output
        writer = PyPDF2.PdfWriter()
        
        # Get the number of pages in each PDF
        num_pages_1 = len(reader1.pages)
        num_pages_2 = len(reader2.pages)
        
        # Loop through the pages and alternate them
        for i in range(max(num_pages_1, num_pages_2)):
            if i < num_pages_1:
                writer.add_page(reader1.pages[i])  # Add odd pages (from the first PDF)
            if i < num_pages_2:
                writer.add_page(reader2.pages[i])  # Add even pages (from the second PDF)
        
        # Write the combined PDF to the output file
        with open(output_pdf, 'wb') as output_file:
            writer.write(output_file)
        print(f"Combined PDF saved as {output_pdf}")

# Example usage:
alternate_pdf_pages('2022-02_ordinance-xxx_large-odd.pdf', 
                    '2022-02_ordinance-xxx_large-even.pdf', 
                    '2022-02_ordinance-xxx_large.pdf')
