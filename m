Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaHOGMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:12:49 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35193 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaHOGMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:12:47 -0400
Date: Thu, 14 Aug 2014 23:12:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.17-rc0 (part 2)
Message-ID: <20140815061242.GA23913@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem. Mostly small
fixups to the code merged in the first round (atmel_mxt_ts, wacom) but
also a smallish patch to xbox driver to support Xbox One controllers and
a patch to better handle Synaptics profile sensors found in Cr-48
Chromebooks that should not affect any other devices.

Changelog:
---------

Dmitry Torokhov (5):
      Input: synaptics - properly initialize slots for semi-MT
      Input: cap1106 - allow changing key mapping from userspace
      Input: atmel_mxt_ts - simplify mxt_initialize a bit
      Input: atmel_mxt_ts - split config update a bit
      Input: atmel_mxt_ts - fix a few issues reported by Coverity

Geert Uytterhoeven (1):
      Input: wacom - fix compiler warning if !CONFIG_PM

Henrik Rydberg (2):
      Input: MT - make slot cleanup callable outside mt_sync_frame()
      Input: synaptics - use firmware data for Cr-48

Maks Naumov (1):
      Input: edt-ft5x06 - remove superfluous assignment

Mark Brown (1):
      Input: joystick - use get_cycles on ARMv8

Nick Dyer (1):
      Input: atmel_mxt_ts - mXT224 DMA quirk was fixed in firmware v2.0.AA

Ted Mielczarek (1):
      Input: xpad - add support for Xbox One controllers


Diffstat:
--------

 drivers/hid/wacom_sys.c                  |   2 +
 drivers/input/input-mt.c                 |  38 +++-
 drivers/input/joystick/analog.c          |   2 +-
 drivers/input/joystick/xpad.c            | 174 +++++++++++++--
 drivers/input/keyboard/cap1106.c         |   8 +-
 drivers/input/mouse/synaptics.c          |  72 +++++-
 drivers/input/touchscreen/atmel_mxt_ts.c | 366 +++++++++++++++++----------=
----
 drivers/input/touchscreen/edt-ft5x06.c   |   1 -
 include/linux/input/mt.h                 |   1 +
 9 files changed, 462 insertions(+), 202 deletions(-)

--=20
Dmitry


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT7aTaAAoJEH70+W8r6ZYqo6cP/iO58RX8EBi/8uxrrTMNoSZ3
2M3xzW7loj5hdQKNz4tyOXMBM63t7Ax7y74OlS+iTvHaAxe6KxXzmYacHMn+zDBd
+VCD/Jz3I3Q+OC7FPbK7V1Iw8N1N/bq/a3xGsY8eXguSuBryHP5A+3XmG9VamkTh
3xTnQBhLcPTb0986+ogKwsnmY9k+iUzGye5V/8kS6zTyvTlBfjVr2fofPD8KHtWC
DJhQhF1pJyZRjBUavaoZenCwC/gN8vTgpLb+oyOsY+/VqjTKh3oWCpUxC1nWB69d
Eng5XrQhBbtxY2ShqxFAO6l8vs8nhdHnW5qihdlTFKJkBOxQq8JycFqpjjamjpoT
qVdBY2OkgEbNRgfgXPum63uVZ0sZaMjyeSggEJDIhQFkhiq+lUpbSc4kVHdoV9Qo
gDbhfYL6UTilYlNhzLkElYi5t1vixL6dKr5JT5tYdT2b+YU4l+hOUarYemqxBET/
QtSMakO8F6c5C5BhHoFVbvadwW6iE4pmU6I9CaYMlIB50pUmL8BAk2wPo7MD73zp
4rv8B/2IUkmUSE7wnoZRRRw0MNysFwzHR0uBWHAHS29o8NYiD2vTI/YMHtd+F54e
CRMR/4SuYj931CHbAn4Y6xvBvdtvzsFDBAV9e4NRlJbbkw4/M561vkOJWGSLJPSC
jSK6PORfDUxxXXd1szh8
=894H
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
