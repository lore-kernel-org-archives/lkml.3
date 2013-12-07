Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3LGJhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 04:37:20 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33145 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3LGJhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 04:37:16 -0500
Date: Sat, 7 Dec 2013 01:37:10 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.13-rc3
Message-ID: <20131207093710.GA9563@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get an update to
ALPS to support devices on Dell XT2 (hopefully working better this time
around and although it is largish it should not affect any other ALPS
devices) and a tiny update to Elantech driver to support newer devices
as well. Also a coupe of new input event codes have been defined.

Changelog:
---------

Andrew Liu (1):
      Input: keyboard - "keycode & KEY_MAX" changes some keycode values

Christian Engelmayer (1):
      Input: usbtouchscreen - separate report and transmit buffer size hand=
ling

Dmitry Torokhov (1):
      Input: sur40 - suppress false uninitialized variable warning

Matt Walker (1):
      Input: elantech - add support for newer (August 2013) devices

Pali Roh=E1r (1):
      Input: add key code for ambient light sensor button

Ping Cheng (1):
      Input: add SW_MUTE_DEVICE switch definition

Yunkang Tang (1):
      Input: ALPS - add support for DualPoint device on Dell XT2 model


Diffstat:
--------

 drivers/input/keyboard/adp5588-keys.c      |   3 +-
 drivers/input/keyboard/adp5589-keys.c      |   3 +-
 drivers/input/keyboard/bf54x-keys.c        |   3 +-
 drivers/input/misc/pcf8574_keypad.c        |   7 +-
 drivers/input/mouse/alps.c                 | 206 +++++++++++++++++++++++++=
+++-
 drivers/input/mouse/alps.h                 |   1 +
 drivers/input/mouse/elantech.c             |   1 +
 drivers/input/touchscreen/sur40.c          |   4 +-
 drivers/input/touchscreen/usbtouchscreen.c |  22 ++-
 include/uapi/linux/input.h                 |   3 +
 10 files changed, 239 insertions(+), 14 deletions(-)

--=20
Dmitry


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSouxGAAoJEH70+W8r6ZYqwQgP/iFBoLsTIoEOKcapKcmH6ekp
c1+XiuX1CXjWBQBTWOZSuMTsLqhe8pVGIzmsV9IQLXSmoxyehzbJ4Aa6cM3iDfWb
tHizHpJMdy/H27k6ys1OnnwSNe0ODFO38JMFLJ6e+wy91ifC9DrCKWhdzQ06wB3F
EHqCMsf7QF66sFvGMIOj3Le/bMp4QYjHCFLNAhLhNUHM+7TKddGfL8sbM/m+EIWu
DiHkxisTFe27a0/Z5WLYyzCVTMNtrYalBSEy3oLN9C7QX3D/ytOrdz5qHt7OIqvm
TyF3I6xd3js4Tuoj95TjY1GTR1KF+EBUak9izqftMMk55kFeME7spQai1owWiACE
YCU5/TvI8JxD0gq6hkadHzNxZrFeC7EoB9YdvggeNa8HmEk500817TD/0aWCf4m+
QzeJrkzMsgDLhGYZIbQ3kOYo71III8Vejcp4fIf26yRgFBWq/ZmunPg53fKLHoyU
68SE8buCSwsUsNglkWol3ekgtYy4gwE6I2wV/Fpbl2ySoZSOG/mxr+VGjhAzBaju
UBG+ynmyItCxmj7xy8IbCypSmd5IBNH3M3eWqL2ZdTxN+TbGcRh5EHMfvtU4p2Sx
hO9DWu0mewP2FBVp3jFTWGY9P2IlUKQr31Ussq98T9/bdlAugxo181KGRnyZvVEs
NiGtkqQMjMauJjkooAiX
=L/QC
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
