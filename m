Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400Ab3LIRvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:51:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54546 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab3LIRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:51:17 -0500
Date: Mon, 9 Dec 2013 17:51:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org, tiwai@suse.de,
        perex@perex.cz, linux-kernel@vger.kernel.org
Message-ID: <20131209175112.GK29268@sirena.org.uk>
References: <cover.1386344000.git.b42378@freescale.com>
 <68a5b5c0d53260f190b58daf3e3a0b492148ed62.1386344000.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/gejftf0Hzkayd1"
Content-Disposition: inline
In-Reply-To: <68a5b5c0d53260f190b58daf3e3a0b492148ed62.1386344000.git.b42378@freescale.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: fsl: imx-wm8962: Don't update bias_level in
 machine driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/gejftf0Hzkayd1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 11:38:28PM +0800, Nicolin Chen wrote:
> If we update it here, the set_bias_level() of Codec driver won't be normally
> called and we will then miss some essential procedures in set_bias_level() of
> the Codec driver. Thus drop it.

Applied, thanks.

--5/gejftf0Hzkayd1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpgMNAAoJELSic+t+oim9nTYP/0hp8fuWclZ3unisNCc6PHx9
bMMw/msN3R0IOUydseffGN8HGArKEE0CMh93+gPFWgyCAMAv1cxSJ9s0/mug2xeb
2UjSzidu9c4H2Ud/JsA04JER7pKYA8WqMI6zjIo/RYU0OrRJ8efo9XC/IuYBdxmq
5SsRPS0BUFmHFJI76jn5kO5U0qBFNhbi91HzcyD+OZI7m2lEHTZmGk3r71kd4stP
zvdguz6ifirIVL/jbqVqT6lUi8KudHTLCRBtjI/BT5PJwsUevxI2SaOyfxHqYYAq
4JGP9eZHvLxRxd2hyUQh/Bg25cbdDzxXRBX+tMM8df6VRMTsxN+gY5QgJ7yu+Ocv
d9iWBQZcw8/ksFddR0xetQwpu3P0JFs9IO1iNjveoSBjPNAHB19uXpWHWdAeHpgZ
IYW9aPUoEOBVrpZSz6zLnS0cHOyEhfOlS+i2stmKJOVus0DJiWwydPsjY5ZdLhfW
fIMDxzFCxpKp7KIGX+lmFW/DfMpOHyIBcWH5eu0z41cXwDs8bVh2F0SakzdaO4SP
YQJUURjggCKYGQJ81hBb9cAZp/DQq6CrdOw68UscSavL7QUYNkno5ICbRC+jdNg9
ae3sJnfBatKxI0MUEqmRYeXYFArSUKLx7vlm2VkDJ9Wz/ExLmkA7KYZYEffQbBAp
jta7iDvlBXcIXghDqE7p
=1H3h
-----END PGP SIGNATURE-----

--5/gejftf0Hzkayd1--
