#!/bin/bash

# INPUT followed by OUTPUT

# Cores para o terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SOURCE="$1"
TARGET="$2"

if [ -z "$SOURCE" ] || [ -z "$TARGET" ]; then
    echo -e "${RED}Erro: Informe a origem e o destino.${NC}"
    echo "Exemplo: ./honda_fit_mover.sh /home/lu/Musicas /media/lu/PENDRIVE"
    exit 1
fi

# Instalação automática do exiftool se necessário
if ! command -v exiftool &> /dev/null; then
    echo -e "${YELLOW}Instalando exiftool...${NC}"
    sudo apt update && sudo apt install -y libimage-exiftool-perl
fi

echo -e "${YELLOW}--- Iniciando MOVIMENTAÇÃO por Album Artist ---${NC}"

# Usamos -print0 para lidar com nomes de arquivos complexos
find "$SOURCE" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.m4a" \) -print0 | while IFS= read -r -d '' FILE; do
    
    # 1. Extração de Tags (Prioridade para Album Artist)
    ARTISTA=$(exiftool -s3 -AlbumArtist "$FILE")
    [ -z "$ARTISTA" ] && ARTISTA=$(exiftool -s3 -Band "$FILE")
    [ -z "$ARTISTA" ] && ARTISTA=$(exiftool -s3 -Artist "$FILE")
    [ -z "$ARTISTA" ] && ARTISTA="Artista Desconhecido"

    ALBUM=$(exiftool -s3 -Album "$FILE")
    [ -z "$ALBUM" ] && ALBUM="Album Desconhecido"

    TITULO=$(exiftool -s3 -Title "$FILE")
    [ -z "$TITULO" ] && TITULO=$(basename "$FILE" | cut -f 1 -d '.')

    # 2. Higienização para Android 8.1 (Essencial para os 2GB de RAM da central)
    ARTISTA_CLEAN=$(echo "$ARTISTA" | sed 's/[^a-zA-Z0-9 ._-]//g' | xargs)
    ALBUM_CLEAN=$(echo "$ALBUM" | sed 's/[^a-zA-Z0-9 ._-]//g' | xargs)
    TITULO_CLEAN=$(echo "$TITULO" | sed 's/[^a-zA-Z0-9 ._-]//g' | xargs)

    # 3. Caminho de Destino
    FINAL_DIR="$TARGET/$ARTISTA_CLEAN/$ALBUM_CLEAN"
    mkdir -p "$FINAL_DIR"

    # 4. Operação de MOVER
    EXTENSION="${FILE##*.}"
    SAFE_FILENAME="$TITULO_CLEAN.$EXTENSION"
    DEST_PATH="$FINAL_DIR/$SAFE_FILENAME"

    if mv "$FILE" "$DEST_PATH"; then
        echo -e "${GREEN}MOVIDO:${NC} $ARTISTA_CLEAN / $TITULO_CLEAN"
    else
        echo -e "${RED}ERRO:${NC} Falha ao mover $(basename "$FILE")"
    fi

done

echo -e "${YELLOW}--- Faxina Final: Removendo pastas vazias e arquivos inúteis ---${NC}"
# Remove arquivos ocultos que atrasam o scanner da central
find "$TARGET" -type f -name ".*" -delete

# Remove pastas vazias que ficaram na origem
find "$SOURCE" -type d -empty -delete

echo -e "${GREEN}Tudo pronto! Sua biblioteca está limpa e no lugar certo.${NC}"
