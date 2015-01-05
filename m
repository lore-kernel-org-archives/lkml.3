Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbbAEVTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:19:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36829 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbAEVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:19:50 -0500
Date: Mon, 5 Jan 2015 21:19:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150105211929.GR2634@sirena.org.uk>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LbN0412894TjpI52"
Content-Disposition: inline
In-Reply-To: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/8] ASoC: alc5632: Constify struct regmap_config and
 snd_soc_codec_driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LbN0412894TjpI52
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 10:18:21AM +0100, Krzysztof Kozlowski wrote:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make struct
> snd_soc_codec_driver const as well (snd_soc_register_codec() accepts
> pointer to const).

Applied all, thanks.

--LbN0412894TjpI52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqv/gAAoJECTWi3JdVIfQ/wQH/ipMaA4LO3UY2ry33LHLfDDz
C4fMay6ONKj9ONkmB1dXyR070aicAN1+0UvVYXEKbsdO7NJ2yAEOpVzKAA3dJoZk
/NHEEZcBCXtPHLi4WEIIznHwLdEQZWHYq9SsIerCG4zg7SriVayW/29ji4YKO7fb
JC008Zci+sbZ7+twqSLsQ2LgMyTpsO5ZLJ1WlbIvQzVHdnO/RoA4jk0l3I658xCk
WNNKAVIqYcx/4APYpNqTd8bnGEDzXoh1EqzJfr0Kt+VTWOd9/PEFvvZtTo2vcpVI
oYidP3tVLDnRCI8IcQLUZQYJ64y4PSCUYKzRfzOOJiM7Ez94Tw/qLIhCiQ6kwXk=
=vL0R
-----END PGP SIGNATURE-----

--LbN0412894TjpI52--
