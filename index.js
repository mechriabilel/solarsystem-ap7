const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 3000;

const admin = require('firebase-admin');
const serviceAccount = require('C:/Users/ACER/Downloads/systeme-solaire-c8b3d-firebase-adminsdk-x4ukn-0e4f6ad723.json'); // Remplacez par le chemin vers votre fichier JSON

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://your-database-name.firebaseio.com' // Remplacez par l'URL de votre base de données Firebase
});


app.use(cors());
app.use(bodyParser.json());

const planets = [
  {
    name: 'عطارد',
    description: 'عطارد هو أقرب كوكب إلى الشمس.',
    distanceFromSun: '57.9 مليون كم'
  },
  {
    name: 'الزهرة',
    description: 'الزهرة هو ثاني كوكب من الشمس وله غلاف جوي كثيف وساخن.',
    distanceFromSun: '108.2 مليون كم'
  },
  {
    name: 'الأرض',
    description: 'الأرض هو ثالث كوكب من الشمس وهو الكوكب الوحيد المعروف بوجود الحياة.',
    distanceFromSun: '149.6 مليون كم'
  },
  {
    name: 'المريخ',
    description: 'المريخ هو رابع كوكب من الشمس ويُعرف بالكوكب الأحمر.',
    distanceFromSun: '227.9 مليون كم'
  },
  {
    name: 'المشتري',
    description: 'المشتري هو أكبر كوكب في النظام الشمسي وخامس كوكب من الشمس.',
    distanceFromSun: '778.3 مليون كم'
  },
  {
    name: 'زحل',
    description: 'زحل هو سادس كوكب من الشمس ويشتهر بحلقاته الكبيرة.',
    distanceFromSun: '1.43 مليار كم'
  },
  {
    name: 'أورانوس',
    description: 'أورانوس هو سابع كوكب من الشمس وله محور دوران مائل بشكل كبير.',
    distanceFromSun: '2.87 مليار كم'
  },
  {
    name: 'نبتون',
    description: 'نبتون هو ثامن كوكب من الشمس وهو كوكب غازي أزرق اللون.',
    distanceFromSun: '4.5 مليار كم'
  },
  {
    name: 'بلوتو',
    description: 'بلوتو كان يعتبر كوكبًا ولكنه الآن مصنف ككوكب قزم.',
    distanceFromSun: '5.9 مليار كم'
  }
];

// Route pour obtenir les données des planètes
app.get('/api/planets', (req, res) => {
  res.json(planets);
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
