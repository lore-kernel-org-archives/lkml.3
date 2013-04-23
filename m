Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3DWX6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:58:35 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:33458 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3DWX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:58:33 -0400
Date: Tue, 23 Apr 2013 20:58:25 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-04-23
Message-ID: <20130423235825.GG1697@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A few more patches intended for 3.10, the most important one is the support=
 in
btusb for fw loading for the Intel Bluetooth device. Other than that we have
only fixes and clean ups.

Please pull or let me know of any problems! Thanks.

	Gustavo
---
The following changes since commit 76a388beaf92cc75b829d4a0b7d69afaaeaa4b0a:

  Bluetooth: Rename LE_SCANNING_* macros (2013-04-18 01:17:27 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream=20

for you to fetch changes up to 69676b1c2af451bfe5cd36ff4973a484b5d5a86c:

  Bluetooth: btmrvl: report error if verify_fw_download times out (2013-04-=
23 20:55:55 -0300)

----------------------------------------------------------------
Andreas Fenkart (2):
      Bluetooth: btmrvl: release lock while waiting for fw download complete
      Bluetooth: btmrvl: report error if verify_fw_download times out

Andy Shevchenko (1):
      Bluetooth: btmrvl: use native helpers for debugfs

Fengguang Wu (1):
      Bluetooth: hci_get_cmd_complete() can be static

Gustavo Padovan (1):
      Bluetooth: remove unneeded var initialization in btmrvl

Johan Hedberg (2):
      Bluetooth: Fix HCI command send functions to use const specifier
      Bluetooth: Fix sending write_le_host_supporte for LE-only controllers

Marcel Holtmann (1):
      Bluetooth: Remove unneeded parameter from L2CAP ATT channel handling

Tedd Ho-Jeong An (1):
      Bluetooth: Add support for Intel Bluetooth device [8087:07dc]

 drivers/bluetooth/btmrvl_debugfs.c | 266 +++------------------------
 drivers/bluetooth/btmrvl_sdio.c    |  41 +++--
 drivers/bluetooth/btusb.c          | 377 +++++++++++++++++++++++++++++++++=
++++++
 include/net/bluetooth/hci_core.h   |  14 +-
 net/bluetooth/hci_core.c           |  29 ++-
 net/bluetooth/l2cap_core.c         |   7 +-
 net/bluetooth/mgmt.c               |   8 +-
 7 files changed, 462 insertions(+), 280 deletions(-)


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRdyAhAAoJEPs3PUX4s20ob18P/2gfa73Qcfts+Wq47sfRe4Ui
CaKMe6iQLsQCgRfGkKE5ut5VCcxHlJFrVZ1sw8c6ucKZqM8xMjaXhyHngZ+lt+RT
RLy7RCyWSP2yAZEFPdehaEuPPO7UVjjc7Ae/uHkdj7mW61h6j/vRmXHA+w4t/C1d
RJQi8Ta+18Rwk87/xebMmRGUO08/k1OBXPELbbGZOjnjujnRklOSoDx360RaqM+m
6XHx/lsHNJKKTe2/EbiubsbxzH6RfIFQ2ohCGv5FiidXxyfb01KfsHdWroP+S0ia
BGHRsjnT15HtwT10JA0E0WLCKJbC5euv4+6JGnafAKN4nTbiCpSIe1EodniHrPGt
q3PKY8QxJOKa4+QnHzpa5wQcc+Qp9zdSE6ZSoLLkMeZQdp4I7P9RoXHooXR+2Wjk
KAknZL7ezGeZnbDQrgyIXwKO9T3JShZTOQuPj3Am0ZPvucvYTCK+x266AKLP2c7K
gRykaXeVth5tPrNA/uxX7xDgCqFjBlIhiJdn4UN2H6jZYiZ8CIc34xUySXsOxX6E
MtsvLMcKL/gw2Wn1qjIkdRsfBy51BiRGSuIvL8RZY2zmoQDvv0gsyIS4BB/rtwuN
lRpfpy61CosKiTa9HislzZAeq2Tw7zAuh7R21Mc9bzNaUTyuSFyBVYJCPK2Liv3a
l/btT+0fHBfNz1He/S8s
=JPJI
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
