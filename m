Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaJBPPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:15:11 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:46266 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaJBPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:15:08 -0400
Date: Thu, 2 Oct 2014 18:14:57 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-10-02
Message-ID: <20141002151457.GA3129@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Unless 3.17 gets delayed this will probably be our last -next pull request for
3.18. We've got:

  - New Marvell hardware supportr
  - Multicast support for 6lowpan
  - Several of 6lowpan fixes & cleanups
  - Fix for a (false-positive) lockdep warning in L2CAP
  - Minor btusb cleanup

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 565766b087a6d6ff257f5b79c8ceda0188c9169f:

  Bluetooth: Rename sco_param_wideband table to esco_param_msbc (2014-09-25 10:35:08 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 9c238ca8ec79c38ab22762b44aeaf7a42fc97b18:

  Bluetooth: 6lowpan: Check transmit errors for multicast packets (2014-10-02 13:41:57 +0300)

----------------------------------------------------------------
Amitkumar Karwar (2):
      Bluetooth: btmrvl: rename definitions from 88xx to 8897
      Bluetooth: btusb: remove redundant lock variable

Johan Hedberg (1):
      Bluetooth: Fix lockdep warning with l2cap_chan_connect

Jukka Rissanen (7):
      Bluetooth: 6lowpan: Make sure skb exists before accessing it
      Bluetooth: 6lowpan: Ensure header compression does not corrupt IPv6 header
      Bluetooth: 6lowpan: Enable multicast support
      Bluetooth: 6lowpan: Memory leak as the skb is not freed
      Bluetooth: 6lowpan: Avoid memory leak if memory allocation fails
      Bluetooth: 6lowpan: Return EAGAIN error also for multicast packets
      Bluetooth: 6lowpan: Check transmit errors for multicast packets

Xinming Hu (1):
      Bluetooth: btmrvl: support Marvell Bluetooth device SD8887

 drivers/bluetooth/Kconfig       |   4 +-
 drivers/bluetooth/btmrvl_sdio.c |  36 +++++++++-
 drivers/bluetooth/btusb.c       |   4 --
 net/bluetooth/6lowpan.c         | 145 +++++++++++++++++++++++++-------------
 net/bluetooth/l2cap_core.c      |  13 ++--
 5 files changed, 139 insertions(+), 63 deletions(-)

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULWvxAAoJECQj9vv5qNQS8MMP/1DDii0RGOFI00IwsCwsPDZr
lj66I6sIDZwYQ4ivNKqbekwGiJswngr7VOWEHRzibvS+CahTPg2W+eBKzeva6jlM
LQcZKblyWcOLYPGqAcsTEcGf7bp2MjEK04XhjI5+khciCLz16WAmVpDKKY/05Oas
vDFDpfvQ4uw74FLgSMRA/Ap6Ctw/DtdnSQMWOUfaKK9yj4/PM0gWVJ1lz964oFVK
HDpcnUJIY/pKBg22z14FgRhGfKupV65Q0J/a/P+3P8JyVyXW51bRCFPipHpHvdhX
B7/Pgzl9hd7maAdaeHc2RKEKGrTVUCHrx7SiaemEe3QffXIra5kFp2Lx6oyTLnq2
JOUkfNZ+NhiTrZJ5hlLFLCgjif8aJXfRvbzzRsGkN9vY+pldk9gFsV97U/mNd+6U
r1Gb4hv5vMBvEI375XRPcqmW4rR9l0rRDzhckB6JR772sBD8xhR+/02bL0JXvRel
UFdH/uQeDM/XJ++mnvtNfW2i4EwaGyHdNYzM8omS2sEJMb7q9YfL/3vcheypis6K
4eU7gv86Grph3cIT4KUlylbwVz6OfIylDgOIe6js3b8eqUgQnlXW1UkajnrrLiu7
7/cFwFqMBrm+OAmC9vIqMq96ZdoK0rfkox0d2BlgIxotlz/GtkHlqu9+cGut/ODk
u+o40FFul4Nm2NSklWwK
=dG1u
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
