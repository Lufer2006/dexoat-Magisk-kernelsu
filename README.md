#¿Cómo funciona?

Tipo de Módulo: Es un módulo para Magisk o KernelSU, herramientas que permiten modificar el sistema Android sin alterar la partición /system directamente.
Acción Principal: El módulo ejecuta un script (service.sh) una única vez, justo después del primer reinicio completo del dispositivo tras la instalación del módulo.
Recompilación Forzada: Este script le ordena al sistema Android (usando el comando cmd package compile) que recompile todas las aplicaciones que tú (el usuario) has instalado (las llamadas "aplicaciones de terceros").
Filtro de Optimización: Por defecto, utiliza el filtro de compilación "speed-profile". Este filtro busca un equilibrio: intenta optimizar las partes más usadas de las aplicaciones para que se ejecuten más rápido, basándose en perfiles de uso que el sistema genera, sin aumentar excesivamente el espacio de almacenamiento que ocupan las apps.
Ejecución Única: Para evitar ralentizar el dispositivo en cada arranque, el script crea un archivo marcador (.ran_once) después de ejecutarse. En los siguientes reinicios, el script verá que el marcador existe y no hará nada más.
¿Cómo se instala?

#Flasheo: 
Abre la aplicación Magisk Manager o KernelSU Manager en tu dispositivo, ve a la sección de Módulos, selecciona "Instalar desde almacenamiento" y elige el archivo ZIP que creaste.
Reinicio: Una vez instalado, reinicia tu dispositivo. El módulo hará su trabajo automáticamente en segundo plano después de que el sistema haya arrancado completamente (tras una espera adicional de 60 segundos para asegurar estabilidad).
Versiones Requeridas:

Magisk/KernelSU: Necesitas tener Magisk o KernelSU instalado y funcionando correctamente. Versiones recientes son recomendables.
Android: El comando cmd package compile y los filtros de compilación son parte de Android desde hace varias versiones (generalmente desde Android 7 Nougat en adelante). Sin embargo, su comportamiento y efectividad pueden variar. Es más probable que funcione como se espera en versiones de Android 9 (Pie) o superiores. La compatibilidad exacta puede depender del fabricante y la versión específica de Android.

#¿Cuándo NO instalarlo?

Si no tienes Root (Magisk/KernelSU): El módulo necesita estos permisos para funcionar.
Si no estás seguro o te preocupan los riesgos: Existe una pequeña posibilidad de causar inestabilidad, reinicios inesperados (bootloops) o un mayor consumo de batería. Si no estás cómodo con esto, es mejor no instalarlo. Siempre haz una copia de seguridad antes.
Si tu dispositivo ya es inestable: No añadas modificaciones que podrían empeorar la situación.
Si tienes muy poco espacio de almacenamiento: Aunque "speed-profile" es moderado, si modificaras el script para usar filtros más agresivos como "speed" o "everything", el espacio ocupado por las aplicaciones compiladas podría aumentar notablemente.
Si prefieres dejar que Android gestione la optimización: El sistema operativo ya tiene sus propios métodos para optimizar apps (a menudo llamados dexopt en segundo plano) que suelen estar bien ajustados. Forzar un método podría no ser beneficioso.
En ROMs personalizadas muy modificadas: Algunas ROMs ya incluyen sus propias optimizaciones o cambios en cómo funciona la compilación. Este módulo podría entrar en conflicto con ellas.
