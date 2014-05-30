Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbaE3PoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:44:09 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53112 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaE3PoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:44:06 -0400
Date: Fri, 30 May 2014 08:44:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.15-rc7
Message-ID: <20140530154401.GA23857@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a couple of
driver/build fixups and also redone quirk for Synaptics touchpads on
Lenovo boxes (now using PNP IDs instead of DMI data to limit number of
quirks).

Changelog:
---------

Arnd Bergmann (2):
      Input: fix ps2/serio module dependency
      Input: atmel-wm97xx - only build for AVR32

Chao Xie (1):
      Input: pxa27x-keypad - fix generating scancode

Hans de Goede (4):
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: synaptics - T540p - unify with other LEN0034 models
      Input: synaptics - add a matches_pnp_id helper function
      Input: synaptics - change min/max quirk table to pnp-id matching

Liviu Dudau (1):
      Input: ambakmi - request a shared interrupt for AMBA KMI devices


Diffstat:
--------

 drivers/input/keyboard/Kconfig         |   2 +-
 drivers/input/keyboard/pxa27x_keypad.c |   7 +-
 drivers/input/mouse/Kconfig            |   2 +-
 drivers/input/mouse/synaptics.c        | 166 ++++++++++-------------------=
----
 drivers/input/serio/ambakmi.c          |   3 +-
 drivers/input/touchscreen/Kconfig      |   2 +-
 6 files changed, 61 insertions(+), 121 deletions(-)

--=20
Dmitry


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTiKdBAAoJEH70+W8r6ZYqPEEP/3i1vPSjrSF1YmyxnSwJkvmg
/A+mj5G3hNzBGIdkqkegBQFILQiwSGkxAg48yoiTYQCYc258nRp6v0PBJdnWq1Vx
aa59+c07CV0wd9HRjapQ1HQ17+fC9lSi2apPV8NPZYnCVDdfa3o6iVIqV2AWnOld
6EDxiVsuCa2Dfbg2KRsKclcQQA17C0lRRPq7c+ZrksXJ/Ir7iigkMkI9PttE85vi
8eSjXhy2OrzhIr6vNEtflFiy5+SnD4cUrjpLFtTasXBxHlTlF8y4P80XgcNCYidC
DtCKBo1mEXcfyPT7WBIHIpJDOcqmAyZItc2iRvvRolfvTVgeUB0VJ15QQEZWDT0/
WaK1Wu5++TvngzpE3oCs4LSJNWFtgUlfbKhebqrgFpO3VIA0SNugWOXjIT/7G4sx
k07y51UnXM/xkKlHOFu1UTdv4xDxMTC26ibIh+2uDUwM10XhVGysH7WIINitnlW4
dIVEksvMcYy/LJDYA/MzYyz/FYiM4f6mEQpHLW+mTWNvWIjm41NHWsdFzmOH4ryJ
L+LOFKN19mM2OWtkcKzBaLBrUEnjbJG2xeS7E7Se3zP/vSX5xR/KnY9oonUvEMvG
5qg59j4dcshp90RGA4PCq10naLcy/D+DUL6uM0LA8GSM/A2lDam7ppuecaFMXmtP
Xu9rVN6nS1v3CwksMnBK
=2/5/
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
