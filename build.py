import os
import subprocess
import zipfile
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

# 1. Collect all .java files
java_files = list(BASE_DIR.glob("src/main/java/**/*.java"))
print(f"Found {len(java_files)} Java source files")

classes_dir = BASE_DIR / "build" / "classes"
classes_dir.mkdir(parents=True, exist_ok=True)

# Write sources to file using forward slashes and quotes
sources_file = BASE_DIR / "build" / "sources.txt"
with open(sources_file, "w", encoding="utf-8") as f:
    for jf in java_files:
        posix_path = jf.resolve().as_posix()
        f.write(f'"{posix_path}"\n')

# Classpath with lib/*.jar
lib_dir = BASE_DIR / "lib"
cp_entries = [jar.resolve().as_posix() for jar in lib_dir.glob("*.jar")]
classpath = ";".join(cp_entries)

cmd = ["javac", "-encoding", "UTF-8", "-cp", classpath, "-d", classes_dir.resolve().as_posix(), f"@{sources_file.resolve().as_posix()}"]
print("Compiling Java classes with javac...")
res = subprocess.run(cmd, capture_output=True, text=True)
if res.returncode != 0:
    print("Compilation failed:")
    print(res.stderr)
else:
    class_files = list(classes_dir.glob("**/*.class"))
    print(f"SUCCESS: Compiled {len(class_files)} .class files into build/classes/")

    # Package as PlacementManagement.war in build/
    war_path = BASE_DIR / "build" / "PlacementManagement.war"
    webapp_dir = BASE_DIR / "src" / "main" / "webapp"
    
    with zipfile.ZipFile(war_path, "w", zipfile.ZIP_DEFLATED) as war:
        for f in webapp_dir.rglob("*"):
            if f.is_file():
                rel = f.relative_to(webapp_dir)
                war.write(f, str(rel))
        
        for cf in classes_dir.rglob("*.class"):
            rel_class = cf.relative_to(classes_dir)
            war.write(cf, f"WEB-INF/classes/{rel_class.as_posix()}")
        
        for jar in lib_dir.glob("*.jar"):
            war.write(jar, f"WEB-INF/lib/{jar.name}")

    print(f"SUCCESS: Packaged {war_path.name} ({war_path.stat().st_size // 1024} KB) ready for Tomcat deployment!")
