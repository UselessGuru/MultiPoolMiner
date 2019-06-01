namespace MonoTorrent.Client.Tracker
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using MonoTorrent.Client.Tracker;
    using MonoTorrent.Common;

    interface ITracker
    {
        event EventHandler BeforeAnnounce;
        event EventHandler<AnnounceResponseEventArgs> AnnounceComplete;
        event EventHandler BeforeScrape;
        event EventHandler<ScrapeResponseEventArgs> ScrapeComplete;

        bool CanAnnounce { get; }
        bool CanScrape { get; }
        long Complete { get; }
        long Downloaded { get; }
        string FailureMessage { get; }
        long Incomplete { get; }
        TimeSpan MinUpdateInterval { get; }
        TrackerState Status { get; }
        TimeSpan UpdateInterval { get; }
        Uri Uri { get; }
        string WarningMessage { get; }

        void Announce(AnnounceParameters parameters, object state);
        void Scrape(ScrapeParameters parameters, object state);
    }
}
