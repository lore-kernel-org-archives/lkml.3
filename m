Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3FXBm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 21:42:56 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36212 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3FXBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 21:42:55 -0400
Date: Sun, 23 Jun 2013 18:42:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.10-rc4
Message-ID: <20130624014251.GA30264@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a few small
fixups for cyttsp, wacom and xpad drivers.

Changelog:
---------

Ben Hutchings (1):
      Input: add missing dependencies on CONFIG_HAS_IOMEM

Ferruh Yigit (2):
      Input: cyttsp - fix memcpy size param
      Input: cyttsp - add missing handshake

Matthias Kaehlcke (1):
      Input: cyttsp - fix swapped mfg_stat and mfg_cmd registers

Ping Cheng (1):
      Input: wacom - add a new stylus (0x100802) for Intuos5 and Cintiqs

Shawn Joseph (1):
      Input: xpad - fix for "Mad Catz Street Fighter IV FightPad" controllers


Diffstat:
--------

 drivers/input/joystick/xpad.c           |  2 +-
 drivers/input/keyboard/Kconfig          |  1 +
 drivers/input/serio/Kconfig             |  1 +
 drivers/input/tablet/wacom_wac.c        |  2 ++
 drivers/input/touchscreen/cyttsp_core.c | 28 +++++++++++++++++++++-------
 drivers/input/touchscreen/cyttsp_core.h |  2 +-
 6 files changed, 27 insertions(+), 9 deletions(-)


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRx6QbAAoJEH70+W8r6ZYq2WoP/R5bT8N61JamZjHJQjXmO3sx
G/0mt2UWHCXdCdOeL0tDYE1WW/sIyWC4IfdKXFCEK51UpP39TTh+969sLaxSrpni
XyQ7rTOd9tMopk4u4Iy3ZWpNciQp285uqclFoCwKStz3r4v64nCSaFnBK3fE4pNl
+Gdw5BHZSrvsDaJvynk5vzV0NOALT2GTHVXx/1NSlN0IAn2WcteLVdCeWNrnq8Go
QVSUIyPMsJMWUeBknU6Mc6zuG9+FciL9QimDeg+IKtIgV/eVS9WZ+jhcurcxeY+O
U0fse6LCbaKtBs4Y90kH8JF7VlJJqWVYUuvJa87Mj1FGHJcLNbW+vhlfWrL0C9xr
uTxIeQX4rLZX4sI4F1UFCIesxM5pOoDHuNtbI8RcFr/4SefKo0YyEYwCnBuhylBq
IIggGWu1WUzePBT5gYFC0aJJZRwR/TVLb/aYuW3tg9ZRK9QAkUfGqmREZXWDBsRt
mACSQozubPMRILldMGLq/w9TZ5ERZ8N/sNqA5f9Ya9y7q+HJ3TRA2EFO6xzADjM6
EQ8WaqbbMHCAOQDptagCMu7svrTYhlsQdsfdYa/Rj6Sru3VApV9j86ZGgpS1l/VF
yrMBDWoAN7BoDEpbGYWmNQiUsY/QrLcyr6nLQE/Sww5eQg86pVblvo/I6Ar7O1i0
heTFVoLjYd3ciKIr8DVC
=2ABW
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
