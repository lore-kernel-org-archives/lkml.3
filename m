Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3LLQEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:04:07 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63275 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3LLQED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:04:03 -0500
Date: Thu, 12 Dec 2013 08:04:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.13-rc4
Message-ID: <20131212160400.GA12319@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull hwmon fixes for Linux 3.13-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git =
hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git ta=
gs/hwmon-for-linus

for you to fetch changes up to efabcc2123f0ed47870033b8d6fc73b50d76d635:

  hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK (20=
13-12-11 13:37:30 -0800)

----------------------------------------------------------------
hwmon fixes for 3.13-rc4

Fix HIH-6130 driver to work with BeagleBone

----------------------------------------------------------------
Jos=E9 Miguel Gon=E7alves (1):
      hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK

 drivers/hwmon/hih6130.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSqd5wAAoJEMsfJm/On5mB7isP/jz8Rik5zW36z0eDBB0UO7cB
F0YAcRzJQFoLQ/Z8lKfpOMWDMWVbM735B9qsAj0dKwXRLVK+f9sPCKb7UdAFpM7s
H7cpzmLYR23+t2BhkWctoFuXKQva2vf0nk1o8XBenQw3vBfhA0niRBqvuj0ZI1Mm
VzFaAkvR0K385Zs67Z9sxAGQvFiEiKwPc9AtEaSUkX6JHoPPMHrkrAciYR+Ej90h
7F7vvlzytZcNO/j+6R2rlAyb4S1eVWodRrvj0OQ08jDBLjEoMhMwROLbLGg/WXL7
UPIUcqE2sPRTu6H2f6GEXIIb6fiYTAV8pq+FtNvA0gUOmkPZVvzNBbpa7V9pGsy8
LW1rvVLinRIeMHgOh0qzBE49AJ3u+SLwErQxRSe8tEidq0v2wkgfWwN9c3bLWhlY
Q8h7wUARQWNNnJ+ulYOkYUQalBkqezsRYN/UrAZ+kl2FsnGd8ZCwJ7hYG/DxI2Ue
4ksARaA0Z0nxLvMDeF/1cW7pK7jBvToPEuO/5WL6FOIBxnCq6DNGewHDzidIo7eP
BMKa54TuXdCbQo/wLEiv00asW3b3vFd5XkWJ750TkRuSU7HuhqYj/HOMfmSiGKjg
xJ347G2hVNxjZP5p/aC1UIrz2qwjrDAAlxgDUPH/iAzqyR70VxAvm+AcNibpTQMV
CTsIqrs56xX9CfnIiH54
=CX1V
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
