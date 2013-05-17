Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3EQL4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:56:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49281 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab3EQL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:56:37 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 17 May 2013 04:56:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [GIT PULL] hwmon fixes for 3.10-rc2
Message-ID: <20130517115640.GA15916@roeck-us.net>
References: <20130515133311.GA14411@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20130515133311.GA14411@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I noticed that you did not pull this series of patches.

Did it get lost, is something wrong with it, or am I just impatient ?

Thanks,
Guenter

On Wed, May 15, 2013 at 06:33:11AM -0700, Guenter Roeck wrote:
> Hi Linus,
>=20
> Please pull hwmon fixes for Linux 3.10-rc2 from signed tag:
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.gi=
t hwmon-for-linus
>=20
> Thanks,
> Guenter
> ------
>=20
> The following changes since commit f722406faae2d073cc1d01063d1123c3542593=
9e:
>=20
>   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git =
tags/hwmon-for-linus
>=20
> for you to fetch changes up to ecacb0b17c08fae89f65468727f0e4b8e91da4e1:
>=20
>   hwmon: fix error return code in abituguru_probe() (2013-05-13 08:07:13 =
-0700)
>=20
> ----------------------------------------------------------------
> Error path fixes for abituguru and iio_hwmon drivers.
> Drop erroneously created attributes from nct6775 driver.
>=20
> ----------------------------------------------------------------
> Axel Lin (2):
>       hwmon: (iio_hwmon) Fix missing iio_channel_release_all call if devm=
_kzalloc fail
>       hwmon: (iio_hwmon) Fix null pointer dereference
>=20
> Guenter Roeck (1):
>       hwmon: (nct6775) Do not create non-existing attributes
>=20
> Wei Yongjun (1):
>       hwmon: fix error return code in abituguru_probe()
>=20
>  drivers/hwmon/abituguru.c |   16 ++++++++++------
>  drivers/hwmon/iio_hwmon.c |    8 +++++---
>  drivers/hwmon/nct6775.c   |    6 ++++--
>  3 files changed, 19 insertions(+), 11 deletions(-)



> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRlhr3AAoJEMsfJm/On5mBNQsQAJxSvmxZNaB7Hx0Cseiuhyzb
Si3CdChTgx+btywxw/yGikwnMp8gmTBkMPvQBBGfMbt13YCU/isjZ1TQ8TcA3vkG
giVaD9IcNxMFErrcPba+Z35IUfIiIN5GZurXSrAzxSeAO9vR9SIkpoFeJJr227AA
05O31ZwsSLZrTUoVo64j8bqSwwXkGpXxrsau5hFEj2s4HvEaO+ivoRMP1CXDLloJ
7qrmzX+7nUXrwxw6DrY7WFM5ldiaKepj2Mo/huEwl4+IymrcKZ4z7n2BvSKmmphd
5eeli1V2JkbgkLgbOf54nzPbDJgH1thtgaAh8ZGg7cT1oVNrFsgMi+Hh8LxmXMt9
4PT3sDhNjHkSCRZI/E8LQCFg3FSpCEqBKMFndI5E60mpFkSIemyhmne9mzDHIcFD
TnxjccsLCSQtLMNbQEdlMaf/7YSehpy0y29tN6NeXSPCoNMaQSFh+QrITEtCgRtH
lGsMbnjTXSF4B6bAAMY+XAa/7QcIp/EgZz8ieNThPY/quID65O6L3QPsLLZZVguY
xjDgoefBCsuwj3aTY+ivL5p5nBjjgmepWYDYnMDwbCEbH05Ta3gnpHHLbehxJ6Ng
Lp9tlKVz0xPdh6QtbDxEJWdVuay/Ogzjhbyh6Oig4WxJTwh2+tKJH5p83hTaRO9V
9/2N9OoEJ0SAV1rspBno
=J6Cb
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
