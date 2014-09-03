Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936274AbaICXrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:47:42 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50287 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260AbaICXrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:47:37 -0400
Date: Wed, 3 Sep 2014 16:47:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.17-rc0 (part 2)
Message-ID: <20140903234734.GA2487@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a fix for MT
breakage, enhancement to Elantech PS/2 driver and a couple of assorted
fixes.

Changelog:
---------

Dmitry Torokhov (2):
      Input: fix used slots detection breakage
      Input: ALPS - suppress message about 'Unknown touchpad'

Nick Dyer (1):
      Input: atmel_mxt_ts - improve description of gpio-keymap property

Ulrik De Bie (2):
      Input: elantech - reset the device when elantech probe fails
      Input: elantech - add support for trackpoint found on some v3 models

Vincent Stehl=E9 (1):
      Input: sparc - i8042-sparcio.h: fix unused kbd_res warning


Diffstat:
--------

 .../devicetree/bindings/input/atmel,maxtouch.txt   |  11 ++
 drivers/input/input-mt.c                           |  30 +++--
 drivers/input/mouse/alps.c                         |   4 +-
 drivers/input/mouse/elantech.c                     | 137 +++++++++++++++++=
++--
 drivers/input/mouse/elantech.h                     |   3 +
 drivers/input/serio/i8042-sparcio.h                |   3 +-
 6 files changed, 164 insertions(+), 24 deletions(-)

--=20
Dmitry


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUB6iWAAoJEH70+W8r6ZYqRRsQAJsq1lhcYk4QCo93GT6JLmnN
30pqEeKqGohugGQeZ+MmK6Z1zC8w5Lss6JVxAOlr7pfvNMlmydcPJxQLlsn1tPqE
bmsAq7rqNlHW9hbr6HB07xdhjIX/OoUKC61ZcQbRwZi87DkT25Lmze9KJ7xg047Z
txNBTZbwsrel6I/tYWGpUEO3EdubLa8sMUTV4SCqfYBX3Ehr6FPr6GuQty2qB9wa
izFBkbS+dnunku51dYWjfRoQj6RE65cHvtfGrUo7GetrsmsC4nXuqTBvyYEpi0Yq
U8W0fJ7CjjnZ2voDk6rdkSJTJT8KCvEMNVMoyY5/ltkLmJas0/uzykGAb0fcKCZA
UY6Q1zIn+kaykip0qmanTzF5vkBPZkOgh+rXH3KP+ZnvCUqRBf44KvxbFsF7u1vl
LfK1ijlFOMFDQuGXvO9Z+TR5MN0hNIrgpKV6DbQGQKuLEqkYl0v08yaCxakodHJR
z4a5RHIKSURPOqh/HZBAt19dtfhVwgICnGRN7y+pNk2jIduSVCmzQbqhDGYRry4a
dKso6WESeKHx01wD7vJOJuGqZD2YGUvSiL1ukpMuIoHhmD3E2/hux9cMeLaZ/IlZ
uTCG6SvSK3LDCyQ5uPkHz/68rannnV8wVsBpXjGzLR2o2vACSs5jyoJueewxzf8E
ciaJ5bly7IGun5ugbusr
=bYfJ
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
