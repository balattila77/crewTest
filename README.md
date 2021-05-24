<p align="center"><img src="https://images.crewcall.hu/x50/o/storage/settings/April2020/Itiu5vWMSZG1xeHJ22EO.png" ><br /> **crewcall tesztfeladat** </p>


## Fejlesztő környezet

- Win 10 Pro 20H2 
- Ubuntu -20.04 WSL
- Visual Studio Code
- Windows terminal
- Docker desktop
- Laravel Framework 8.40.0
- Postman a teszteléshez

## Telepítés

- git clone https://github.com/balattila77/crewTest.git
- cd crewTest
- docker-compose up
- docker-compose exec backend sh majd php artisan migrate

## API tesztelése

Az api érvényes user login után érhető el - a regisztráció az /api/register URL-re küldött
POST adatokkal lehetséges (email, name, password, password_confirm):
<br /><img src="https://github.com/balattila77/crewTest-documentation/blob/main/registration.jpg" alt="user reg" ><br />
Regisztráció után  POST (email, password) az api/login címre:
<br /><img src="https://github.com/balattila77/crewTest-documentation/blob/main/login.jpg" alt="user login" ><br /><br />
A termékek rögzítéséhez szükséges az X-Requested-With | XMLHttpRequest header küldése is
<br /><br />
Egy termék rögzítése<br />
POST api/stock:
<br /><img src="https://github.com/balattila77/crewTest-documentation/blob/main/oneitem.jpg" alt="post one item" ><br /><br />
Csoportos feltöltés egy jsonFile POST értéket vár (api/storebulk), ez a teszthez a 
https://raw.githubusercontent.com/stockholmux/ecommerce-sample-set/master/items.json
<br /><img src="https://github.com/balattila77/crewTest-documentation/blob/main/storebulk.jpg" alt="post bulk item" ><br /><br />
Statisztika: <br />
GET http://localhost:8000/api/stock<br /><br />
Eseménynapló:<br />
GET http://localhost:8000/api/event<br />
... vagy adott event típusra szűrve:<br />
GET http://localhost:8000/api/event?queued<br />
Adott esemény ID-ra kérés:<br />
GET http://localhost:8000/api/event/1<br />






