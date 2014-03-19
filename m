Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaCSVvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:51:53 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:35382 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaCSVvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:51:50 -0400
Date: Wed, 19 Mar 2014 18:51:43 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-03-19
Message-ID: <20140319215143.GB9454@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

One more pull request to 3.15. This is mostly and bug fix pull request, it
contains several fixes and clean up all over the tree, plus some small new
features.
=20
Please pull or let me know of any problem. Thanks.

	Gustavo

---
The following changes since commit 81ad6fd9698f659dbabdc6cd3e1667a98eb2be3b:

  Bluetooth: Remove unnecessary stop_scan_complete function (2014-02-28 10:=
28:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 40b552aa5a0bfa785bc7ddb5c2d7965b1e0bb08d:

  Bluetooth: Enforce strict Secure Connections Only mode security (2014-03-=
19 23:30:32 +0200)

----------------------------------------------------------------
Alexander Aring (1):
      Bluetooth: make bluetooth 6lowpan as an option

Andre Guedes (1):
      Bluetooth: Enable duplicates filter in background scan

Andrew Earl (1):
      Bluetooth: Fix aborting eSCO connection in case of error 0x20

Arnd Bergmann (1):
      Bluetooth: make sure 6LOWPAN_IPHC is built-in if needed

Claudio Takahasi (1):
      Bluetooth: Fix removing Long Term Key

Gustavo Padovan (1):
      Bluetooth: Fix skb allocation check for A2MP

Joe Perches (1):
      Bluetooth: Convert uses of __constant_<foo> to <foo>

Johan Hedberg (9):
      Bluetooth: Fix expected key count debug logs
      Bluetooth: Fix updating SMP remote key distribution information
      Bluetooth: Fix const declaration for swap function src parameter
      Bluetooth: Fix smp_e byte order to be consistent with SMP specificati=
on
      Bluetooth: Fix MITM flag when initiating SMP pairing
      Bluetooth: Simplify logic when checking SMP_FLAG_TK_VALID
      Bluetooth: Increase SMP re-encryption delay to 500ms
      Bluetooth: Fix SMP user passkey notification mgmt event
      Bluetooth: Fix Pair Device response parameters for pairing failure

Marcel Holtmann (3):
      Bluetooth: Add support for handling signature resolving keys
      Bluetooth: Make LTK and CSRK only persisent when bonding
      Bluetooth: Enforce strict Secure Connections Only mode security

Michael Knudsen (1):
      Bluetooth: Stop BCSP/H5 timer before cleaning up

Peng Chen (2):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.
      Bluetooth: Fix endianess issue in the ath3k driver

Valentin Ilie (1):
      Bluetooth: Remove assignments in if-statements

 drivers/bluetooth/ath3k.c        |  13 ++--
 drivers/bluetooth/bfusb.c        |  14 ++--
 drivers/bluetooth/bluecard_cs.c  |   9 ++-
 drivers/bluetooth/bt3c_cs.c      |   7 +-
 drivers/bluetooth/btuart_cs.c    |   6 +-
 drivers/bluetooth/btusb.c        |   1 +
 drivers/bluetooth/dtl1_cs.c      |   9 ++-
 drivers/bluetooth/hci_bcsp.c     |  31 ++++----
 drivers/bluetooth/hci_h5.c       |  10 +--
 drivers/bluetooth/hci_ldisc.c    |   9 ++-
 include/net/bluetooth/hci_core.h |  11 ++-
 include/net/bluetooth/mgmt.h     |  12 ++++
 net/bluetooth/6lowpan.h          |  21 ++++++
 net/bluetooth/Kconfig            |   8 ++-
 net/bluetooth/Makefile           |   3 +-
 net/bluetooth/a2mp.c             |  12 +++-
 net/bluetooth/hci_conn.c         |  37 ++++++----
 net/bluetooth/hci_core.c         |  14 ++--
 net/bluetooth/hci_event.c        |  27 +++++--
 net/bluetooth/hci_sock.c         |  16 ++---
 net/bluetooth/l2cap_core.c       |  90 +++++++++++------------
 net/bluetooth/l2cap_sock.c       |   6 +-
 net/bluetooth/mgmt.c             |  83 +++++++++++++++------
 net/bluetooth/rfcomm/core.c      |   4 +-
 net/bluetooth/sco.c              |  10 +--
 net/bluetooth/smp.c              | 208 +++++++++++++++++++++++++++++++++++=
------------------
 net/bluetooth/smp.h              |   4 +-
 27 files changed, 451 insertions(+), 224 deletions(-)

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKhFvAAoJEPs3PUX4s20oHd8QAIId/F2JXuIATU5W0XZUpEz+
0IO5O+bwrngN9AE8CpF4QePSvMchbse7PA5A4bGCummUINTNceqhelS9ViLSklOF
BcsdbiLWqx26r7qoPymdAL4JbfO65fopGAkDalId2r/OED/IX6nVPvs4YLgHabji
sM8zvG/moP4+VtTrOLtWykFxQ8KAAdnd94WS2EUJjQNyp+a8fZzd1F4kCXImrw2u
MRXFwkYEQ6vlPrKlx/Bfm8J/Q5r++hCXu8CZsn1ho1kqHE9Byy8xIJE6pTA8Ku8S
wCgQFFTxRJ85qrDMjPWaDIXj1YLI0jU+653lsQhgVXQTxNtx7lsYC0vmKokbh+o2
1eUJmratthZC4GZyxElh9AikKZDKuLsPuWJm1YYTG8FJqntvGST0xzhmQmzug7Em
RKyJPRuK2swKTlMXSIT5WuzYTFvw4YsWeWtBtekNRJcOHVkVZOQ/tOG2gh8xmIax
X+eVETyCb8lF/i8jYPMstMAp452J0nK+zQ5fStmmxzWgzPwnjv5AHowYQqapKNQq
WcLk+tqcmfWitW1+rmHzX2tz2vKvGVMNR5UIlSVaIz7PbGng3fwu0i0z3fMixmoe
sczYoKQOJzYTfSG5TGq0sbiIBqhv7hT73As4vq/OcWfT3syqLTMGezQ5amtpE3JP
mE/QvTT5SufNzWAZBQBq
=i7cO
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
