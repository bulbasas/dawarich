# 🕐 Timeline Funkcijos Įdiegimas

## ⚡ Greitas Startas (3 Žingsniai)

### 1️⃣ Sukurkite Docker Image

```bash
# Iš dawarich root direktorijos
docker build -f docker/Dockerfile -t dawarich-timeline:latest .
```

**Trukmė**: ~5-10 minučių (priklausomai nuo interneto greičio)

### 2️⃣ Paleiskite Naują Versiją

```bash
# Arba naudokite automatinį script'ą:
./docker/deploy-timeline.sh

# ARBA rankiniu būdu:
cd docker
docker-compose down
docker-compose -f docker-compose.local.yml up -d
```

### 3️⃣ Atidarykite Naršyklėje

```
http://localhost:3000
```

Spustelėkite **"Timeline"** mygtuką viršuje kairėje!

---

## 🎯 Kas Pasikeitė?

### Nauji Failai:
- `docker/docker-compose.local.yml` - Docker konfigūracija su jūsų image
- `docker/deploy-timeline.sh` - Automatinis deployment script'as
- `TIMELINE_DEPLOYMENT.md` - Išsami dokumentacija angliškai

### Pagrindiniai Skirtumai:
```yaml
# Vietoj:
image: freikin/dawarich:latest

# Dabar:
image: dawarich-timeline:latest
```

---

## 📋 Pilnas Deployment Procesas

### Pirmas Kartas (Pilnas Setup)

```bash
# 1. Įsitikinkite, kad esate teisingame branch
git branch
# Turėtų rodyti: claude/add-timeline-slider-map-qGox6

# 2. Sukurkite Docker image
docker build -f docker/Dockerfile -t dawarich-timeline:latest .

# 3. Sustabdykite senus konteinerius
cd docker
docker-compose down

# 4. Paleiskite su nauja konfigūracija
docker-compose -f docker-compose.local.yml up -d

# 5. Patikrinkite statusą
docker-compose -f docker-compose.local.yml ps
```

### Atnaujinimai (Kai Padarote Pakeitimų)

```bash
# Pakeiskite kodą, tada:
git add .
git commit -m "Mano pakeitimai"

# Perkurkite image ir restart'inkite
docker build -f docker/Dockerfile -t dawarich-timeline:latest .
cd docker
docker-compose -f docker-compose.local.yml restart dawarich_app
```

---

## 🔍 Naudingos Komandos

### Žiūrėti Logus
```bash
cd docker
docker-compose -f docker-compose.local.yml logs -f dawarich_app
```

### Restart Aplikacijos
```bash
cd docker
docker-compose -f docker-compose.local.yml restart dawarich_app
```

### Sustabdyti Viską
```bash
cd docker
docker-compose -f docker-compose.local.yml down
```

### Grįžti į Oficialų Image
```bash
cd docker
docker-compose down
docker-compose -f docker-compose.yml up -d  # originalus failas
```

### Ištrinti Savo Image (Jei Reikia Vietos)
```bash
docker rmi dawarich-timeline:latest
```

---

## 🎮 Kaip Naudotis Timeline

1. **Atidarykite Map puslapį** - `/map`
2. **Spauskite "Timeline"** mygtuką viršuje kairėje
3. **Pasirinkite grafiko tipą**:
   - **Speed** - greitis km/h (žalia)
   - **Battery** - baterija % (oranžinė)
   - **Elevation** - aukštis m (mėlyna)
4. **Stumiati slider** arba spauskite **▶️ Play**
5. **Stebėkite** kaip taškai atsiranda ant žemėlapio!

---

## 🐛 Jei Kažkas Neveikia

### Konteineris Nepasileidžia
```bash
# Žiūrėkite klaidų pranešimus:
docker-compose -f docker-compose.local.yml logs -f dawarich_app

# Bandykite perkurti image:
docker build -f docker/Dockerfile -t dawarich-timeline:latest . --no-cache
```

### Timeline Mygtukas Nematomas
```bash
# Perkurkite assets:
docker exec -it dawarich_app bundle exec rake assets:precompile
docker-compose -f docker-compose.local.yml restart dawarich_app
```

### Timeline Grafikas Neveikia
1. Atverkite Developer Tools (F12)
2. Console tab - ieškokite klaidų
3. Patikrinkite ar yra points duomenų

### Portas Užimtas
Pakeiskite `docker/.env`:
```bash
DAWARICH_APP_PORT=3001  # vietoj 3000
```

---

## 📦 Sistemos Reikalavimai

**Tas pats kaip official Dawarich:**
- CPU: 0.5+ cores
- RAM: 4GB+
- Disk: Priklausomai nuo duomenų kiekio

**Build Procesas:**
- RAM: ~2GB build metu
- Disk: ~1-2GB image'ui
- Laikas: 5-10 min

---

## 🔄 Workflow Pavyzdys

### Kasdieninis Naudojimas
```bash
# Startas
cd /home/user/dawarich/docker
docker-compose -f docker-compose.local.yml up -d

# Stabdymas
docker-compose -f docker-compose.local.yml down
```

### Development (su pakeitimais)
```bash
# 1. Pakeisti failą, pvz.:
#    app/javascript/controllers/maps/timeline_controller.js

# 2. Rebuild image
docker build -f docker/Dockerfile -t dawarich-timeline:latest .

# 3. Restart
cd docker
docker-compose -f docker-compose.local.yml restart dawarich_app

# 4. Refresh naršyklėje (Ctrl+Shift+R)
```

---

## 💡 Pro Tips

1. **Greitas Rebuild**: Jei keitėte tik JavaScript:
   ```bash
   docker exec -it dawarich_app bundle exec rake assets:precompile
   docker-compose -f docker-compose.local.yml restart dawarich_app
   ```

2. **Persistence**: Jūsų duomenys (DB, uploads) lieka Docker volumes:
   ```bash
   docker volume ls | grep dawarich
   ```

3. **Resource Limits**: Pakeiskite `.env` jei reikia daugiau RAM:
   ```bash
   APP_MEMORY_LIMIT=8G  # vietoj 4G
   ```

4. **Backup**: Prieš didelius pakeitimus:
   ```bash
   docker-compose -f docker-compose.local.yml exec dawarich_db pg_dump -U postgres dawarich_development > backup.sql
   ```

---

## 🎉 Pasiekimai

Po sėkmingo deployment turėsite:

✅ Interaktyvų timeline slider žemėlapyje
✅ Grafikus: greitis, baterija, aukštis
✅ Play/Pause animaciją
✅ Real-time filtravimą taškų
✅ Smooth UX su DaisyUI styling

---

## 📞 Support

Jei kyla problemų:
1. Patikrinkite logus (`docker-compose logs`)
2. Peržiūrėkite `TIMELINE_DEPLOYMENT.md` (anglų k.)
3. GitHub Issues: jūsų fork'e

---

**Svarbu**: Tai laikina versija su timeline feature. Kai feature bus merge'intas į official repo, galėsite grįžti prie `freikin/dawarich:latest` image.

**Mėgaukitės Timeline funkcija! 🚀**
