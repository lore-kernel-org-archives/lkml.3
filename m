Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3IWVBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:01:14 -0400
Received: from mail-ye0-f171.google.com ([209.85.213.171]:41838 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3IWVBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:01:12 -0400
Date: Mon, 23 Sep 2013 18:00:49 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-09-23
Message-ID: <20130923210049.GG18215@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

First Bluetooth fixes to 3.12, it includes:

* 3 patches to add device id for 3 new hardwares.

* 2 patches from Johan to fix the rfkill behaviour during setup stage

* a small clean up in the rfcomm TTY code that fixes a potential racy
condition (by Gianluca Anzolin)

* 2 fixes to proper set encryption key size and security level in the
peripheral role of Bluetooth LE devices. (by Andre Guedes)

* a fix for dealing devices where pairing is not necessary, we were keeping
the Bluetooth ACL connection alive for too much time. (by Syam Sidhardhan)

Please pull or let me know of any problems! Thanks!


	Gustavo

---
The following changes since commit f4e1a4d3ecbb9e42bdf8e7869ee8a4ebfa27fb20:

  rt2800: change initialization sequence to fix system freeze (2013-09-09 14:44:34 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to 5bcecf325378218a8e248bb6bcae96ec7362f8ef:

  Bluetooth: btusb: Add support for Belkin F8065bf (2013-09-23 17:44:25 -0300)

----------------------------------------------------------------
Andre Guedes (2):
      Bluetooth: Fix security level for peripheral role
      Bluetooth: Fix encryption key size for peripheral role

Gianluca Anzolin (1):
      Bluetooth: don't release the port in rfcomm_dev_state_change()

Johan Hedberg (2):
      Bluetooth: Introduce a new HCI_RFKILLED flag
      Bluetooth: Fix rfkill functionality during the HCI setup stage

Ken O'Brien (1):
      Bluetooth: btusb: Add support for Belkin F8065bf

Peng Chen (1):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Syam Sidhardhan (1):
      Bluetooth: Fix ACL alive for long in case of non pariable devices

 drivers/bluetooth/ath3k.c   |  2 ++
 drivers/bluetooth/btusb.c   |  5 +++++
 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_core.c    | 26 ++++++++++++++++++++------
 net/bluetooth/hci_event.c   |  6 +++++-
 net/bluetooth/l2cap_core.c  |  7 +++++++
 net/bluetooth/rfcomm/tty.c  | 35 ++---------------------------------
 7 files changed, 42 insertions(+), 40 deletions(-)


--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSQKwBAAoJEPs3PUX4s20oo6QP/0R2LOHl5VRFKx7TJfKFLMLe
ZeFGBxK2jKTA1xRGhJ4dUJ6Li6K8QpfA0TMkINk5HGmA9QMc2fO2IUF6o+I0jjlx
j+A43w54bvG0I0xCG23sl+a3vkMUXWCXOCycZPE3a3GUCyphFwBxal6vEt3AlOQl
gXhDzO/+DPxzTW3wPS6Am3z33q8d2IFbPZFQYC6TEPKgJw3og7Sc60pcBiZl8r0v
8TeaT/n40IY2lBKHyhkTB3MnUJVV07F0FAnzgfg/Lp7Up5FQkPSgvq07aHYbSE6M
S969jaNy0jN8KJk7gXF/1arwit566d1ymZRtk0At2AtUFyyaC2kLmAIS1LG8o8aB
+IZylN0N7SEstn3yjPitBEbEWjxBEJyeLn++SmHsMSspKxj0R3VKKpjogZ6jxpHY
twhpUeIx4Ls3r3+I6u0hOornF6QydymcUs+thgEjyf+GaYj8M9OlOq3m6WDC1UL7
64RTfq3KXQjpOw6A3ayessbmZHS7qIncfh+kcNO73+903/KyBmdDZVsnrwRrs07V
E9m9cHiQg+TRzuncHDrD55jLKN4tICx3yf1oESBT4UrpsWlbP/9rE+nif8eQkJCj
l4HnAA0KzsCy08zqlYh7XMMC9navDoyYR+AIZ1p1MtjNRKgXZJxT1Q5JhasAC3gr
Gt+C8CMWPA6rH//aCnWW
=TPFZ
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
