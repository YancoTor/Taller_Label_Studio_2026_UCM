import os
import json
import xml.etree.ElementTree as ET

# --- CONFIGURACIÓN ---
XML_DIR = 'page' 
IMAGE_BASE_URL = '/data/local-files/?d=media/upload/imagenes_taller/'
OUTPUT_FILE = 'import_final_layout.json'
NS = {'ns': 'http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15'}

ls_tasks = []

def get_points(elem, img_w, img_h):
    coords_elem = elem.find('ns:Coords', NS)
    if coords_elem is not None:
        points_str = coords_elem.get('points')
        if points_str:
            points = []
            for p in points_str.split():
                try:
                    x_s, y_s = p.split(',')
                    points.append([(float(x_s) / img_w) * 100, (float(y_s) / img_h) * 100])
                except ValueError: continue
            return points
    return None

def get_full_region_text(region_elem):
    """Concatena el texto de las líneas con saltos de línea reales."""
    lines_text = []
    # Buscamos el texto de cada línea individual dentro de la región
    for line in region_elem.findall('.//ns:TextLine', NS):
        unicode_elem = line.find('.//ns:Unicode', NS)
        if unicode_elem is not None and unicode_elem.text:
            # Limpiamos espacios y añadimos a la lista
            lines_text.append(unicode_elem.text.strip())
    
    # Si la región tiene texto propio pero no líneas (raro pero posible)
    if not lines_text:
        region_unicode = region_elem.find('./ns:TextEquiv/ns:Unicode', NS)
        if region_unicode is not None and region_unicode.text:
            lines_text.append(region_unicode.text.strip())
            
    # UNIMOS CON SALTO DE LÍNEA REAL (\n)
    return "\n".join(lines_text)

if not os.path.exists(XML_DIR):
    print(f"Error: No se encuentra la carpeta '{XML_DIR}'")
else:
    for filename in os.listdir(XML_DIR):
        if not filename.endswith('.xml'): continue
        
        file_path = os.path.join(XML_DIR, filename)
        try:
            tree = ET.parse(file_path)
            root = tree.getroot()
        except: continue
        
        page_elem = root.find('ns:Page', NS)
        if page_elem is None: continue
        
        img_w = float(page_elem.get('imageWidth')) #
        img_h = float(page_elem.get('imageHeight')) #
        img_name = filename.replace('.xml', '.jpg')
        
        task = {
            "data": {"ocr": f"{IMAGE_BASE_URL}{img_name}"},
            "predictions": [{"result": [], "score": 1.0}]
        }

        # Procesamos solo las regiones grandes (Layout)
        for region in page_elem:
            tag_name = region.tag.split('}')[-1]
            if tag_name.endswith('Region'):
                region_id = region.get('id')
                reg_points = get_points(region, img_w, img_h)
                # Obtenemos el texto formateado con saltos de línea
                full_text = get_full_region_text(region)

                if reg_points:
                    # Polígono de la región
                    task["predictions"][0]["result"].append({
                        "id": region_id,
                        "from_name": "polygon",
                        "to_name": "image",
                        "type": "polygonlabels",
                        "value": {"points": reg_points, "polygonlabels": ["Text"]}
                    })
                    # Texto multilínea unificado
                    task["predictions"][0]["result"].append({
                        "id": region_id,
                        "from_name": "transcription",
                        "to_name": "image",
                        "type": "textarea",
                        "value": {"text": [full_text]}
                    })

        ls_tasks.append(task)

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(ls_tasks, f, indent=2, ensure_ascii=False)

    print(f"¡Listo! Se ha generado '{OUTPUT_FILE}' con texto multilínea.")
