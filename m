Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaLVMMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:12:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43806 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaLVMME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:12:04 -0500
Date: Mon, 22 Dec 2014 12:11:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lgirdwood@gmail.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-ID: <20141222121141.GH17800@sirena.org.uk>
References: <1418979886-31482-1-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KscVNZbUup0vZz0f"
Content-Disposition: inline
In-Reply-To: <1418979886-31482-1-git-send-email-beomho.seo@samsung.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max14577: Use regulator_nodes/of_match in the
 descriptor
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KscVNZbUup0vZz0f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2014 at 06:04:46PM +0900, Beomho Seo wrote:
> This patch is add regulator_nodes/ofmatch in the regulator descriptor
> for using information from DT instead of specific codes.
> That will be used regulation_of_get_init_data function for get regulator
> property on device tree. Using that make driver simpler.

Applied, thanks.

--KscVNZbUup0vZz0f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmAp8AAoJECTWi3JdVIfQiw4H/iSmIDFD0EeWlAFKydTqnbkH
zE3AIa9Qi3eaeci0u3Nw2P2/Tt4W533tNqDf53VQN4l0m1bFWbAegY9o3n5VJpiU
b2K9uYaciJ4b6bG3GrV4RaucfH2orLlANrpYr/9xLqaL78jcUvC40OsXFVLjHWkp
51JAEJI0SX3FP5dTYFpzqCnBKRc2PMX1f8mpHEe1DUwmh7f4Vg4oqWhn6kHJI0NK
ekxUB9jsJlm6i83bKZzPeJZhlorjLgXybQoydvwLBcKFjaLu2szL8jrCGUGZHzT5
7GpiDMpVJ9pZkf4kP9KvDoGGbWfsfnnnpacaKKDU/Ugrw7TDPTmX5OKQKl9VbVI=
=6LZA
-----END PGP SIGNATURE-----

--KscVNZbUup0vZz0f--
