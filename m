Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaDXP1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:27:18 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:48174 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbaDXP1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:27:15 -0400
X-Greylist: delayed 79088 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 11:27:15 EDT
Date: Thu, 24 Apr 2014 12:27:09 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-04-24
Message-ID: <20140424152709.GE7832@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Here goes some patches for the -next release. There is nothing really speci=
al
for this pull request, just a bunch of refactors, fixes and clean ups.=20

Please pull, or let me know of any problems! Thanks.

	Gustavo

---
The following changes since commit e8b1ab9e6d30394e0df3e4f60bf56c4dc9bf0863:

  Bluetooth: Fix returning peer address in pending connect state (2014-03-2=
6 09:31:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 22e70786413ed05950207eda7be420c280b776d7:

  Bluetooth: Remove hci_h4 unused defines (2014-04-24 11:55:26 -0300)

----------------------------------------------------------------
Andre Guedes (1):
      Bluetooth: Use memdup_user in le_auto_conn_write()

Bing Zhao (2):
      Bluetooth: btmrvl: separate write-to-clear function from interrupt ha=
ndler
      Bluetooth: btmrvl: implement read-to-clear for SD8897 interrupts

Johan Hedberg (15):
      Bluetooth: Refactor advertising report processing into its own functi=
on
      Bluetooth: Move local identity address setting to a central place
      Bluetooth: Fix LE responder/initiator address setting
      Bluetooth: Add error mapping for Directed Advertising Timeout
      Bluetooth: Don't send device found events during passive scanning
      Bluetooth: Add scan_rsp parameter to mgmt_device_found()
      Bluetooth: Add directed advertising support through connect()
      Bluetooth: Merge ADV_IND/ADV_SCAN_IND and SCAN_RSP together
      Bluetooth: Remove redundant NULL check
      Bluetooth: Fix line splitting of mgmt_device_found parameters
      Bluetooth: Don't send device found events for duplicate reports
      Bluetooth: Store also RSSI for pending advertising reports
      Bluetooth: Fix RSSI value in device found event from disabling scan
      Bluetooth: Remove unnecessary NULL check in hci_inquiry_cache_update
      Bluetooth: Fix address in unmergeable device found events

Lukasz Rymanowski (3):
      Bluetooth: Keep msec in DISCOV_INTERLEAVED_TIMEOUT
      Bluetooth: Add new debugfs parameter
      Bluetooth: Keep msec in DISCOV_LE_TIMEOUT

Marcel Holtmann (1):
      Bluetooth: Return EOPNOTSUPP for HCISETRAW ioctl command

Mikel Astiz (3):
      Bluetooth: Refactor hci_get_auth_req()
      Bluetooth: Refactor code for outgoing dedicated bonding
      Bluetooth: Request MITM Protection when initiator

Petri Gynther (1):
      Bluetooth: btmrvl: Fix btmrvl_send_module_cfg_cmd()

Poulain, Loic (1):
      Bluetooth: Remove hci_h4 unused defines

Timo Mueller (1):
      Bluetooth: Use MITM Protection when IO caps allow it

 drivers/bluetooth/btmrvl_drv.h   |   4 +-
 drivers/bluetooth/btmrvl_main.c  |  19 +++-
 drivers/bluetooth/btmrvl_sdio.c  | 103 ++++++++++++++++----
 drivers/bluetooth/btmrvl_sdio.h  |   3 +
 drivers/bluetooth/hci_h4.c       |   7 --
 include/net/bluetooth/hci.h      |   1 +
 include/net/bluetooth/hci_core.h |  13 ++-
 net/bluetooth/hci_conn.c         |  81 ++++++++++++++--
 net/bluetooth/hci_core.c         |  20 ++--
 net/bluetooth/hci_event.c        | 246 +++++++++++++++++++++++++++++++++++=
------------
 net/bluetooth/hci_sock.c         |  11 +--
 net/bluetooth/lib.c              |   1 +
 net/bluetooth/mgmt.c             |  36 ++++---
 13 files changed, 407 insertions(+), 138 deletions(-)



--U+BazGySraz5kW0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWS1NAAoJEPs3PUX4s20ohvYP/RU10NTJw5n8If0Lu9kvaxPW
uQcjFv79pN0CgjhoRaQQ9JAeAH5wWDJJYOspP5bqhTOr9yxsacyHxalW7AJFIxsb
sm5goDObARrSGiPrCVvQVQSil/jUfBw7ksUwYwSEvFNkPs9L46kh0t06BSupg+JU
gVxWL+6J0wOm/SDIIaW85awzbqriXf11z78uq402PtMiUemH2Sh2KTlkg/k2BH7n
LNdOTZASRVQbgToGcIe/Rb9OtedUxcmFo5DfqGVrx/nYrowxx4FvJJLedfVd7KNG
zgnaIM9XQDz/D8y+DUrtdOpHfSqP57gAEyb9A5H9/Ic9K2OeXevicDvxOtyWEKjT
YgRrfxSKyeOYVG5XBXDRDMfpZfCUukhkoewcCBXOe49wT+c8nUyNxlUfGs0kS8hp
8ZoKJhoX1SB6t9PkArjV7e47Gf/Q2E+se/RrmnRcTy6VEqCyc4ChgXqyqmSFjiSO
Thm7rO/2I3qAJNOxJmruTOA9+vYNIgyglZGXuKlkFYqDsLjlUXTCywq7nXYaHbSt
EsdQlLsS3D50dsTgdHa0l+hv4XuqsMe4Ctn3XWWZqgz6G4vwmQOdIMFdSwtXAh92
rWxkiLsH9BWpZaIC4eeAwDwXgAe8JE86xyu7hijVLdkSeXDEWVSgVhRyBQ8GSC5V
6lUsLNsHJYrRETtPi0Nq
=lFEO
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
