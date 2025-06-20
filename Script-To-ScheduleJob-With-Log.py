import os
import logging
import requests

# 1. Ensure the target directory exists
log_dir = r"C:\Nucleus-Jobs"
os.makedirs(log_dir, exist_ok=True)
log_path = os.path.join(log_dir, "response_output.txt")

# 2. Configure logging to append to C:\Jobs\response_output.txt AND stream to console
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)-8s %(message)s",
    handlers=[
        logging.FileHandler(log_path, encoding="utf-8"),
        logging.StreamHandler()
    ]
)

url = "https://prodedi.practiceautomations.com/HL7Dft/RunHL7Import"
response = requests.get(url)

if response.status_code == 200:
    logging.info(f"Result: {response.text}")
else:
    logging.error(f"Failed to fetch content. Status code: {response.status_code}")