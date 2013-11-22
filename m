Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab3KVW5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:57:14 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42206 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab3KVW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:57:12 -0500
Date: Fri, 22 Nov 2013 14:57:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.13-rc0 (2nd)
Message-ID: <20131122225700.GC12800@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem. You will get a
new driver for Surface 2.0/Pixelsense touchscreen and a couple of driver
fixups.

Changelog:
---------

Dan Carpenter (1):
      Input: hp_sdc_rtc - unlock on error in hp_sdc_rtc_read_i8042timer()

Dmitry Torokhov (1):
      Input: atmel-wm97xx - fix compile error

Florian Echtler (1):
      Input: add sur40 driver for Samsung SUR40 (aka MS Surface 2.0/Pixelse=
nse)

Haiyang Zhang (1):
      MAINTAINERS - add keyboard driver to Hyper-V file list

Xie XiuQi (1):
      Input: cyttsp4 -  remove unnecessary work pending test


Diffstat:
--------

 drivers/input/misc/hp_sdc_rtc.c          |   5 +-
 drivers/input/touchscreen/Kconfig        |  11 +
 drivers/input/touchscreen/Makefile       |   1 +
 drivers/input/touchscreen/atmel-wm97xx.c |   2 +-
 drivers/input/touchscreen/cyttsp4_core.c |   3 +-
 drivers/input/touchscreen/sur40.c        | 466 +++++++++++++++++++++++++++=
++++
 6 files changed, 484 insertions(+), 4 deletions(-)
 create mode 100644 drivers/input/touchscreen/sur40.c

--=20
Dmitry


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSj+E8AAoJEH70+W8r6ZYqDr4P/1r6t9zqCqEPhBV0pxJ3tmE/
HHmZx2wKWcCZvaQJV/bWNZJhIbjK8riV9Q1usyHNGpa82QEFHf7zKY+H7dOpzxia
NA7ixX2R9Ks1LRMSOJOIIWBMjG4rZ55YOvD7tQA4cXLlYNQEV+8v5iregdXztdc0
Sdn/wMh3hZ/LoW7i1EWisUHKth2Av2LCNpgdeuSnAizilHjC58UTf5F0lwKB5vhk
19j8RPNFpS5quPU65g+m11SdxQbh7Bufw67L3J72Z6ecelgW4YbPeP9erMN2Wd6O
l5TQkO+QoCdXsajR8c5P/X+x+1jVR6RclnxQsMKYBimc/RjZ25VurBVh7HIiLWGw
JoLcYGHrHH6+Q4y+s5nc1XEvbET9TtfCg9dABiT5QEII+ir9x6w0dmeWSxuLua/2
GlOyRoZoMqDXax+yxwdd1pG0p+yQy5SIUezCmoQY479jMY//gx53Sf+4QRRB3ZY4
JBknahK6Taog8Ft8hLNL235zC0+CocJEM9aLtH4luLDvoHgoAtcbj84nqkLt19HP
UV611AXnUaIc1Qe3a9QIjhDqCR6V5HqiDESonbuzyNTiOOU8oLNdkjALA/17JmsL
orNep6WIADUU75KlXD2C8f2agtqVA1BlMipItV/l8/37jpMHC8tbgaq0+/77sEqB
+bJQh402aUiUqCtM0qQ1
=Eckf
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
