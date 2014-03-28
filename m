Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaC1Tg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 15:36:56 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48988 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaC1Tgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 15:36:55 -0400
Date: Fri, 28 Mar 2014 12:36:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.14-rc8
Message-ID: <20140328193650.GB20950@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get updates to
Synaptics touchpad to better cope with devices in Lenovo laptops, and a
couple more fixes.

Changelog:
---------

Anthony Olech (1):
      Input: da9052_onkey - use correct register bit for key status

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk

Hans de Goede (2):
      Input: cypress_ps2 - don't report as a button pads
      Input: synaptics - add manual min/max quirk for ThinkPad X240

Jean-Francois Dagenais (1):
      Input: adp5588-keys - get value from data out when dir is out


Diffstat:
--------

 drivers/input/keyboard/adp5588-keys.c | 12 +++++++-
 drivers/input/misc/da9052_onkey.c     | 29 +++++++++---------
 drivers/input/mouse/cypress_ps2.c     |  1 -
 drivers/input/mouse/synaptics.c       | 55 +++++++++++++++++++++++++++++++=
++++
 4 files changed, 82 insertions(+), 15 deletions(-)

--=20
Dmitry


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNc9SAAoJEH70+W8r6ZYqMRIQAJNS9uBQks83bojkmwLrF/aC
hcKTHgviP85qy9yVOCnE79UT7RHV/9VQIcIX2nq/pZDnXGnSlX0KylPfd3gEd41f
iilJYJ45wQdlxjItGusvQJApvEfdksdcu3De6uGdUXpkS6aAMTku2ULVCxga332T
sIbn0SsHyKqpDrNPPrtddppI31KIYjW+lxvEeBlS3ticJ5S3SS6VFgPrh1F44NrV
ik6ZeF/wBj9vpV5CH703luCAxktL6freTwvwiIy3u6RAXmDN5i4h073sUHHgAPX4
IgOAeitHqdf/dEtt2J6s6EGejbVip+feYCHVZ/yh9Pbv2TdBJu/P6CMoV2z8ZLI8
wKKPnHO1jmPSJ7LedJ2WYsImyIvzGDDeXsP+dNgyg/udLsCBGCxWhltyGRLSiLW9
hzxmUzrUA5Sezfli5Y3d7Sm1u37gtyCgRAh1FnjPNUQbl10CIuhL/GMhSfOvgOaf
/5q8jXfHB9l/Y7spVXydxTC0Bjr/v/0Tw6gNmyik80zMUOM/luJ0wXA7izQlkY2D
peEKTRW5/149/upKkx1n0AbJcBBRpOjPLEtHP+CJi7NO892hWwNAfka8M4T9jUfL
ZvRLiAkGP6z1Gb1SSsrfGC+4QNtwV7UJqT5FDyPfTv6Iug7TLxv/iqoKaDwDPsAi
9FX6hfohOkf99rILgCsb
=mGgL
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
