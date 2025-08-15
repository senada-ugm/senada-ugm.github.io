#!/usr/bin/env python3
"""
Extract base64 encoded images from the SENADA lab presentation XML file.
"""

import re
import base64
import os
from pathlib import Path

def extract_images_from_xml(xml_file_path, output_dir):
    """
    Extract all base64 encoded images from XML file and save them as separate files.
    """
    # Create output directory if it doesn't exist
    Path(output_dir).mkdir(parents=True, exist_ok=True)
    
    print(f"Reading XML file: {xml_file_path}")
    
    # Read the XML file
    try:
        with open(xml_file_path, 'r', encoding='utf-8') as file:
            content = file.read()
    except Exception as e:
        print(f"Error reading file: {e}")
        return
    
    # Find all base64 image data
    # Pattern matches: data:image/type;base64,base64data
    pattern = r'data:image/([^;]+);base64,([A-Za-z0-9+/=]+)'
    matches = re.findall(pattern, content)
    
    print(f"Found {len(matches)} embedded images")
    
    extracted_count = 0
    
    for i, (image_type, base64_data) in enumerate(matches, 1):
        try:
            # Decode base64 data
            image_data = base64.b64decode(base64_data)
            
            # Determine file extension - handle special cases
            if image_type.lower() == '*':
                # Generic type, try to determine from data
                if image_data.startswith(b'\x89PNG'):
                    extension = 'png'
                elif image_data.startswith(b'\xff\xd8\xff'):
                    extension = 'jpg'
                elif image_data.startswith(b'GIF8'):
                    extension = 'gif'
                else:
                    extension = 'bin'  # Unknown format
            elif image_type.lower() in ['jpeg', 'jpg']:
                extension = 'jpg'
            elif image_type.lower() == 'png':
                extension = 'png'
            elif image_type.lower() == 'gif':
                extension = 'gif'
            elif image_type.lower() == 'webp':
                extension = 'webp'
            else:
                extension = 'jpg'  # Default to jpg for unknown types
            
            # Create filename
            filename = f"senada_presentation_{i:02d}.{extension}"
            filepath = os.path.join(output_dir, filename)
            
            # Save image
            with open(filepath, 'wb') as img_file:
                img_file.write(image_data)
            
            print(f"Extracted: {filename} ({len(image_data)} bytes, type: {image_type})")
            extracted_count += 1
            
        except Exception as e:
            print(f"Error extracting image {i}: {e}")
    
    print(f"\nSuccessfully extracted {extracted_count} images to {output_dir}")
    return extracted_count

def main():
    # File paths
    xml_file = r"C:\Users\guntu\Documents\Project\SENADA-UGM\senada-ugm.github.io\raw\Presentasi Lab RPLD.xml"
    output_directory = r"C:\Users\guntu\Documents\Project\SENADA-UGM\senada-ugm.github.io\assets\images\presentation"
    
    print("SENADA Lab Presentation Image Extractor")
    print("=" * 50)
    
    # Check if XML file exists
    if not os.path.exists(xml_file):
        print(f"Error: XML file not found at {xml_file}")
        return
    
    # Extract images
    extract_images_from_xml(xml_file, output_directory)
    
    print("\nExtraction complete!")
    print(f"Images saved to: {output_directory}")

if __name__ == "__main__":
    main()