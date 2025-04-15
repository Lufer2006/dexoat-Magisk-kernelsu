#!/system/bin/sh
# Asegúrate de que este script se ejecute con Magisk/KernelSU

# Espera un poco más después de que el arranque se complete para que el sistema se estabilice
# Espera hasta que la propiedad sys.boot_completed sea 1
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 1
done

# Espera adicional para asegurar que todo esté listo (puedes ajustar este valor si es necesario)
sleep 60

# --- Configuración ---
# Define el filtro de compilación a usar. Opciones comunes:
# speed-profile: Compila basado en perfiles de uso (recomendado, equilibrio).
# speed: Optimiza para velocidad de ejecución (puede usar más espacio).
# everything: Compila todo por adelantado (usa mucho más espacio, puede ralentizar la instalación/actualización).
# verify: Solo verifica el código (sin compilación AOT significativa).
# quicken: Un filtro de optimización menos agresivo que 'speed'.
# space-profile: Optimiza para tamaño basado en perfiles.
# space: Optimiza para tamaño.
COMPILER_FILTER="speed-profile" # Puedes cambiar esto según tus preferencias

# --- Lógica Principal ---

echo "Dex2OAT Boost: Iniciando recompilación de paquetes de terceros con el filtro '$COMPILER_FILTER'."
log -p i -t Dex2OAT_Boost "Iniciando recompilación con filtro: $COMPILER_FILTER en cada arranque."

# Obtiene la lista de paquetes de terceros instalados
# Usamos 'pm list packages -3 -f' para obtener la ruta completa, aunque solo necesitamos el nombre del paquete.
# El 'cut -d':' -f2 | sed 's/package=//'' extrae solo el nombre del paquete.
packages=$(pm list packages -3 -f | cut -d':' -f2 | sed 's/package=//')

# Verifica si se obtuvieron paquetes
if [ -z "$packages" ]; then
  echo "Dex2OAT Boost: No se encontraron paquetes de terceros para recompilar."
  log -p w -t Dex2OAT_Boost "No se encontraron paquetes de terceros."
  exit 0
fi

# Itera sobre cada paquete y fuerza la recompilación
for pkg in $packages; do
  # Verifica si el paquete todavía existe antes de intentar compilarlo
  if pm list packages | grep -q "^package:$pkg$"; then
    echo "Dex2OAT Boost: Recompilando $pkg..."
    log -p i -t Dex2OAT_Boost "Recompilando $pkg..."
    # Ejecuta el comando de compilación
    cmd package compile -m $COMPILER_FILTER -f "$pkg"
    # Pequeña pausa para no sobrecargar el sistema (ajustable)
    sleep 0.5
  else
    echo "Dex2OAT Boost: El paquete $pkg ya no existe, omitiendo."
    log -p w -t Dex2OAT_Boost "El paquete $pkg ya no existe, omitiendo."
  fi
done

echo "Dex2OAT Boost: Recompilación completada para este arranque."
log -p i -t Dex2OAT_Boost "Recompilación completada."

exit 0
