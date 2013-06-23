Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3FWCYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 22:24:05 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:49249 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3FWCYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 22:24:01 -0400
Date: Sun, 23 Jun 2013 03:23:56 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-06-23
Message-ID: <20130623022356.GB2327@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Here goes a set of patches to 3.11. The biggest work here is from Andre Gue=
des
on the move of the Discovery to use the new request framework. Other than t=
hat
Johan provided a bunch of fixes to the L2CAP code. The rest are just small
fixes and clean ups.=20

Please pull or let me know of any problem! Thanks.

	Gustavo

---
The following changes since commit b887664d882ee4f6a67e0bf05e5f141d32fcc067:

  mwifiex: channel switch handling for station (2013-06-19 15:28:43 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream

for you to fetch changes up to b8f4e068004859eefac7b1ced59ddb67ca6d2d80:

  Bluetooth: Improve comments on the HCI_Delete_Store_Link_Key issue (2013-=
06-23 03:05:47 +0100)

----------------------------------------------------------------
Andre Guedes (14):
      Bluetooth: Make inquiry_cache_flush non-static
      Bluetooth: Update start_discovery to use HCI request
      Bluetooth: Remove start discovery handling from hci_event.c
      Bluetooth: Make mgmt_start_discovery_failed static
      Bluetooth: Move discovery macros to hci_core.h
      Bluetooth: Use HCI request in interleaved discovery
      Bluetooth: Update stop_discovery to use HCI request
      Bluetooth: Remove stop discovery handling from hci_event.c
      Bluetooth: Make mgmt_stop_discovery_failed static
      Bluetooth: Refactor hci_cc_le_set_scan_enable
      Bluetooth: Remove LE scan helpers
      Bluetooth: Remove inquiry helpers
      Bluetooth: Remove empty event handler
      Bluetooth: Mgmt Device Found Event

Andrei Emeltchenko (2):
      Bluetooth: Use HCI_MGMT instead of HCI_LINK_KEYS flag
      Bluetooth: Remove unneeded flag

Chen Gang (1):
      Bluetooth: hidp: using strlcpy instead of strncpy, also beautify code.

Gustavo Padovan (1):
      Bluetooth: Improve comments on the HCI_Delete_Store_Link_Key issue

Johan Hedberg (12):
      Bluetooth: Handle LE L2CAP signalling in its own function
      Bluetooth: Rename L2CAP_CID_LE_DATA to L2CAP_CID_ATT
      Bluetooth: Fix LE vs BR/EDR selection when connecting
      Bluetooth: Fix EBUSY condition test in l2cap_chan_connect
      Bluetooth: Fix hardcoding ATT CID in __l2cap_chan_add()
      Bluetooth: Add clarifying comment to l2cap_conn_ready()
      Bluetooth: Fix duplicate call to l2cap_chan_ready()
      Bluetooth: Remove useless sk variable in l2cap_le_conn_ready
      Bluetooth: Remove unnecessary L2CAP channel state check
      Bluetooth: Simplify hci_conn_hold/drop logic for L2CAP
      Bluetooth: Remove useless hci_conn disc_timeout setting
      Bluetooth: Fix multiple LE socket handling

Shuah Khan (1):
      Bluetooth: Add missing reset_resume dev_pm_ops

 drivers/bluetooth/btusb.c        |   1 +
 include/net/bluetooth/hci.h      |   1 -
 include/net/bluetooth/hci_core.h |  29 ++----
 include/net/bluetooth/l2cap.h    |   2 +-
 net/bluetooth/hci_core.c         | 192 +++++++++++-----------------------
 net/bluetooth/hci_event.c        |  71 ++-----------
 net/bluetooth/hidp/core.c        |  14 +--
 net/bluetooth/l2cap_core.c       | 121 +++++++++++++++-------
 net/bluetooth/l2cap_sock.c       |   4 +-
 net/bluetooth/mgmt.c             | 229 ++++++++++++++++++++++++++++-------=
------
 10 files changed, 321 insertions(+), 343 deletions(-)


--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRxlw8AAoJEPs3PUX4s20o7MgP/AwyX702tzgUX7IH7cpKHFJB
XXXbJSnvvJZC8h8ew+M2NRg7E93cJkRqdk4VFAj37jSaKpcaEHah7WXXtSzteucM
hRJq0LdoeK17TMbQC7ucoveOxUaOW0pF05+xGe12YL2PeuwyC8Y5ym4bwt+FtGNC
rksxj/q/1SerGO9B4IS4d19YfdzPj39fHy9DP0Nhu1figa0LsL+vENL/WcPVHiu4
/AAEIBVDHPAQRt05Mj70/v8eJzro2Gdt2RH39hqLgstmphPnAH+psvUdU4MUr+wD
ZaYmiOb9NFmJ0Nm46543fVF0QtQAi6GLDVo8vtSX68NGNF9Hg67CecdFEUTGa+qg
GNTucxkH6Cyol2c4CYL+zs0UVaqDWvaNLDhmqBfBM4LF6nBgiSQeV3NXuWfstxpo
fDM9rfnEXrRwc5RjN0aUBb3wK0qw4D4Lnjx8AeJU79keQIz6m9AjXS5ccZaOAnyX
eNa/HlzkPd39dm8KyY/wpAvhbL9u/k92qWelyXUpZeeoAVL1b974hlTt+vHmf9Ld
4XkXBKUKT3kTtIxnB0dsm0uf/W+r8f67KY050Nk9srRIviGY+wL1n03laUOUoFDX
u9lnGtLu5vUD8JZEIzhNTWTQhvZHg0Z7/5alRiUYrD+4w1l5T2uqDHQCG3QVnM+w
rEevGY+t1FoMxB7Q1p7B
=uyFy
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
