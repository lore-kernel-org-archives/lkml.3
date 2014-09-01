Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaIAKeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:34:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44416 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaIAKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:34:35 -0400
Date: Mon, 1 Sep 2014 11:34:14 +0100
From: Mark Brown <broonie@kernel.org>
To: weiyj_lk@163.com
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sean Cross <xobs@kosagi.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140901103414.GP29327@sirena.org.uk>
References: <1409532470-32364-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oDT6ON1uLKeoILhE"
Content-Disposition: inline
In-Reply-To: <1409532470-32364-1-git-send-email-weiyj_lk@163.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: es8328: fix error return code in
 es8328_codec_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oDT6ON1uLKeoILhE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 01, 2014 at 08:47:50AM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.

Applied, thanks.

--oDT6ON1uLKeoILhE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBEujAAoJELSic+t+oim9kYcP/0mQVqeXw/T5VRTsXkXPFuQ7
6PIl1WOrx+90JdRi0CJIzsdNCTyNIsV3z8HGzFceOJGXuUe0Mj3zp3HPmDQERrlW
oldk1QFtMgStigp1TUtjWCLUt0igu1KDtp1609IQ0ObRJF+ri4AnGikteQP742rc
QH+uS/0nNUeiRy/H2xNy+sO3dBXOldSsVg7vrnLS9UJfv53FdbNoHZHkmYRk8or1
IaJAKHYc9t6nFFuf92QQQfM8nTlglDGoGzI8HlSU9NDuz+AI8Yru6eGnSkEHzUwg
DfiJwlzoALd9ulEfr8D5nAGH7uocSGm2AoSlSY7j6GTQvC89kv/5v0OYaM48lICU
csXbhG2uYl5jL8+XYDPUPGhWJn0LIJR41u/XHLveKvR1gjf3G0q3hubIHXSThfVr
RUvvFsnqQL1VRVBKFYOh+Bkc4tdfQt6NbSbKEmrBfW8v3dRqg12/aUwcFYtMXz9f
7JA9L+LzCqCYIlUzan5FlWdUCDBm+J5vYf5gK/B7NPrIXEMNHywc5Ss1YbtlIdfp
vWXlfIAIzvg9sHpWcGBGY+Lak3XEqMsUbRww9VI5aAxZAAO6+7ZsJjZwu6AyATxC
qPW9/se8CyRF+luu+A9NRMMh6nWLKH//LITq6mm1kyC4acGRwrD/aCPfLiQZKTvx
H/i3+ZqqnQh1lkJygLpz
=iQwH
-----END PGP SIGNATURE-----

--oDT6ON1uLKeoILhE--
