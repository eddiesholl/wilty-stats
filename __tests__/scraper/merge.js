const sut = require('../../scraper/merge');

var rawEpisode;

beforeEach(() => {
    rawEpisode = {
        davidsGuest1: {
            name: 'dg1',
            url: 'http://dg1'
        },
        davidsGuest2: {
            name: 'dg2',
            url: 'http://dg2'
        },
        leesGuest1: {
            name: 'lg1',
            url: 'http://1g1'
        },
        leesGuest2: {
            name: 'lg2',
            url: 'http://1g2'
        }
    };
});

describe('mergeGuests', () => {
    it('handles empties', () => {
        expect(sut.mergeGuests([], [])).toHaveLength(0);
    });
});

describe('pullGuestsFromEp', () => {
    it('works', () => {
        const result = sut.pullGuestsFromEp([rawEpisode]);
        expect(result).toHaveLength(1);
        expect(result[0]).toHaveLength(4);
    });
});
