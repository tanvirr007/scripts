import os
import shutil
import subprocess
import time

REPO_URL = "https://github.com/spes-development/vendor_xiaomi_spes"
FOLDER_NAME = "vendor_xiaomi_spes"
CLONE_COUNT = 50
CLONE_TIMEOUT = 600  # 10 minutes
DELAY_AFTER_CLONE = 15  # 15 seconds

def countdown(seconds):
    for i in range(seconds, 0, -1):
        print(f"Starting in {i}...", end='\r')
        time.sleep(1)
    print("Starting now...        ")

def delete_folder():
    if os.path.exists(FOLDER_NAME):
        print(f"Deleting existing folder: {FOLDER_NAME}")
        shutil.rmtree(FOLDER_NAME, ignore_errors=True)

def clone_repo():
    print(f"Cloning repository: {REPO_URL}")
    subprocess.run(
        ["git", "clone", REPO_URL],
        timeout=CLONE_TIMEOUT
    )

def main():
    countdown(30)
    for i in range(CLONE_COUNT):
        print(f"\n--- Attempt {i+1} of {CLONE_COUNT} ---")
        delete_folder()
        try:
            clone_repo()
        except subprocess.TimeoutExpired:
            print("Clone timed out! Skipping to next attempt.")
        except Exception as e:
            print(f"Clone failed: {e}")
        finally:
            delete_folder()
            print(f"Waiting {DELAY_AFTER_CLONE} seconds before next attempt...")
            time.sleep(DELAY_AFTER_CLONE)

if __name__ == "__main__":
    main()
