import os
import threading


class PersistentCounter:
    def __init__(self, filepath, autosave_interval=10):
        self.filepath = filepath
        self.counter = 0
        self._load()
        self._last_saved_value = self.counter

        self.autosave_interval = autosave_interval  # seconds
        self._stop_event = threading.Event()

        self._autosave_thread = threading.Thread(
            target=self._autosave_loop, daemon=True
        )
        self._autosave_thread.start()

    def _load(self):
        if os.path.exists(self.filepath):
            try:
                with open(self.filepath, "r") as f:
                    self.counter = int(f.read().strip())
            except Exception:
                print("Failed to load counter from file. Starting from zero.")
                self.counter = 0

    def _save(self):
        if self.counter == self._last_saved_value:
            return
        tmp_file = self.filepath + ".tmp"
        try:
            with open(tmp_file, "w") as f:
                f.write(str(self.counter))
            os.replace(tmp_file, self.filepath)
            self._last_saved_value = self.counter
        except Exception as e:
            print(f"Failed to save counter to file: {e}")

    def get_and_increment(self):
        self.counter += 1
        return self.counter

    def _autosave_loop(self):
        while not self._stop_event.wait(self.autosave_interval):
            self._save()

    def stop(self):
        self._stop_event.set()
        self._autosave_thread.join()
        self._save()
