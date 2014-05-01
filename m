Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaEASls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:41:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54201 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEASlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:41:45 -0400
Date: Thu, 1 May 2014 11:01:04 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140501180103.GN3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-9-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9HASspBA3mgrZm7c"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-9-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/15] ASoC: TTC DKB audio needs I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9HASspBA3mgrZm7c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:29PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The missing dependency can lead to build errors, so
> make it explicit in Kconfig.

Applied, thanks.

--9HASspBA3mgrZm7c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYovcAAoJELSic+t+oim9jZUP/3bR2DTB3CdhIjiLXPG+R+Qf
sYrNJvexhravQdDuStrvUsjiOAbtI+ZFvAPIcDo//OMp7oZV98hfODXpP5fh4R9U
K7ElMeqCQRGS6f1QkLGdwfVcfNaWrlkap3B6xP4PqlXhog+ZRso9ELrcw+M5Owj0
AdWFz4oHaWT2BaPc1A3I867KHdKk1acLAb0KQE1PM9BYKbaZoPPQCuRodj7SbYaP
ziT3Zn6Y+LCOVkfdHgws38Q9grWypeo7ynpP6w4Z4if9GhebAPwoksg2qzoyHqhW
W5JG2UxqedQPnKkUAOe382FZoRmlHuLF4ZOLTncSjWeoWasZ5ZXhR1zJ8P9g7Vfj
jNd/mvmdtbKGXDHv1+7kuGI3PBxtL4yuA2zz5//Jd6anr0ECd04D52uR90UWAO5z
6tAmclC3VWF23W25ez7TgJvyz3hn3rH23LHAZkAsO47A150uSuPX4GWogMe0ZgJw
g5xjtTcnlMGhDD8pdeImZNeZzHruD1xS+bKXYqN2ubSm3L6lHWVMdxEkysdjIHAs
8xvmyeGttRV0JqlksHYX/WhMQyWAmqoAdSLcZ3gUhNbc0zpYa6JJRqCTEwd+rGHR
ebNnpYBYVbfJepUuuR7u1s4WcBm9sm8heT6gxJBBEWWlE0kWkIhgpqVaB2cI0Lkx
zpBIGr3Crv+hI9qSmYZ3
=uFpI
-----END PGP SIGNATURE-----

--9HASspBA3mgrZm7c--
