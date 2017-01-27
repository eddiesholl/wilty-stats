const R = require('ramda');

const cleanArray = R.reject(R.isNil);

const strToId = (rawStr) => {
    return rawStr.replace(/[^\w]/g, '').toLowerCase();
};

const formatGuest = (raw) => {
    return {
        id: strToId(raw.name),
        name: raw.name,
        url: raw.url
    };
};

const uniqGuest = R.uniqBy(g => g.id);
const pullGuestsFromEp = R.map(e => {
    return [
    formatGuest(e.davidsGuest1),
    formatGuest(e.davidsGuest2),
    formatGuest(e.leesGuest1),
    formatGuest(e.leesGuest2)
  ];
});

const mergeGuests = (scraped, existingGuests) => {
    const existingLookup = R.reduce((acc, g) => {
        acc[g.id] = g;
        return acc;
    }, {}, cleanArray(existingGuests));

    const guestMatch = g => {
        const e = existingLookup[g.id];

        if (e) {
            return R.merge(e, g);
        } else {
            return g;
        }
    }

    const scrapedGuests = R.pipe(
        pullGuestsFromEp,
        R.flatten,
        uniqGuest,
        guestMatch
    )(scraped);

    return scrapedGuests;
};


const mergeEpisodes = (scraped, existingEpisodes, guests) => {
    const existingLookup = R.reduce((acc, ep) => {
        acc[ep.title] = ep;
        return acc;
    }, {}, cleanArray(existingEpisodes));

    const merged = scraped
        .map(s => {
            const e = existingLookup[s.title];

            if (e) {
                console.log('found existing record for ' + s.title);
                return R.merge(e, s);
            } else {
                console.log('found new episode ' + s.title);
                return s;
            }
        }).map(R.dissoc('rounds'));

    return cleanArray(merged);
}

module.exports = {
    mergeEpisodes,
    mergeGuests,
    pullGuestsFromEp
}
