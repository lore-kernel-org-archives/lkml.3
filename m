Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3LDJZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:25:33 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:64492 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3LDJZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:25:30 -0500
Date: Wed, 4 Dec 2013 10:24:30 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, dev@lynxeye.de, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mfd: tps6586x: add version detection
Message-ID: <20131204092429.GM19943@ulmo.nvidia.com>
References: <cover.1386100296.git.stefan@agner.ch>
 <77384d24810d9a22fc04cad6f7468f54a9cbaafe.1386100296.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MsEL38XAg4rx1uDx"
Content-Disposition: inline
In-Reply-To: <77384d24810d9a22fc04cad6f7468f54a9cbaafe.1386100296.git.stefan@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MsEL38XAg4rx1uDx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 08:57:27PM +0100, Stefan Agner wrote:
> Use the VERSIONCRC to determine the exact device version. According to
> the datasheet this register can be used as device identifier. The
> identification is needed since some tps6586x regulators use a different
> voltage table.
>=20
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> Since the struct tps6586x is inside the c file, I could not easily
> move the tps6586x_get_version function as inline to the header file.
>=20
> Changes since v2:
>   - Avoid moving devm_kzalloc
> ---
>  drivers/mfd/tps6586x.c       | 43 ++++++++++++++++++++++++++++++++++++++=
-----
>  include/linux/mfd/tps6586x.h |  7 +++++++
>  2 files changed, 45 insertions(+), 5 deletions(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--MsEL38XAg4rx1uDx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnvTNAAoJEN0jrNd/PrOh/oIP/0XcOss0nYe5k3ns1wrZbitV
YAD+hhJvhjwZMg7OirwXhbft5jCq5hsRw5E3pQU0pEf9edbgAUGei8fQlg9+mfwu
i1i9edYSsg5bufkaBc4Iz2yQgMTvJhrs3/B0Z+TDggY5TbYziJMBRz/ES5CD3eL8
qYaZtfueulqg38AcPLe72HoZ1A80SadZUeaTW8X1O1/8KK2uIgLqpq0HtDvR0wkL
ttUbkzb1iaukcN+t8/ZyQIDmZLYzJuPzTKl3bZv7+MGG6+QNOwj8tQ6T0A5lzCLY
9e+/tVccLcZKIlgE5KfTyIXv54xHnwvyd/Lu6Kt46U+GiYLE342nIlvS9o4B26SC
Kn+DNoccJG6Yad//tJA2Do4feytV4HAVdrnTf6B4q5cDTZ7V4ExMC7Un+p0x92Pb
uepuE7HSRyExtQnd/iKDz+tQXA4V35oXuxKHJ+Jkg095BZjROe12HXNkZWUPeipi
Vdl9YwOlkIDHiPBEe+EySqwC0DI5PDHU7ogOWVqUdxlysB+DcEvQMio+lI9MOi8W
RrJazbHlEq6He+Mip2X5Dy7PDP4xrCxFZ665SO2+WzEtT8J6F6+5sTm0a1SkEI1Q
93fBbesRv/sw8ChyD5h3v8Yb+Xvpl2pfGiJkdoL0yZLC+cJUQOFXZwA8+RWBXkmb
9N87gDN076MnvMpI5dXs
=GX7e
-----END PGP SIGNATURE-----

--MsEL38XAg4rx1uDx--
