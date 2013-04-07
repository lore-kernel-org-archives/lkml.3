Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab3DGTWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 15:22:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33122 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932959Ab3DGTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 15:22:07 -0400
Date: Sun, 7 Apr 2013 20:21:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] regulator: mc13783: Add device tree probe support
Message-ID: <20130407192157.GQ6597@opensource.wolfsonmicro.com>
References: <1365354131-9770-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SlnaBQtdWG0gYnqZ"
Content-Disposition: inline
In-Reply-To: <1365354131-9770-1-git-send-email-shc_work@mail.ru>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SlnaBQtdWG0gYnqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 07, 2013 at 09:02:11PM +0400, Alexander Shiyan wrote:
> Patch adds device tree probe support for mc13783-regulator driver.

I'd expect to see a document describing the binding for any new binding.

> +	if (num_parsed !=3D num_regulators) {
> +		dev_warn(&pdev->dev,
> +		"parsed %d !=3D regulators %d - check your device tree!\n",
> +			num_parsed, num_regulators);
> =20
> -		init_data =3D &pdata->regulators[i];
> -		desc =3D &mc13783_regulators[init_data->id].desc;
> +		num_regulators =3D num_parsed;
> +		priv->num_regulators =3D num_regulators;

Why is this something we warn about?  Users should be able to omit
unused regulators, no point in adding nodes that don't have any real
information.

--SlnaBQtdWG0gYnqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRYcdOAAoJELSic+t+oim9XXMP/AmlN0zhSD0kpDDHDHbmCy18
U61xlu0Od2ZtOz7OFn0ZX/NXE2rU90WOxaLG9DPCdP7h3/YYrkclciIu0Kt3DlXH
4Wp2UKP3tCPHeziGnR5ggUs2m0EA4eLd57bv6hB6Dx6kGzAudzbovhhELbqG7ItZ
0vuubPfKE/FkT/e/EDFISPYQlvcMdYdPhjGTLAk1LiSlOwQNrgHY3SV1q3BQADO0
CV4IV/he6qIGt85xx1dR+3SEWgJygWnEQ/BZ4sPWGAkKVRhamZsSo8q00piDtfqS
sOcdtfbgMQTz7PkJZw1yhc5Wp/BNJdP3YrY7aZv2GGhm5Kgm2nkH3DhcOZkcvwtU
U+sphTyXDNNUr3Nf1OTco2mfxIbZmKRCuzBZzHSJpzHfMZLCdG9aboMDlDV+e6Oy
eVUjglObpKrDluqqEY4Gcr+pJjsPJs/iXxYK0YazBDsrlsxUPTIfGRaE98ToI6yp
ddwnGxa5ldVzrWGE2PCuuFXxjBcF4bRfXkEe8UWlRtLHZHqO5eecvt4B9C7vCyYu
NNHE8OWJwAVyy845r0EtiDS39AzonzCJf0wHz727tRAS5lLFpW/KnujFNOJ9JWBq
CBKXDtto45WZ+6J3yHVWiq11m4FsLJeR+YuQSqTqh++oLprvZ61B7WhBUgtPKDQ4
gVxKh4O3uyErH5jTa6Ir
=nYHE
-----END PGP SIGNATURE-----

--SlnaBQtdWG0gYnqZ--
