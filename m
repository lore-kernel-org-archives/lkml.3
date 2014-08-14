Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaHNFDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:03:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48985 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaHNFDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:03:09 -0400
Date: Wed, 13 Aug 2014 22:03:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [GIT PULL] hwmon updates for 3.17 (part 2)
Message-ID: <20140814050304.GA17299@roeck-us.net>
References: <20140811174957.GA24677@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20140811174957.GA24677@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 10:49:57AM -0700, Guenter Roeck wrote:
> Hi Linus,
>=20
> Please pull hwmon updates for Linux 3.17 from signed tag:
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.gi=
t hwmon-for-linus
>=20
Hi Linus,

did this get lost, am I impatient, or is there a problem with it ?

Thanks,
Guenter

> Thanks,
> Guenter
> ------
>=20
> The following changes since commit f4d33337eac4007793ca11fd1ab68d91ce7aa7=
62:
>=20
>   Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kern=
el/git/mchehab/linux-media (2014-08-05 16:36:30 -0700)
>=20
> are available in the git repository at:
>=20
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git =
tags/hwmon-for-linus
>=20
> for you to fetch changes up to 6ddd855c13bcd324a2d9756134e6b57c659cfde6:
>=20
>   hwmon: (tmp103) Remove duplicate test for I2C_FUNC_SMBUS_BYTE_DATA func=
tionality (2014-08-10 07:51:42 -0700)
>=20
> ----------------------------------------------------------------
> Several bug fixes in various drivers, plus a minor cleanup
> in the tmp103 driver.
>=20
> ----------------------------------------------------------------
> Axel Lin (14):
>       hwmon: (lm92) Prevent overflow problem when writing large limits
>       hwmon: (ads1015) Fix out-of-bounds array access
>       hwmon: (dme1737) Prevent overflow problem when writing large limits
>       hwmon: (hih6130) Fix missing hih6130->write_length setting
>       hwmon: (adm1025) Fix vrm write operation
>       hwmon: (adm1026) Fix vrm write operation
>       hwmon: (asb100) Fix vrm write operation
>       hwmon: (lm87) Fix vrm write operation
>       hwmon: (pc87360) Fix vrm write operation
>       hwmon: (vt1211) Fix vrm write operation
>       hwmon: (w83627hf) Fix vrm write operation
>       hwmon: (w83791d) Fix vrm write operation
>       hwmon: (w83793) Fix vrm write operation
>       hwmon: (tmp103) Remove duplicate test for I2C_FUNC_SMBUS_BYTE_DATA =
functionality
>=20
> Guenter Roeck (1):
>       hwmon: (emc6w201) Fix temperature limit range
>=20
>  drivers/hwmon/adm1025.c  |  3 +++
>  drivers/hwmon/adm1026.c  |  3 +++
>  drivers/hwmon/ads1015.c  |  2 ++
>  drivers/hwmon/asb100.c   |  4 ++++
>  drivers/hwmon/dme1737.c  | 33 ++++++++++++++++++---------------
>  drivers/hwmon/emc6w201.c |  4 ++--
>  drivers/hwmon/hih6130.c  |  3 +++
>  drivers/hwmon/lm87.c     |  4 ++++
>  drivers/hwmon/lm92.c     | 13 ++++++-------
>  drivers/hwmon/pc87360.c  |  3 +++
>  drivers/hwmon/tmp103.c   |  7 -------
>  drivers/hwmon/vt1211.c   |  3 +++
>  drivers/hwmon/w83627hf.c |  3 +++
>  drivers/hwmon/w83791d.c  |  3 +++
>  drivers/hwmon/w83793.c   |  3 +++
>  15 files changed, 60 insertions(+), 31 deletions(-)



--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT7EMIAAoJEMsfJm/On5mB/a0P/3Onq//2Lp7D+kjzhAZtNklh
2Nd89p8JY07cVmhltmVltRyBhla95SK3WiiSxJY4dV7mpFzHYF5sImavtWdIw9Rn
c9ee6JcdO/dO+zt8O9ywrfFyApTBelaIOmC1p8Uso9pcB1hJnLTgCzXMBGKX5fGH
3YA4qwbya+GOgWx0ZkmEnR+xJevXI5QX0kEu4PyuVN6tsc3CaCzWl0xwuHasrlOB
htU+sUAvoOjmrJeCYja/MBkKj4N6NQkNDyc1wgLFMURosxgHZVbO5QhniY+4V/mW
968GQbRRHOnnfJ9efRJKzEYZHxxddkpHt3T3YVZf6BC9O4NWsE0StRVrRELxGVo1
urILuu1j01TRIpLbqngVQ0l2J/v2Vg3s2q2x8vYe2UetOx/9/MxHXOIesMPnWblc
MDw3zx2+JiKv28mLhbgyDzM21e1zqJnkiMIfZ+57tIzOW/VRpzvmaLqJr0Lst/ye
wPGpGUQHkr5bmRBmcVnqOZkFCJoos1i/d0o6vm/iry6O33s01XY/48PbYOCaY/iL
Qe/NSK5rliBdJKkAv/D8+mF6ccCzsejc25W4yqqB68hNCNyGij0CShix7quoaQ4P
VXaDACU+Jt0W6XmLZscUz0vEMrJFaQN6t9iWYg3vfEDzYIjQ+EElPJidyhf+RE+s
trnw+/57SS05HovMc6aq
=ADu6
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
