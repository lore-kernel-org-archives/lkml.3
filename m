Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3LJPik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:38:40 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:61191 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3LJPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:38:38 -0500
Date: Tue, 10 Dec 2013 13:38:30 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-12-10
Message-ID: <20131210153830.GA1542@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

More patches to 3.14. Here we have the support for Low Energy Connection
Oriented Channels (LE CoC). Basically, as the name says, this adds supports
for connection oriented channels in the same way we already have them for
BR/EDR connections so profiles/protocols that work on top of BR/EDR can now
work on LE plus a plenty of new possibilities for LE.

Please pull. Thanks!!

	Gustavo

---
The following changes since commit 201a5929c8c788f9ef53b010065c9ce70c9c06f0:

  Bluetooth: Remove dead code from SMP encryption function (2013-12-04 11:09:05 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 71fb419724fadab4efdf98210aa3fe053bd81d29:

  Bluetooth: Fix handling of L2CAP Command Reject over LE (2013-12-10 01:15:44 -0800)

----------------------------------------------------------------
Johan Hedberg (35):
      Bluetooth: Remove unnecessary braces from one-line if-statement
      Bluetooth: Add module parameter to enable LE CoC support
      Bluetooth: Update l2cap_global_chan_by_psm() to take a link type
      Bluetooth: Allow l2cap_chan_check_security() to be used for LE links.
      Bluetooth: Pass command length to LE signaling channel handlers
      Bluetooth: Move LE L2CAP initiator procedure to its own function
      Bluetooth: Add definitions for LE connection oriented channels
      Bluetooth: Add initial code for LE L2CAP Connect Request
      Bluetooth: Add smp_sufficient_security helper function
      Bluetooth: Refactor L2CAP connect rejection to its own function
      Bluetooth: Add basic LE L2CAP connect request receiving support
      Bluetooth: Fix L2CAP channel closing for LE connections
      Bluetooth: Add L2CAP Disconnect suppport for LE
      Bluetooth: Make l2cap_le_sig_cmd logic consistent
      Bluetooth: Add LE L2CAP flow control mode
      Bluetooth: Track LE L2CAP credits in l2cap_chan
      Bluetooth: Limit L2CAP_OPTIONS socket option usage with LE
      Bluetooth: Add new BT_SNDMTU and BT_RCVMTU socket options
      Bluetooth: Implement returning of LE L2CAP credits
      Bluetooth: Add LE flow control discipline
      Bluetooth: Reject LE CoC commands when the feature is not enabled
      Bluetooth: Introduce L2CAP channel callback for suspending
      Bluetooth: Add LE L2CAP segmentation support for outgoing data
      Bluetooth: Implement LE L2CAP reassembly
      Bluetooth: Fix LE L2CAP Connect Request handling together with SMP
      Bluetooth: Fix suspending the L2CAP socket if we start with 0 credits
      Bluetooth: Limit LE MPS to the MTU value
      Bluetooth: Fix clearing of chan->omtu for LE CoC channels
      Bluetooth: Fix CID ranges for LE CoC CID allocations
      Bluetooth: Fix validating LE PSM values
      Bluetooth: Add debugfs controls for LE CoC MPS and Credits
      Bluetooth: Simplify l2cap_chan initialization for LE CoC
      Bluetooth: Use min_t for calculating chan->mps
      Bluetooth: Fix valid LE PSM check
      Bluetooth: Fix handling of L2CAP Command Reject over LE

Marcel Holtmann (2):
      Bluetooth: Increase minor version of core module
      Bluetooth: Use macros for connectionless slave broadcast features

 include/net/bluetooth/bluetooth.h |   3 +
 include/net/bluetooth/hci.h       |   6 +
 include/net/bluetooth/hci_core.h  |   6 +
 include/net/bluetooth/l2cap.h     |  45 +++
 net/bluetooth/af_bluetooth.c      |   2 +-
 net/bluetooth/hci_core.c          |   6 +-
 net/bluetooth/l2cap_core.c        | 744 ++++++++++++++++++++++++++++++++++++++++++++---
 net/bluetooth/l2cap_sock.c        | 181 ++++++++++--
 net/bluetooth/smp.c               |  16 +-
 net/bluetooth/smp.h               |   1 +
 10 files changed, 937 insertions(+), 73 deletions(-)

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpzV2AAoJEPs3PUX4s20oxPEP+gKUiBXuXH8cyiF3fHgdpfja
Q4DEGbSX3bvIRtZdY3lCGN0EZkG9nWa8xWoKDKkR+7pbkK1JRwbPfrjwNdr03GHK
uCOPzPIFmZIFLHslcq5OJIrmyVMMaDi5900PJVf3SIj3TluJkHyThLZf4op7G3Qv
a/mQeNgNsMBmR/EYkBMzyfYrje78ZFDhobXBE7ZL3Cs6Vrp2XGkEBq/3pnez0ic0
KQJIPwVg7Hghhuh17pvo47MOmJnOoO7qXLOF3LhUW33a6NscwkKH/YFR2nxU2pLa
z14skOOGSo7MjWQnu6KSJ9g37iQyxSfTvRAUVequCBxnrt0KZhzSAY1tJQkEWvTZ
LU9aw3vN+cTYY+w/AsIFRGdzDm8jEwg2/XL4jXT2rloShTDlnqxj0nwaeyzh4Mih
vLGTpDIvPal4GkgkbRUKgnkGQ15WQ6x8w80tiisI07gz31NvUypH4U5CS0vhOYcH
cYwmiB7pdASnEa3756x+Orj5XCYva4sVKMfChm/2ypcTOIGiJHXEDSLbbzBtNQ6J
rIr03l9g6IFtCUDnQa68DURYMkX6Gi4R9rkzqT47Io5zIv10YEP6OM0IrKrC62YS
780bU8axG++NxxmnqRUGgILar1Xiqyjw7QToQjzzkNKF3osXleiNuL2QV1hL2p+7
VNOzGHJPA1Z5+BX2KzTj
=BClH
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
