Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaKZTAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:00:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39681 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKZTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:00:43 -0500
Date: Wed, 26 Nov 2014 18:58:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141126185831.GQ7712@sirena.org.uk>
References: <1415627035-3088-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7HSfD5ZbgbsPGhz"
Content-Disposition: inline
In-Reply-To: <1415627035-3088-1-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 0/5] regulator: of: Add initial and suspend modes
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w7HSfD5ZbgbsPGhz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2014 at 02:43:50PM +0100, Javier Martinez Canillas wrote:
> Hello Mark,
>=20
> This is the sixth version of the series that adds regulator initial
> and suspend operating modes support. It relies on the existing work
> that added suspend states bindings. The opmodes are parsed by the
> regulator core and drivers should only define a translation function
> to map between hardware specific to standard modes.

Applied all, thanks.

--w7HSfD5ZbgbsPGhz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdiLWAAoJECTWi3JdVIfQXlYH/2cRfPoHO/MAkjfFjcppP70C
8E5LkrqGe5syIRFwNjWahzGOzrazSZKYiOxMoRnj/fkPbAsqMECckBUWNyL5AxUS
wBffisUV1WNeUZEfRcvMknd0hwJYv2qqF7yQmhOM/05bF2CjSx4bHHamsrs+lq44
X3o1VkjH3WNkOtpbKAAbzffDO5lsUP6EQ2XQ/SOf3UUwjPsCpI9Ma9YRBhvVDLFy
JeZLyqZXNUEHdqJ4EgWWbzIb+19fJ3bRkaEoGMVQjhnXYaaSI9TuNb41AKTBmfns
V3peGGR0SUW8mtE2vQJ1L5cIHo/36X4pnROy3JUxaQDl7CcaccQqawjIEtvBVXs=
=mDxR
-----END PGP SIGNATURE-----

--w7HSfD5ZbgbsPGhz--
