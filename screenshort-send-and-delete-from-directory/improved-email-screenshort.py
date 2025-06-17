import os
import smtplib
import zipfile
from datetime import datetime
from email.message import EmailMessage
from email.utils import formatdate
from pathlib import Path
import mimetypes

# === CONFIGURATION ===
BASE_DIR = Path("C:/Users/UMER/Pictures/Screenshots")
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
EMAIL_SENDER = "zain@adnare.com"            # Replace with your email
EMAIL_PASSWORD = "bufuywiwoskyhcla"             # Use app password if Gmail has 2FA
EMAIL_RECIPIENT = "kevin@adnare.com"  # Replace with recipient

# === GET TODAY'S FOLDER ===
today_str = datetime.now().strftime("%Y-%m-%d")
today_folder = BASE_DIR / today_str

# === SEND EMAIL FUNCTION ===
def send_email(subject, body, attachment_path=None):
    msg = EmailMessage()
    msg["From"] = EMAIL_SENDER
    msg["To"] = EMAIL_RECIPIENT
    msg["Subject"] = subject
    msg["Date"] = formatdate(localtime=True)
    msg.set_content(body)

    if attachment_path and attachment_path.exists():
        with open(attachment_path, "rb") as f:
            mime_type, _ = mimetypes.guess_type(attachment_path)
            maintype, subtype = mime_type.split("/") if mime_type else ("application", "octet-stream")
            msg.add_attachment(f.read(), maintype=maintype, subtype=subtype, filename=attachment_path.name)

    try:
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as smtp:
            smtp.starttls()
            smtp.login(EMAIL_SENDER, EMAIL_PASSWORD)
            smtp.send_message(msg)
        return True
    except Exception as e:
        print(f"[!] Failed to send email: {e}")
        return False

# === MAIN WORKFLOW ===
def main():
    if not today_folder.exists():
        subject = f"No Screenshots Found - {today_str}"
        body = f"Today, the VM was not logged in or no screenshots folder was found for {today_str}."
        send_email(subject, body)
        return

    image_files = list(today_folder.glob("*.jpg")) + list(today_folder.glob("*.jpeg")) + list(today_folder.glob("*.png"))

    if not image_files:
        subject = f"No Screenshots Found - {today_str}"
        body = f"Today, the VM was not logged in or no screenshots were found for {today_str}."
        send_email(subject, body)
        return

    # Create ZIP
    zip_path = BASE_DIR / f"screenshots_{today_str}.zip"
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        for image in image_files:
            zipf.write(image, arcname=image.name)

    # Send ZIP via email
    subject = f"Daily Screenshots - {today_str}"
    body = f"Attached are the screenshots taken on {today_str}."
    if send_email(subject, body, zip_path):
        for image in image_files:
            try:
                image.unlink()
            except Exception as e:
                print(f"[!] Failed to delete {image}: {e}")

# === RUN ===
if __name__ == "__main__":
    main()
