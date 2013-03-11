Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3CKBil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:38:41 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:62242 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3CKBij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:38:39 -0400
Date: Sun, 10 Mar 2013 18:38:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.9-rc2
Message-ID: <20130311013835.GA2104@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Except for the largish
change to the ALPS driver adding "Dolphin V1"  support and Wacom getting
a new signature of yet another device, the rest are straightforward
driver fixes.

Thanks!

Changelog:
---------

Dave Turvene (1):
      Input: ALPS - add "Dolphin V1" touchpad support

Kamal Mostafa (1):
      Input: cypress_ps2 - fix trackpad found in Dell XPS12

Kevin Cernekee (1):
      Input: ALPS - remove unused argument to alps_enter_command_mode()

Mark Brown (2):
      Input: ads7864 - check return value of regulator enable
      Input: mms114 - Fix regulator enable and disable paths

Rabin Vincent (1):
      Input: tc3589x-keypad - fix keymap size

Stephan Frank (1):
      Input: wacom - add support for 0x10d

dave turvene (1):
      Input: ALPS - update documentation for recent touchpad driver mods

Diffstat:
--------

 Documentation/input/alps.txt            | 67 +++++++++++++++++++++++---
 drivers/input/keyboard/tc3589x-keypad.c |  8 ++--
 drivers/input/mouse/alps.c              | 85 ++++++++++++++++++++++++++++-=
----
 drivers/input/mouse/alps.h              |  1 +
 drivers/input/mouse/cypress_ps2.c       | 19 +++++---
 drivers/input/tablet/wacom_wac.c        |  4 ++
 drivers/input/touchscreen/ads7846.c     |  7 ++-
 drivers/input/touchscreen/mms114.c      | 34 +++++++++----
 8 files changed, 185 insertions(+), 40 deletions(-)

--=20
Dmitry


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRPTWbAAoJEH70+W8r6ZYqrkMQALf63y7FDfQ7CPBbBgElg4qo
Yn94a/VwWUjDdyy1a+Qm45kKQA9mrK15w1bXmtjb5VhD0cCnAPJigKqBVXYJdG0e
Lxd9lWWK1+Ke14pctcp56PSWsKJBeKqbIFYr0+bDuHi/QyyTc+8bwvzjUxw8UvqO
D4peZbEeUtNUApBs5KhmHqsmfmBoPHdNktpED+LMHYMUB/eBxjHZndoKQ0EH62t9
FCRze3H7ygfPF0RthRhbTPaKOencOCczxrsfzq+pgtzeVLNPHY8/5Qul+gQCz1TY
yERiobna1jqwGLp2ssHmBhkHaGblAsgALPrqqSuVUkLcDYZJHFjhowliNJ2c+dQ+
S++vkoD6hkzLkdCpMbVzI+dgn7JPirbJ7iFC4IOjKVcYm3mAL5E8ygaZbHNvoaLy
eAm1Xi/FdZ2MGcBa5vF8jurPUjzM/xadnvtOwaBLRtSUbqeMjLXUGD9sYhcvdAOI
dGX6kiM/PnOft+QhcHv7iARo4tDpLsVArNGsY3L5ChsaMAI4+tX6ZWTkAmntT30D
oyQUFHjM/YpB+SfequnX083lv9+MVrR/qIGpyRDGleXihbasysEmqBgg2Sk1hbPG
hxglM0syKYNHbGDCvBV+28OjZIisvgx3l7EtMNoh+5nCLQkZHhuK0AjZJsFGVxsh
ELVkOLFB01PLggP2/FSJ
=YJvb
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
