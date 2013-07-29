Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3G2Lni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:43:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57112 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3G2Lnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:43:37 -0400
Date: Mon, 29 Jul 2013 12:43:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130729114316.GW9858@sirena.org.uk>
References: <1375083538.7272.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Esb8Ef+zwUAsW5Eb"
Content-Disposition: inline
In-Reply-To: <1375083538.7272.4.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pfuze100: Use regulator_map_voltage_ascend
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Esb8Ef+zwUAsW5Eb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 03:38:58PM +0800, Axel Lin wrote:
> All table based voltage list have ascendant order.
> Use regulator_map_voltage_ascend for them.

Applied, thanks.

--Esb8Ef+zwUAsW5Eb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9lVRAAoJELSic+t+oim9/1MP/0tpS5BeOpKxTPhR2sKwX6+f
Z4QLnUDzg62UqjqGABVlcGIUvC+pjUxQTT8RMvyr4Cd5wqNT7NdoCdidbB9HUd9q
RffEXbkElUKU181uzq45gSNTVIWopweh4GdMaFuGa343bw4PW6JYHdxhQ+Mw46GB
hFP9CTFTE2dcFOzyEWulJ+2uFyRaG40oDkoeXitnrfi/myYRej1ROXVBY8sRatPd
6Q3W04OVYnABiJArXYgKfvAh9HDGYsl30lUPaVBL05/eUk81agjalEJzfSHL/sfT
ySjnqCwaUcYjfj/V38zodwLfqfYosod1oT9iHPmhe5eJtBq8YJud188qxzd9VvnX
9eceUypoLcbkvITU5m3KL9OX7qAHsAME0fjBkffb6lfn/BYyYZuw8mu2sfqSHHqN
UxmjdxUsidYtqIDXtl4e/Lv2O/XCenxxdZIm3I2UTT53wgGdbSPbm932xghLYw7q
DHaUv/11wl0ogczuNjPUr9bnmkrR/7J5rNxI1eWvNcdhtQiuszKactNeDFE/OHo3
iftMR/s9Ke+4b5hCQti+Kw3Fq/Xhici/TqIIBYiNngs74Qa6WrVR4rYe8JLQHaaA
II9a5Tcrfe4k7Y4dZLwIEJG1KjRsnTD0okYLX90BYRru3ivNVqHHAPQwcCSIaOO9
ntVNPcyxerq8+kNXmj31
=qxCf
-----END PGP SIGNATURE-----

--Esb8Ef+zwUAsW5Eb--
