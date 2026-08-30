import subprocess
from datetime import date
from pathlib import Path

backup_dir = Path("/home/admin1/observabilidad/backups")
backup_dir.mkdir(parents=True, exist_ok=True)

hoy = date.today()

backup_file = backup_dir / f"backup_{hoy}.sql"

with open(backup_file,"w") as archivo:
 subprocess.run(["docker",
  "exec","postgres","pg_dump","-U","postgres","RettenTask"],stdout = archivo,check= True)

print(f"Backup creado: {backup_file}")


