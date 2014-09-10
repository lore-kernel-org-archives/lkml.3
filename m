Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaIJVIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:08:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63664 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaIJVIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:08:52 -0400
Date: Wed, 10 Sep 2014 14:08:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.17-rc4
Message-ID: <20140910210848.GB24104@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[ Not sure how I managed to send previous request as a reply, resending
  signed just in case... ]

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get an update to
Synaptics PS/2 driver to handle "ForcePads" (currently found in HP
EliteBook 1040 laptops), a change for Elan PS/2 driver to detect newer
touchpads, bunch of devices get annotated as Trackpoint and/or Pointer
to help userspace classify and handle them, plus assorted driver fixes.

Changelog:
---------

Dmitry Torokhov (1):
      Input: synaptics - add support for ForcePads

Hans de Goede (3):
      Input: elantech - fix detection of touchpad on ASUS s301l
      Input: add INPUT_PROP_POINTING_STICK property
      Input: add missing POINTER / DIRECT properties to a bunch of drivers

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl

Klaus Goger (1):
      Input: cap1106 - fix register definition

Lothar Wa=DFmann (1):
      Input: matrix_keypad - use request_any_context_irq()

Masanari Iida (1):
      Input: wm971x - fix typo in module parameter description

Nick Dyer (1):
      Input: atmel_mxt_ts - downgrade warning about empty interrupts

Stephen Warren (1):
      Input: atmel_mxt_ts - fix double free of input device


Diffstat:
--------

 drivers/input/keyboard/cap1106.c         |  4 +-
 drivers/input/keyboard/matrix_keypad.c   |  9 +++--
 drivers/input/mouse/alps.c               |  4 ++
 drivers/input/mouse/elantech.c           | 11 ++++++
 drivers/input/mouse/psmouse-base.c       |  2 +
 drivers/input/mouse/synaptics.c          | 68 ++++++++++++++++++++++++----=
----
 drivers/input/mouse/synaptics.h          | 11 ++++++
 drivers/input/mouse/synaptics_usb.c      |  6 +++
 drivers/input/mouse/trackpoint.c         |  3 ++
 drivers/input/serio/serport.c            | 45 +++++++++++++++++----
 drivers/input/touchscreen/atmel_mxt_ts.c | 25 +++++++++---
 drivers/input/touchscreen/wm9712.c       |  2 +-
 drivers/input/touchscreen/wm9713.c       |  2 +-
 include/uapi/linux/input.h               |  1 +
 14 files changed, 156 insertions(+), 37 deletions(-)

--=20
Dmitry

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEL3gAAoJEH70+W8r6ZYq05MP+wQ9b61UsEUWdgMxBaWpJlDa
UJcvtPyCWDtOEwR2acioS6upI4ZQU94vsB4LlzLtOE+8h4QuUWAy4rRLrrxy2E8M
78OFA8KoCCb8e+ZJ6pFqdaieErC2YeaGWImgv/H7VFxKOKmu2K+Ko0e8R3vcmjeP
O/Z3SM7QaBRye1Fga7ZDzqA8abqQrjC8TJU5GBuufy1l2vWom+Qx5zLW2CIzLajs
S0aNcUE3tLziVijuiKBr7PgHEqwhd+kBsf1YCHK95M5lrp0hJzcX31Alud3hn4UV
QtaQFPj+KnOEAaJ25m01PISHKiXPlTZKPbmRJVYfja4kKBUWihG78BcIFzFnYaWc
TXbpb02pYLYk+2QeiLc7x5Af2lwxy0hl9wAnYwI7vBsDx7luPOQP9F5MYbjMeMam
gpbbc5VMFB1CzxrylB6NPBtFHdvBADiJMDvO33VJKuuo9xxAjwXY7wzVAQDSLI3D
/t20xyRtHtL0KXYQ7W4sL7prOFAlx/G6T4fuicc8bsP9TL9ZtCcmSm6+nen8H0gV
oTZXpxEkyXA70oskgkBORFsSRio4ZAGp3tHz7ta9BrMF2qXmP7lBtUa3aY0sBNSI
ej5gZmUoENIw1mfLgFltdVWwV0hTHp9CRdeRHCWnA9sKHbR8khi9YaunlW0tA5sk
28rKgPM6qblrsJGMyWiX
=Xgcr
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
