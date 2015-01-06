Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbbAFPOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:14:35 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55237 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbbAFPOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:14:33 -0500
Date: Tue, 6 Jan 2015 16:14:28 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: swarren@wwwdotorg.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        wni@nvidia.com, Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v5 3/3] ARM: tegra: Add thermal reset (thermtrip) support
 to PMC
Message-ID: <20150106151427.GQ31830@ulmo.nvidia.com>
References: <1420541578-27968-1-git-send-email-mikko.perttunen@kapsi.fi>
 <1420541578-27968-4-git-send-email-mikko.perttunen@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O7Os1+MGCLLi8F5z"
Content-Disposition: inline
In-Reply-To: <1420541578-27968-4-git-send-email-mikko.perttunen@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O7Os1+MGCLLi8F5z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 12:52:58PM +0200, Mikko Perttunen wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
>=20
> This adds a device tree controlled option to enable PMC-based
> thermal reset in overheating situations. Thermtrip is supported on
> Tegra30, Tegra114 and Tegra124. The thermal reset only works when
> the thermal sensors are calibrated, so a soctherm driver is also
> required.
>=20
> The thermtrip event is triggered by the soctherm block, and all
> soctherm sensors default to showing a temperature of zero Celsius
> before they are initialized. Because of this, it is safe to initialize
> thermtrip and soctherm in any order.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  drivers/soc/tegra/pmc.c | 107 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 107 insertions(+)

This looks good to me. I'm not sure if I asked before, but can this be
tested? Can we somehow trick thermtrip into reporting a temperature that
would trigger this?

Thierry

--O7Os1+MGCLLi8F5z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq/vTAAoJEN0jrNd/PrOhCekP/ityls7/zPFaKyJNcB4SYdgS
VSutT7c7lFgRiXSoZD6er5+lOXTwyrcZ/qf5a6imko7ytFJ1y6/re80esOkmvauJ
qnNG3RQL2bQiztbtt382/EmPbxvXntRxohKrhChwi8hwGrA4Zy1S+2QVzQkSEBiy
TCnbwOOA0D2eqK9U6zwWucZsrN9mOBjmASJK7ebql7IhSOBrVkQnLe8dj5EmD04F
Y8QbZdy9huZ0EbuWfR579GGEN9M7+qcd8QTv43fb4b59sYxlW3C69twhF2t9PWVC
naParFUHUfYBFhCrsJxCKGVGG9op03pMm7qVjuKYS7QzuKmPk2yuNA5uoHc8hpXm
/nf+wgvue3XedodThOF9hwFaTXzRwhJu3BvPoufn8zrKzq+P2a35L42FNPi5yUb9
Jd/W+WM4S86nhAQxhC8sxy+Q3lJ5l7OZgMZP49TMKsmJhsmDG8VpqGskSU1Y58vT
wR9VoVh43GIKQ2/U8cXRZgeJWNqQchjFpNCyjq93h6S8xOnDl3O73EpcD4nCSGiY
XTzAyVDeZ7fnz/MM4I0KHOb0u3Cf5xupK6NF+fZHPHtHf3Dld3QlGa+T0eQVjgC3
U/793BsY/4OsV0Z0Uw98FX2M6KoCURaJdWRqfjasc0H0FK5WOnwcQWJFv7keQuS3
9PUZjdYm0zzEjHFkUt60
=ZXZ3
-----END PGP SIGNATURE-----

--O7Os1+MGCLLi8F5z--
