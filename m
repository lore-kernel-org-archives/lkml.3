Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3LRMwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:52:45 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36969 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3LRMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:52:43 -0500
Date: Wed, 18 Dec 2013 10:52:36 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-12-18
Message-ID: <20131218125236.GA1376@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Two patches in this pull request. An important fix from Marcel in the
permission check for HCI User Channels, there was a extra check for
CAP_NET_RAW, and it was now removed. These channels should only require
CAP_NET_ADMIN. The other patch is a device id addition.

Please pull or let me know of any problems! Thanks.

        Gustavo

---
The following changes since commit eafbdde9c5629bea58df07275c5917eb42afbbe7:

  rtlwifi: rtl8192cu: Fix more pointer arithmetic errors (2013-11-15 14:29:33 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream

for you to fetch changes up to 1bc5ad168f441f6f8bfd944288a5f7b4963ac1f6:

  Bluetooth: Fix HCI User Channel permission check in hci_sock_sendmsg (2013-12-17 13:47:27 +0200)

----------------------------------------------------------------
Marcel Holtmann (1):
      Bluetooth: Fix HCI User Channel permission check in hci_sock_sendmsg

Marco Piazza (1):
      Bluetooth: Add support for Toshiba Bluetooth device [0930:0220]

 drivers/bluetooth/ath3k.c |  2 ++
 drivers/bluetooth/btusb.c |  1 +
 net/bluetooth/hci_sock.c  | 26 ++++++++++++++++----------
 3 files changed, 19 insertions(+), 10 deletions(-)


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSsZqUAAoJEPs3PUX4s20oc+wQALE4nVpiebImQrqwbmxPKvfW
3iq8A+0/7FAN3HkwBV3eZcxAkDcxWUH+Gpk4yYfQBgFyEk+cZRP3sZ8ueK7pyw0e
af6EQ1DQReO1ESqquuwg7FKmAReCSsQD7SMOf6lgajcPIaD0K+qBZh0U7umbXsYH
5vIbwvdmoYbbShs+gknbJKjoRyceYCe1hZ7a6AenlgUOtT7i6bLNPSO6Jew2s9p8
V7XVrHRmQOtIdRGW0HtiJLUWvaI7cuxU1FIgTFAyawWG/OmB2wZ8zE/UIBWjB/35
JM5JaYgWMKIJuWmn9vgMigCmRy7MnTCnhQ9c8YhY+Xp/IC73tONmAhdimEL4g8hO
9lj0kbgOPcRBVpDbFBruesFUm/QU1cOkT6ojcqbgdL+QvsI2R3vDUj6U5X26v9xv
VcMAnOSBcClgeZNvd6NDe9IVdgpZgKYnqZ8xYd+yg0ca4c8SE/TXY3HMcf8m2KY3
ZIHcWP4YqqSVU8MwoYiL9mXX7/m9QOZ6SY0RlUXN449bftIuSvrxIlaexp+rwufB
13+MmL611U1LXX4Dz4JSMfm/WkTZB5iNDwjdkSgnBkvfai3RjTUcBVsz9UwGeTIE
X69dFEvzD4I0JgaEHeRY3lisJKLhTm+t1b2b2agYirIssLKpYWqc9A41IVOqUp1W
VuUrjMLWcK4foa8d7YHZ
=yAmU
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
