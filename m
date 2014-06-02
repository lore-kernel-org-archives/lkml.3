Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaFBOGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:06:43 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:45036 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaFBOGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:06:41 -0400
Date: Mon, 2 Jun 2014 11:06:36 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-06-01
Message-ID: <20140602140636.GA1659@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here some more patches for 3.16. We know that Linus already opened the merge
window, but this is fix only pull request, and most of the patches here are
also tagged for stable.

Please pull! or let me know of any issues. Thanks!

	Gustavo

---
The following changes since commit d7b2545023ecfde94d3ea9c03c5480ac18da96c9:

  Bluetooth: Clearly distinguish mgmt LTK type from authenticated property (2014-05-23 11:24:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 8a96f3cd22878fc0bb564a8478a6e17c0b8dca73:

  Bluetooth: Fix L2CAP deadlock (2014-06-02 13:38:19 +0300)

----------------------------------------------------------------
Adam Lee (1):
      Bluetooth: ath3k: no need to set same pipe multiple times

Johan Hedberg (4):
      Bluetooth: Fix properly ignoring LTKs of unknown types
      Bluetooth: Fix authentication check for FIPS security level
      Bluetooth: Fix requiring SMP MITM for outgoing connections
      Bluetooth: Fix missing check for FIPS security level

Jukka Rissanen (2):
      Bluetooth: 6LoWPAN: Fix MAC address universal/local bit handling
      Bluetooth: l2cap: Set more channel defaults

Jukka Taimisto (1):
      Bluetooth: Fix L2CAP deadlock

 drivers/bluetooth/ath3k.c  |  3 ++-
 net/bluetooth/6lowpan.c    | 65 +++++++++++++++++++++++++++++-------------------------
 net/bluetooth/hci_event.c  |  4 +++-
 net/bluetooth/l2cap_core.c |  6 +++++
 net/bluetooth/l2cap_sock.c |  5 ++++-
 net/bluetooth/mgmt.c       | 10 +++++++--
 net/bluetooth/smp.c        |  7 +++---
 7 files changed, 62 insertions(+), 38 deletions(-)

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjITsAAoJEPs3PUX4s20oFSEQAKpJqns+h74NOPIqHPOfv+pr
hGvKvstASH9IeuA+km+BHDFSS0Eqwkc1M8AnS8sZIrVq8sML+89bpBMyhYSIOzwM
sugpDuGXn0rMQ4Ia24gEwjgLBs94j0NcG1Q5/AjsaJcQ/8JOo7Or19lcB/yASZ1b
gHQ9H9niF6kpQnxfConkfT+UvhSxtSFro1/wFoM1+9kyiMujFXxLgFQcEo32xHdE
2NycQWRJe81fB7m1USuzBtBbMPp0DL0qTOPDR/i6K4TmEOgCgPvT/RReJxLTVm+J
jZBrh7q5UPXF7NG9A7+Vu2heKh1jcXrrkSzLQ1jRDM2Wy77JRsaQ+RITgnRHKmCm
KyAa/oRobEtx8sCv8465klw33LoVKtbuN6nDmNzFLBXYrA5A5I+v6IvqoQEtsklP
uCqxLDswRkdg3xbOiad5bxd3X5cLEQ2S158yqi+UQEO84kN33ylsaEfxVAlxnzEJ
4ehhsOZVOkTPUhSQzwyVEy4iq4d3urgQwTlH2aj7RQS4DzZ5Tfow8uth7jUAOpFW
k6Qj59UZsR2aOCiPZgIpQzaHWI7L8mT0nraOq2Bqq2dcbOucHAqFX3pyt7+c3Kqc
QSrX2zrowJ5S1J4LkaMa8HsKHH2DBusbBelLth6q6JxP9AnWczOHeP3rySMNjrxT
9XWfb9s6lAIiDKbN2cvo
=Gn+6
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
