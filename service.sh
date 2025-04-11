#!/system/bin/sh
# Asegúrate de que este script se ejecute con Magisk/KernelSU

# Espera un poco más después de que el arranque se complete para que el sistema se estabilice
# Espera hasta que la propiedad sys.boot_completed sea 1
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 1
done

# Espera 60 segundos adicionales para asegurar que todo esté listo
sleep 60

# --- Configuración ---
# Define el filtro de compilación a usar. Opciones comunes:
# speed-profile: Compila basado en perfiles de uso (recomendado, equilibrio).
# speed: Optimiza para velocidad de ejecución (puede usar más espacio).
# everything: Compila todo por adelantado (usa mucho más espacio, puede ralentizar la instalación/actualización).
# verify: Solo verifica el código (sin compilación AOT significativa).
# quitar ' ' si se descomenta la linea de abajo
# COMPILER_FILTER="speed-profile"
COMPILER_FILTER="speed-profile"

# Ruta al archivo de bandera para asegurar que el script se ejecute solo una vez
MODULE_DIR="/data/adb/modules/dexopt-boost" # Asegúrate que coincida con el 'id' en module.prop
FLAG_FILE="$MODULE_DIR/.ran_once"

# --- Lógica Principal ---

# Verifica si el script ya se ejecutó una vez
if [ -f "$FLAG_FILE" ]; then
  echo "Dex2OAT Boost: La recompilación ya se realizó una vez. Saliendo."
  exit 0
fi

echo "Dex2OAT Boost: Iniciando recompilación única de paquetes de terceros con el filtro '$COMPILER_FILTER'."
log -p i -t Dex2OAT_Boost "Iniciando recompilación única con filtro: $COMPILER_FILTER"

# Obtiene la lista de paquetes de terceros instalados
packages=$(pm list packages -3 | cut -d':' -f2)

# Itera sobre cada paquete y fuerza la recompilación
for pkg in $packages; do
  echo "Dex2OAT Boost: Recompilando $pkg..."
  log -p i -t Dex2OAT_Boost "Recompilando $pkg..."
  cmd package compile -m $COMPILER_FILTER -f $pkg
  # Pequeña pausa para no sobrecargar el sistema
  sleep 0.5
done

echo "Dex2OAT Boost: Recompilación completada."
log -p i -t Dex2OAT_Boost "Recompilación completada."

# Crea el directorio del módulo si no existe (necesario para el archivo de bandera)
mkdir -p $MODULE_DIR

# Crea el archivo de bandera para indicar que el script ya se ejecutó
touch "$FLAG_FILE"
echo "Dex2OAT Boost: Se creó el archivo de bandera $FLAG_FILE. La recompilación no se ejecutará en futuros arranques."
log -p i -t Dex2OAT_Boost "Se creó el archivo de bandera. No se ejecutará de nuevo."

exit 0

