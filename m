Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaHEXzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:55:20 -0400
Received: from ring0.de ([5.45.105.125]:41809 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaHEXzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:55:18 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 6 Aug 2014 01:55:10 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HSI changes for 3.17
Message-ID: <20140805235510.GB4157@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b357d7b58f379ebe8038cd97b6204f2f5c52220d:

  hsi: omap_ssi_port: use normal module refcounting (2014-06-05 00:59:05 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git tags/hsi-for-3.17

for you to fetch changes up to 3fd276e9c0d75538c3b5ed96d0ce36d227fdca95:

  HSI: omap_ssi: Fix return value check in ssi_debug_add_ctrl() (2014-07-31 00:20:33 +0200)

----------------------------------------------------------------
HSI changes for the v3.17 series

 * misc. fixes in SSI related drivers

----------------------------------------------------------------
Andrey Utkin (1):
      drivers/hsi/controllers/omap_ssi{,_port}.c: fix failure checks

Wei Yongjun (3):
      HSI: ssi_protocol: Fix sparse non static symbol warning
      HSI: omap_ssi_port: Fix return value check in ssi_debug_add_port()
      HSI: omap_ssi: Fix return value check in ssi_debug_add_ctrl()

 drivers/hsi/clients/ssi_protocol.c      |  2 +-
 drivers/hsi/controllers/omap_ssi.c      | 14 +++++++-------
 drivers/hsi/controllers/omap_ssi_port.c | 15 ++++++++-------
 3 files changed, 16 insertions(+), 15 deletions(-)

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT4W7eAAoJENju1/PIO/qaQFIP/1Ok7lI7Aq+r6MrPYNbGS1rY
BFPqGJSYMj4oLmmcmT0ldyaFKuCZUtqCYVT6lKFKwVfeggeTKQ69hy46VcmaPPm5
VbQJVnAKlMj2B3LSNOVcwMpIjA1HlO53VXHpKBaEF8g2ucAxaYHDrpHZiAdclOrO
0PO2xsLDzZwFpn/gDvo2YG0W4pZGs/UqBOe4kEqvRcOobI9Dd/VVVf2MJ3w1Tb3V
DLCwOWsqmBBjWykIsVVbnQq8hs6D838qY4S2/rPrg5zB7CA9moGhDGr7Km1QsDGu
SdNTVw9PNe57mWLWwtYXwrOnS8if/KEm6TIheVZlDqKBI/CeIx3kyq90nTUtACHB
LhK6S8gOP8vyQMbHx3afmE9jpZuPwAJUhh1IqIWuNIf0QSVWkR3jNpDSsBB4dh++
KQFhWCpAAG5iGRYIu9d2/qUUapn2Lo0iq9iZ1FE6pwTigs15Uckh+KVKRjq6tBjm
bUkIoXOMBQ2ItmBVZpjwnSd62/bQXGmY3RfLqMMDbi8z4tR2GBOZuqvQyOyxQ8Ev
GL2QWzaZGXAByLKw+r+3SooPIIawEDSxXt3NJhe0s1nJdYGYTx32E1wUuS7+0mKc
l/+nNiYFuD7khPGMJjYP3WaKkH1LLo41IO0D0o4WtgOsAffGJFWyO/oi6oDbHT1j
aP7Jgz5x83uyg0u3/iax
=k5Nx
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
