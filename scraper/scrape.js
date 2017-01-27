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

        //  console.log('writing result ' + JSON.stringify(merged))
        fs.writeFile('episodes.json', JSON.stringify({
            episodes,
            rounds,
            guests
        }, 0, 2));
    })
    .catch(e => {
        console.error(e)
        console.error(e.stack)
    })
