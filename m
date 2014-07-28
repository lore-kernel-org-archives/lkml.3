Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaG1UQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:16:24 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:47024 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1UQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:16:21 -0400
Date: Mon, 28 Jul 2014 23:16:10 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@padovan.org
Subject: pull request: bluetooth-next 2014-07-28
Message-ID: <20140728201610.GA29494@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	gustavo@padovan.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

This pull request should replace the previous one that Gustavo made
(bluetooth-next 2014-07-23).

To quote Gustavo from his previous request:

"Some last minute fixes for -next. We have a fix for a use after free in
RFCOMM, another fix to an issue with ADV_DIRECT_IND and one for ADV_IND with
auto-connection handling.  Last, we added support for reading the codec and
MWS setting for controllers that support these features."

Additionally there are fixes to LE scanning, an update to conform to the 4.1
core specification as well as fixes for tracking the page scan state. All
of these fixes are important for 3.17.

Let me know if there are any issues. Thanks.

Johan

---
The following changes since commit c2aef6e8cbebd60f79555baeb9266e220f135a44:

  Bluetooth: Add support for Broadcom device of Asus Z97-DELUXE motherboard (2014-07-21 15:07:08 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 3bd2724010a51d5d15afa8065ac3c5fab3725499:

  Bluetooth: Fix incorrectly disabling page scan when toggling connectable (2014-07-28 20:13:32 +0200)

----------------------------------------------------------------
Alexander Aring (1):
      MAINTAINERS: add 6lowpan header file

Georg Lukas (2):
      Bluetooth: Provide defaults for LE advertising interval
      Bluetooth: Expose default LE advertising interval via debugfs

Johan Hedberg (2):
      Bluetooth: Fix clearing HCI_PSCAN flag
      Bluetooth: Fix incorrectly disabling page scan when toggling connectable

Marcel Holtmann (7):
      Bluetooth: Read list of local codecs supported by the controller
      Bluetooth: Get MWS transport configuration of the controller
      Bluetooth: Ignore ADV_DIRECT_IND attempts from unknown devices
      Bluetooth: Fix issue with ADV_IND reports and auto-connection handling
      Bluetooth: Add support for using controller white list filtering
      Bluetooth: Fix white list handling with resolvable private addresses
      Bluetooth: Set Simultaneous LE and BR/EDR controller option to zero

Vignesh Raman (1):
      Bluetooth: Avoid use of session socket after the session gets freed

 MAINTAINERS                      |   1 +
 include/net/bluetooth/hci.h      |   4 +
 include/net/bluetooth/hci_core.h |   3 +
 net/bluetooth/hci_core.c         | 181 ++++++++++++++++++++++++++++++++++-
 net/bluetooth/hci_event.c        |  35 +++++--
 net/bluetooth/mgmt.c             |  33 +++++--
 net/bluetooth/rfcomm/core.c      |   7 +-
 net/bluetooth/smp.c              |  16 ++++
 8 files changed, 260 insertions(+), 20 deletions(-)


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1q+KAAoJECQj9vv5qNQSDVkP/01iGLQLN0QCodBet7dGMRgu
sQxhNjqzjOkfgfTTIfl2BBBa4h10nHp+h9Qm65zp8oWNJc/rSVjZfC6Vq2CU/iNO
oxZ5Wt3n3WDr3wT3Tsccc1EglJc6Bgd9vso5GG97VSD0j1PDDVLITeJxtfH6J7Ry
VHzaRsqsAOsLt+UqWe1Rb++nTChI6zJkv8WTP7+gJTQEAghePHSFGvHdq8ylnXE8
Hrtwh6E1ktBTiIwjDMTgizi8rfxkWR/uwv8zxxv/v+O/FeO+43BA6lotaj98/qVq
lqKbBnwqMc2Rl4FL5s3IRt9MJNasTACv4MYHVbtiMYw8mQa2XOETfDJZoWHRBKrT
3+wBme6uShQH87y0xB5gaZTl6KERcR9QeqKy9/peUiHb7cmpHDJWEAP2wlJ0QLNJ
bLy4zv++w9kuIyBcq4EJjek5de5HUXjSEyq0JewFYFfzlrpBdUhBrBbAPar4wo1n
DcTsy15p6gvl8xnsjrOqjEb58gcN+dd6c4rC0ycMoKKBSWJAEu7hc+4VI95TJpp6
HOQS81Mg4Whzy5rnrIUgI0tVI4vV9E0Q19wKQNOgIcovUngt1hOE1hiL9QSI4pbf
pwW6u2rFpYPKhU1UG6Uq3fckJ723jInHytVPyd6piqSoTMNENXo/uoKyl2Nulg4v
AnD3L1RK5cV+vXo4Rk0m
=Hlxn
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
