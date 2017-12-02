var Xray = require('x-ray');
var x = Xray();

const fs = require('fs');
const R = require('ramda');

const merge = require('./merge');

const scrapePromise = new Promise((resolve, reject) => {
    x('https://en.wikipedia.org/wiki/List_of_Would_I_Lie_to_You%3F_episodes', 'table tr', [{
        title: 'td:first-child',
        broadcast: 'td:nth-child(2)',
        davidsTeam: 'td:nth-child(3)@html',
        davidsGuestLinks: ['td:nth-child(3) a@href'],
        davidsGuestNames: ['td:nth-child(3) a'],
        leesGuestLinks: ['td:nth-child(4) a@href'],
        leesGuestNames: ['td:nth-child(4) a']
  }])((err, content) => {
        if (err) {
            console.log('scrape failed: ' + err);
            reject(err);
        } else {
            resolve(content);
        }
    })
});

const readPromise = new Promise((resolve, reject) => {
    fs.readFile('episodes.json', (err, data) => {
        if (err) {
            console.warn('Could not load episodes.json: ' + err);
            resolve({ episodes: [] });
        } else {
            try {
                resolve(JSON.parse(data));
            } catch (e) {
                console.warn('Could not parse episodes.json: ' + e);
                resolve({ episodes: [] });
            }
        }
    })
});

const hasValue = v => {
    return !R.isNil(v);
};


const sortByName = (a, b) => {
  var nameA = a.name.toUpperCase(); // ignore upper and lowercase
  var nameB = b.name.toUpperCase(); // ignore upper and lowercase
  if (nameA < nameB) {
    return -1;
  }
  if (nameA > nameB) {
    return 1;
  }

  // names must be equal
  return 0;
}

const addGenderToGuests = ({ episodes, rounds, guests }) => {
  const wikiLookups = guests
    .map(guest => {
      return Boolean(guest.gender)
        ? Promise.resolve(guest)
        : new Promise((resolve, reject) => {
          x(guest.url, 'div#bodyContent')((err, content) => {

            if (err) {
              resolve(err)
            }

            const heMatch = content.match(/[ \.]he /gi)
            const sheMatch = content.match(/[ \.]she /gi)
            heCount = heMatch && heMatch.length ? heMatch.length : 0
            sheCount = sheMatch && sheMatch.length ? sheMatch.length : 0

            const gender =
              (heCount > sheCount)
                ? 'male'
                : (heCount < sheCount)
                  ? 'female'
                  : ''

            resolve({ ...guest, gender })
          })
        })
      })

    return Promise.all(wikiLookups)
      .then(lookups => {
        return {
          episodes,
          rounds,
          guests: lookups.sort(sortByName)
        }
      })
}

const cleanScrapedEpisodes = (rawEpisodes) => {
    return rawEpisodes.filter(s => {
            return !!s.title;
        }).filter(s => {
            if (s.davidsGuestNames.length === 2 && s.leesGuestNames.length === 2) {
                return true;
            } else {
                console.log(`skipping episode ${s.title} because of guest data`);
            }
        }).map(s => {
            const titleMatch = s.title.match(/^(\d\d)x(\d\d)$/);
            if (titleMatch && titleMatch.length > 2) {
                return {
                    season: titleMatch[1],
                    episode: titleMatch[2],
                    title: s.title,
                    id: s.title,
                    davidsGuest1: {
                        name: s.davidsGuestNames[0],
                        url: s.davidsGuestLinks[0]
                    },
                    davidsGuest2: {
                        name: s.davidsGuestNames[1],
                        url: s.davidsGuestLinks[1]
                    },
                    leesGuest1: {
                        name: s.leesGuestNames[0],
                        url: s.leesGuestLinks[0]
                    },
                    leesGuest2: {
                        name: s.leesGuestNames[1],
                        url: s.leesGuestLinks[1]
                    }
                }
            }
        })
        .filter(hasValue);
};

Promise.all([scrapePromise, readPromise]).then(results => {
        const scraped = results[0];
        const existing = results[1];

        const scrapedEpisodes = cleanScrapedEpisodes(scraped);

        console.log('merging results');
        const guests = merge.mergeGuests(scrapedEpisodes, existing.guests || [])
        const episodes = merge.mergeEpisodes(scrapedEpisodes, existing.episodes, guests);
        const rounds = existing.rounds || [];

        return {
          episodes,
          rounds,
          guests
        }
      })
      .then(addGenderToGuests)
      .then(results => {
        //  console.log('writing result ' + JSON.stringify(merged))
        fs.writeFile('episodes.json', JSON.stringify(results, 0, 2));
    })
    .catch(e => {
        console.error(e)
        console.error(e.stack)
    })
