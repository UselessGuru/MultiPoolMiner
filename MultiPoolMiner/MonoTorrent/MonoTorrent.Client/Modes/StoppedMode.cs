namespace MonoTorrent.Client
{
    using System.Threading;
    using MonoTorrent.Common;

    class StoppedMode : Mode
    {
        private WaitHandle _announceWaitHandle;

        public override bool CanHashCheck
        {
            get { return true; }
        }

        public override TorrentState State
        {
            get { return TorrentState.Stopped; }
        }

        public StoppedMode(TorrentManager manager)
            : base(manager)
        {
            CanAcceptConnections = false;

            if (manager.TrackerManager.CurrentTracker != null && manager.TrackerManager.CurrentTracker.Status == TrackerState.Ok)
            {
                _announceWaitHandle = manager.TrackerManager.Announce(TorrentEvent.Stopped);
            }
            else
            {
                manager.OnStopAnnounced();
            }
        }

        public override void HandlePeerConnected(PeerId id, Direction direction)
        {
            id.CloseConnection();
        }

        public void Dispose()
        {

        }

        public override void Tick(int counter)
        {
            if (_announceWaitHandle != null && _announceWaitHandle.WaitOne(0, true))
            {
                _announceWaitHandle.Close();
                _announceWaitHandle = null;

                Manager.OnStopAnnounced();
            }
        }
    }
}
