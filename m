Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab3HUQMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:12:30 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:42967 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3HUQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:12:29 -0400
Date: Wed, 21 Aug 2013 18:12:18 +0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-08-21
Message-ID: <20130821161218.GH14645@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Patches to 3.12, here we have:

* implementation of a proper tty_port for RFCOMM devices, this fixes some
issues people were seeing lately in the kernel.
* Add voice_setting option for SCO, it is used for SCO Codec selection
* bugfixes, small improvements and clean ups

Please pull, Thanks.

	Gustavo

--
The following changes since commit 72bb2f2678878dd4a758e628957f29ce28000d88:

  bgmac: make bgmac depend on bcm47xx (2013-07-24 11:05:19 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next ma=
ster

for you to fetch changes up to 2dea632f9acad076370fe871d4ccc93868621403:

  Bluetooth: Add SCO connection fallback (2013-08-21 16:47:13 +0200)

----------------------------------------------------------------
Andy Shevchenko (1):
      Bluetooth: use DIV_ROUND_UP in suitable places in btmrvl_sdio

Benjamin Tissoires (2):
      Bluetooth: hidp: implement hidinput_input_event callback
      Bluetooth: hidp: remove wrong send_report at init

Fr=E9d=E9ric Dalleau (10):
      Bluetooth: Use hci_connect_sco directly
      Bluetooth: Remove unused mask parameter in sco_conn_defer_accept
      Bluetooth: Add Bluetooth socket voice option
      Bluetooth: Add constants for SCO airmode
      Bluetooth: Use voice setting in deferred SCO connection request
      Bluetooth: Parameters for outgoing SCO connections
      Bluetooth: Add constants and macro declaration for transparent data
      Bluetooth: Prevent transparent SCO on older devices
      Bluetooth: Handle specific error for SCO connection fallback
      Bluetooth: Add SCO connection fallback

Gianluca Anzolin (6):
      Bluetooth: Take proper tty_struct references
      Bluetooth: Remove the device from the list in the destructor
      Bluetooth: Move the tty initialization and cleanup out of open/close
      Bluetooth: Implement .activate, .shutdown and .carrier_raised methods
      Bluetooth: Fix the reference counting of tty_port
      Bluetooth: Purge the dlc->tx_queue to avoid circular dependency

Gustavo Padovan (1):
      Bluetooth: Add missing braces to an "else if"

Jingoo Han (1):
      Bluetooth: replace strict_strtol() with kstrtol()

Johan Hedberg (1):
      Bluetooth: Fix getting SCO socket options in deferred state

Marcel Holtmann (2):
      Bluetooth: Fix simple whitespace vs tab style issue
      Bluetooth: Set different event mask for LE-only controllers

Mikel Astiz (3):
      Bluetooth: Add HCI authentication capabilities macros
      Bluetooth: Use defines in in hci_get_auth_req()
      Bluetooth: Use defines instead of integer literals

 drivers/bluetooth/btmrvl_debugfs.c |   6 +-
 drivers/bluetooth/btmrvl_sdio.c    |   4 +-
 include/net/bluetooth/bluetooth.h  |   8 ++
 include/net/bluetooth/hci.h        |   7 +
 include/net/bluetooth/hci_core.h   |  10 +-
 include/net/bluetooth/sco.h        |   1 +
 net/bluetooth/hci_conn.c           |  62 +++++++--
 net/bluetooth/hci_core.c           |  14 +-
 net/bluetooth/hci_event.c          |  29 +++--
 net/bluetooth/hidp/core.c          |  40 ++++--
 net/bluetooth/l2cap_core.c         |   3 +-
 net/bluetooth/rfcomm/tty.c         | 271 ++++++++++++++++++---------------=
------
 net/bluetooth/sco.c                |  85 +++++++++---
 13 files changed, 334 insertions(+), 206 deletions(-)



--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSFObiAAoJEPs3PUX4s20odAUP+gJdtaJWVr7uFaGbxcRjV4OT
eWpdJGDYdL8Oxlp19dwzJE9QGwzxiVYexnTn5XjOT0rJEMVyFe5lVqgcM+XuooUv
mZ09acvF1FWsVkYLlpuCXNy6/kezulhRiJAw70kpEx7fywH+m18PDP+oNSMIif9U
3tUxfhrGKrZAAqyI6WZ9PLqXm4MHOf6PbwdnbdVyC5SO6PSn5snaQlUY9F1tegrp
0t3SKbM5rs/w3dffPdAdzmSh717/PamRN/Nw60Qs/rp7nGkaBqQm2RPgeK4zycDl
Qep5lZ0mthhf6H/X/cZiqak+5MNOqjTUCPErG1wDtxkJ7zUoaPkd9BOC+QseuDik
c/Gim0okwcPVhY1Ia5QU+x60VgGSVXl8DsnqpWBrHxOqWQQCSm2HpLAdWJjXohai
CXj7+3uqaM06fz3EIpu2xVq6G1P+FAqIaA03tpZKpBbwE6/DakGL31t4TK2I/mqL
f74QBL08SyB3poInFS8W8dUC8efDX2stwOHleT50lnDX9rT4TpcbQZqm3l51gCmt
OE4b3PldIynfSpKDGBR56+uNPYJ4gYCGylXaasEG792W4NgLtsPwSntdkLhspv1h
5vFa7OKC4hcKx1dQ4I4lGWlhhqOrInYr9aoICU7gD5vBua7HaP+7N8vtxKDXTD9F
p3hCv0Y3BUDPrfixHVZ7
=9L8j
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
