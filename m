Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaBMTDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:03:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42890 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBMTDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:03:08 -0500
Date: Thu, 13 Feb 2014 19:03:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Simon <horms@verge.net.au>, Magnus <magnus.damm@gmail.com>,
        Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <20140213190300.GZ28112@sirena.org.uk>
References: <87iosjd6lj.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vD4R8EutdGn5UgVK"
Content-Disposition: inline
In-Reply-To: <87iosjd6lj.wl%kuninori.morimoto.gx@gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio: reborn necessary prop
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vD4R8EutdGn5UgVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2014 at 07:39:07PM -0800, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>=20
> 934624d6e9f0b3d41557c4105c286e8daeaadb4e
> (regulator: gpio-regulator: do not open-code counting and access of dt ar=
ray elements)
> removed struct property *prop from of_get_gpio_regulator_config()
> but, it is still used on
> 0094050d783bbadffe83effef11a0bda901153ce
> (regulator: gpio: add gpios-status for DT)

Applied, thanks.

--vD4R8EutdGn5UgVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/RbhAAoJELSic+t+oim9NNIP/jpdLtn9p988zshkrOVcniFm
LbPgxrk1cYssNvR++qIf+fz+93vcjZqQ4SDBgjkjgCIJmBcY6wqys4vkiGxR9YJX
loam9V2ZqUqhxy9NC+xn8EidJLAJHcRH4QiVc0H+X7fIh1Q9UiD3CRUCMJCCVIKL
va16klszc8PIDwmMm+zoXj/dC2QX8Vuj9nh2Et/p+Xu+sD3awA3m2LcxB0wh3Ce+
0cYRwOo11Ht4qL9xReYVwd2/Ref0xwfidLBd8eborRw7xc+WR2X/XMoBcaVnIH6D
1QgvR+YsW06HOAVnQiC3GSNCzfnlUEVr00u+BrdU31O58hTws9+hdslRU4SXB9uq
S/XAA1PUX9ektk2Lhw6TrCa+lOUsMUQeSzN+AT/UfdS1qIKSWQqRMN9qrr5JWSlb
/NA0cP1aB38wNrGWXTTkygaoT1O7y/NXgvBZXjULw5dB/R4oVhPLD0igWDCX1so5
4/JX3g2CQsHU/eW++itZok6g3YfY5AOsgTPTj53Bv8emaqNi4lpTGVGEQ/Nv2B9o
1UqmQ3ZFFQy4jVYe7pWyojP1RrENDNR4hJFSFe+0cqX3qQQn3+XDJN/+RpT6BcJ5
m0iylqJq6/orYP9qxKi2V2QJDWntmpcW0x7uwIwzVCYpQpO7v/YrsO4+xyR+YSJA
eKTGeiFKErVL6rmYq7nC
=lA6k
-----END PGP SIGNATURE-----

--vD4R8EutdGn5UgVK--
