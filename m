Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaGWF6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:58:46 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51716 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaGWF6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:58:44 -0400
Date: Tue, 22 Jul 2014 22:58:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.16-rc6
Message-ID: <20140723055840.GA25004@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive a few fixups for the input subsystem.

Changelog:
---------

Bjorn Helgaas (1):
      Input: sirfsoc-onkey - fix GPL v2 license string typo

Dmitry Torokhov (1):
      Input: fix defuzzing logic

Felipe Balbi (1):
      Input: ti_am335x_tsc - warn about incorrect spelling

Hans de Goede (1):
      Input: synaptics - add min/max quirk for pnp-id LEN2002 (Edge E531)

Jiri Kosina (1):
      Input: i8042 - add Acer Aspire 5710 to nomux blacklist

Peter Hutterer (1):
      Input: document INPUT_PROP_TOPBUTTONPAD

Ping Cheng (1):
      Input: wacom - cleanup multitouch code when touch_max is 2

Tobias Klauser (1):
      Input: st-keyscan - fix 'defined but not used' compiler warnings


Diffstat:
--------

 Documentation/input/event-codes.txt       | 13 +++++++++++++
 drivers/input/input.c                     |  6 ++++--
 drivers/input/keyboard/st-keyscan.c       |  2 ++
 drivers/input/misc/sirfsoc-onkey.c        |  2 +-
 drivers/input/mouse/synaptics.c           |  5 +++--
 drivers/input/serio/i8042-x86ia64io.h     |  7 +++++++
 drivers/input/tablet/wacom_wac.c          | 28 +++++++---------------------
 drivers/input/touchscreen/ti_am335x_tsc.c |  5 ++++-
 8 files changed, 41 insertions(+), 27 deletions(-)

--=20
Dmitry


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTz08QAAoJEH70+W8r6ZYqVIYQAKkm7Ojil3HoAqQapLa7q4BS
M1fQ/8Uea8aRrAa2jiZSJUSy8wbXtoWTvj6F/5aCj++YuEDgmmnqG5MJ3erluu68
i6GUbbzVnFFjf3JHecYCBjKTsNBjBimbjQgYxkKeJkLzufDTCAZ1mmkj7bxTFqNl
fvlprpBElBltlSWEBkgrlGdiB+Y/yTePzPpiKWc7qQONU4PLUDp7Ff6kM0Zj6Q5k
mh+NKD1ZuFMVSsPyZy4RTsFyOvzkUriM/HXmYHWXmkVU3Z25+xMgmdrobCQvvSUP
97hDSJMMGVZtK3BfbPXYPlMVtowRMEYqqlEapSlFmCojWhUSJv1X2heABG7jC2Tx
sPfK4qF9dgCJvbgPCE6qweJYVrZXVwOyj/+lgN0vIZMg3OmKjoaj4PMQ2J+dmZRX
BKVgx0m5RtbzT4CLqysjEuTwYGYf2ftriSKe/B0Xqxb4kiynY11SsflsRkD3gXcp
QLKNbO+m2hYZexdtueDOFtK0qUf2ak5afzssKK10eNcQJPupf/7oY22eQUXUZN02
akf5+DIXCozWs23tgflJphX7kbSnyeu8iAHPrY9Qp8DtGbDkTJZXop1onrQ62UcC
Do8TUR+15/uYiVNc6Vu2V5tGFR1VwJLOKbjVa2qAvIdqUrUzZ1c5TfIipWbgr94o
SoGffL4rqNaTpqJTS5/x
=hrTR
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
