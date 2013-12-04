Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab3LDNZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:25:34 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:43566 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3LDNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:25:32 -0500
Date: Wed, 4 Dec 2013 11:25:27 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-12-04
Message-ID: <20131204132527.GD1608@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

This is the first batch of patches intended for 3.14. There is nothing big here.
Most of the code are refactors, clean up, small fixes, plus some new device id
support.

Please pull or let me know of any problems! Thanks.

	Gustavo

---
The following changes since commit 4b074b07625f603d40d4d04937f8874a00415dc4:

  Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next (2013-12-02 14:25:38 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 201a5929c8c788f9ef53b010065c9ce70c9c06f0:

  Bluetooth: Remove dead code from SMP encryption function (2013-12-04 11:09:05 -0200)

----------------------------------------------------------------
Andre Guedes (5):
      Bluetooth: Check address in mgmt_disconnect_failed()
      Bluetooth: Add an extra check in mgmt_device_disconnected()
      Bluetooth: Remove link type check in hci_disconn_complete_evt()
      Bluetooth: Remove unneeded check in hci_disconn_complete_evt()
      Bluetooth: Refactor hci_disconn_complete_evt

Bing Zhao (3):
      Bluetooth: btmrvl: operate on 16-bit opcodes instead of ogf/ocf
      Bluetooth: btmrvl: use cal-data from device-tree instead of conf file
      Bluetooth: btmrvl: remove cal-data byte swapping and redundant mem copy

Johan Hedberg (3):
      Bluetooth: Remove unnecessary 'send' parameter from smp_failure()
      Bluetooth: Remove useless smp_rand function
      Bluetooth: Remove dead code from SMP encryption function

Marcel Holtmann (4):
      Bluetooth: Fix limited discoverable mode for Zeevo modules
      Bluetooth: Set default own address type only during controller setup
      Bluetooth: Remove debug statement for features complete event
      Bluetooth: Store supported commands only during setup procedure

Sujith Manoharan (2):
      Bluetooth: ath3k: Add support for another AR3012 card
      Bluetooth: ath3k: Add support for a new AR3012 device

Tedd Ho-Jeong An (2):
      Bluetooth: Add support for Intel Bluetooth device [8087:0a2a]
      Bluetooth: Enable autosuspend for Intel Bluetooth device

 drivers/bluetooth/ath3k.c       |   4 ++
 drivers/bluetooth/btmrvl_drv.h  |  25 +++++-----
 drivers/bluetooth/btmrvl_main.c | 130 ++++++++++++---------------------------------------
 drivers/bluetooth/btmrvl_sdio.c |   9 +---
 drivers/bluetooth/btmrvl_sdio.h |   2 -
 drivers/bluetooth/btusb.c       |   7 ++-
 net/bluetooth/hci_core.c        |  20 ++++----
 net/bluetooth/hci_event.c       |  72 +++++++++++++---------------
 net/bluetooth/mgmt.c            |  17 ++++++-
 net/bluetooth/smp.c             |  40 +++++-----------
 10 files changed, 124 insertions(+), 202 deletions(-)


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSny1HAAoJEPs3PUX4s20oN78P/19j7gjAyV3fpN6MKwGAOed2
PRSfOhF+wamFApivrWFmceF3aEnUkSV7F4dJUshUEQ25GiubD9Nkx6eiISpJ6xtM
2jC8Zf//ntdSWwwFzuULeWI3xVT2McOOk2BnPU4jAXOBZLeRZuwujFi9pNFt63AE
sdseeUIumrit47o5589oNRTduOUaPX2Tl+niqWIRh3Eqc2JTDadp5Ny61k7fzctz
C4MUdO8YRO59MPIDmLLx9M40ApUZvNO12aaZlNIIZLio21D6912Oe2tWf0R2WE3O
wOCqq+UsalSSgOMYfTqMDLvj86C7OsIP9oN87lBjNzfhGoR9O0Li6nIlV7nqq2cA
IDjFkk9ysGkSLTkN31DazDJkjted2FawjzOyqp9ReW89kts1w3+6d4bt2PaSgN1X
x2BS0SX0IpVUNEdO6L9POAyq0jG3jBSwoIrWJXKjCUFlYscgCEZMWU/V4HSQLEDe
ZMNwS5WcDzUGnTnPktrfSbQe3nYilz31lBRDhXF6cuGAy3Fw8PXtcOWppBXpd9wI
NX1/HfPgjkwf/4PaHnoTnOcUR66JK9KPyagHrYq13YGyzPHsevF0t/7bZ0ua2FNi
p71ucuPSbM/FAgyS+W0a9crnIEH82F/uixvtiPXl6HBlpTf8pw3f6uyeUCi8T/5U
Uw2e4vyQEL+fnSI0RTb6
=aM32
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
