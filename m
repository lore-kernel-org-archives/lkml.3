Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaGVOZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:25:16 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:57602 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaGVOZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:25:11 -0400
Date: Tue, 22 Jul 2014 11:25:06 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-07-21
Message-ID: <20140722142506.GC1628@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here follows some more patches for 3.17. These are mostly fixes to what
we've sent to you before for next merge window.

Please pull! Thanks.

	Gustavo

---
The following changes since commit 4d042654afb342386cb5c33e29843b76d598ab61:

  Bluetooth: cmtp: Remove unnecessary null test (2014-07-14 23:00:13 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to c2aef6e8cbebd60f79555baeb9266e220f135a44:

  Bluetooth: Add support for Broadcom device of Asus Z97-DELUXE motherboard (2014-07-21 15:07:08 +0300)

----------------------------------------------------------------
Amitkumar Karwar (2):
      Bluetooth: add public address configuration for Marvell USB devices
      Bluetooth: btmrvl: add public address configuration support

Chin-Ran Lo (1):
      Bluetooth: btmrvl: avoid sending data to firmware after hs_activated

Johan Hedberg (18):
      Bluetooth: Remove unnecessary params variable from process_adv_report()
      Bluetooth: Don't try to reject failed LE connections
      Bluetooth: Add proper defines for HCI connection role
      Bluetooth: Convert HCI_CONN_MASTER flag to a conn->role variable
      Bluetooth: Use explicit role instead of a bool in function parameters
      Bluetooth: Add a role parameter to hci_conn_add()
      Bluetooth: Track number of LE slave connections
      Bluetooth: Fix trying to initiate connections when acting as LE slave
      Bluetooth: Fix always checking the blacklist for incoming connections
      Bluetooth: Fix using uninitialized variable when pairing
      Bluetooth: Don't bother user space without IO capabilities
      Bluetooth: Fix resetting remote authentication requirement after pairing
      Bluetooth: Pass initiator/acceptor information to hci_conn_security()
      Bluetooth: Introduce a flag to track who really initiates authentication
      Bluetooth: Fix allowing initiating pairing when not pairable
      Bluetooth: Use EOPNOTSUPP instead of ENOTSUPP
      Bluetooth: Disable HCI_CONNECTABLE based passive scanning for now
      Bluetooth: Prefer sizeof(*ptr) when allocating memory

Marcel Holtmann (3):
      Bluetooth: Fix endian and alignment issue with ath3k version handling
      Bluetooth: Remove unneeded variable assignment in hmac_sha256
      Bluetooth: Add support for Broadcom device of Asus Z97-DELUXE motherboard

Vladimir Davydov (1):
      Bluetooth: never linger on process exit

 drivers/bluetooth/ath3k.c        |  29 +++++++++-------
 drivers/bluetooth/btmrvl_drv.h   |   1 +
 drivers/bluetooth/btmrvl_main.c  |  24 +++++++++++++
 drivers/bluetooth/btmrvl_sdio.c  |  16 ++++-----
 drivers/bluetooth/btusb.c        |  34 ++++++++++++++++++
 include/net/bluetooth/hci.h      |   6 ++--
 include/net/bluetooth/hci_core.h |  20 +++++++----
 include/net/bluetooth/l2cap.h    |   2 +-
 net/bluetooth/amp.c              |   6 ++--
 net/bluetooth/hci_conn.c         |  41 ++++++++++++----------
 net/bluetooth/hci_core.c         |  28 ++++++++-------
 net/bluetooth/hci_event.c        | 110 ++++++++++++++++++++++++++++++----------------------------
 net/bluetooth/l2cap_core.c       |  32 +++++++++--------
 net/bluetooth/l2cap_sock.c       |   7 ++--
 net/bluetooth/mgmt.c             |   6 ++--
 net/bluetooth/rfcomm/core.c      |   3 +-
 net/bluetooth/rfcomm/sock.c      |   3 +-
 net/bluetooth/sco.c              |   6 ++--
 net/bluetooth/smp.c              |  24 +++++++------
 19 files changed, 245 insertions(+), 153 deletions(-)

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTznRBAAoJEPs3PUX4s20oXM0P/2K9n6WBDORSjiNNR7IxIhNQ
Y7EXGl8/eWL7QQTxxYU+nvO2i5WwYkv6IV4DcKhjcSuc7Zul9ehGLaD64T+GcOmw
6Sp+sIMigeQE6yYbo4hTwyI1UEe10fEfSupUqTEpvM2cRKgR4zwTN6APW2hKPuGv
jdaC63ysRCKl2HwrAnW4LU05L8BRm8aaxuUXv4Gmien2dtFtsH66SmzdATHJ+oEd
bg2i1qZb/Y2IqrzH+PmK7ykJIKasW6Ccnuscrqn6CnbRpSWitZvF+2cr0cHH3p+9
thsW3ep7rtqsJ4UlgyW6LRdhybL9NyELqLZjYnjRzAWBXcyBFL35FkTnjKFIKklJ
GKJFtYtDZbwnDRT1DeALu0qCIPAWkDUg90lTNCvuRU2t6TUb/YZeF115Pi0v9/H9
QoJToSf38fHYGd9WF07FDPFe0bAzqO7uaVmR5NmdWKMzHvCHTdLLdOpjShtW/iPW
L0ZcQYErtLSeCGI2zzrNCZfpz2dWm7GlZBMz3r1BbmvFT+Se9VGfmNIrrJNZZJez
+o7EpQsigltkWTtSq13T4YWObRd5dzrxzghBX3ysfu3vYTeZUE4onvEa1Nt+Io+S
DpIYd91XJFBurnzIFh4ALSaUmmNikTjqyBY3C/7o0UfRK9TtZLL8FXSaOTOAl/M2
5B1fJ21UeZpi+oNKny0N
=pBYa
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
