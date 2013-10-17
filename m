Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3JQOUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:20:42 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:59309 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3JQOUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:20:39 -0400
Date: Thu, 17 Oct 2013 16:18:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-pwm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] pwm: add ep93xx PWM support
Message-ID: <20131017141818.GB32734@ulmo.nvidia.com>
References: <201310151840.03569.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <201310151840.03569.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 06:40:03PM -0700, H Hartley Sweeten wrote:
> Remove the non-standard EP93xx PWM driver in drivers/misc and add
> a new driver for the PWM controllers on the EP93xx platform based
> on the PWM framework.
>=20
> These PWM controllers each support 1 PWM channel with programmable
> duty cycle, frequency, and polarity inversion.
>=20
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> v2: address issues pointed out by Thierry Reding.
>=20
>  drivers/misc/Kconfig      |  13 ---
>  drivers/misc/Makefile     |   1 -
>  drivers/misc/ep93xx_pwm.c | 286 ----------------------------------------=
------
>  drivers/pwm/Kconfig       |   9 ++
>  drivers/pwm/Makefile      |   1 +
>  drivers/pwm/pwm-ep93xx.c  | 230 +++++++++++++++++++++++++++++++++++++
>  6 files changed, 240 insertions(+), 300 deletions(-)
>  delete mode 100644 drivers/misc/ep93xx_pwm.c
>  create mode 100644 drivers/pwm/pwm-ep93xx.c

Applied, thanks.

Thierry

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSX/GqAAoJEN0jrNd/PrOhW7IP/19LXMHr3SgX4AOj3drqrCP3
BknfpnkYGwEGxwZIVd0UPvpAYm7cqplEzNqptBSEAfk38XAN9MMYCD1fagC4eMwz
3ZGChB9nYSZg0eYeTpztCnZKsP26lb0ExrrQ9l9OWucU4MY1K65gHPuQyf0GzEYR
7HHPd14RRq2xMjqgLRewx6/xNsfmApjJGNwhTjUvLwq4QMma82TAPFsl4giRUOuc
+omN/pQ/CeIsyC84JpJ+NT8Nl+yu/jG8XPhYGIGrFwXe5bgIuxm6tvOujUDY3i9A
pT5oXZ9GGGH5Bl2ZMdnZBXD8epwMKG63HKzrK8ARCVTIfNJWkRlghGzwlLnm8nAD
fRxHcAgrFxdfVmWDVO+p/NYc9LCWgEvNsfbigBbM8kol2KVXvTEVP7Us1HGZnUND
JkahTSdOc2xf66X3GA1lj+45suvUWFjQs+r1/RKzT0n4bPRoOZeFL20HVYOASxxx
IK7GXLersCwOJUep4ej7nQYM0UXIQb1yrq/T2CiojNUh39tYyT8WORxRTNXw7ilj
ZS8T2jhOnA5IMJDDLC88OWS6at5riT6/oAvTMkeFVJv+2kbz/gdypFwXDfV+f5Y1
I6XKtmaDwh1KL2E9jZUviO+xuOD8b1lWaK8KASgq6xDUh7wDpCRNBRCflQMX7snG
gNlPakZZBvmkqRYtY9Tp
=r3sz
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
