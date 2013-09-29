Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3I2MXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 08:23:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48069 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3I2MX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 08:23:26 -0400
Date: Sun, 29 Sep 2013 13:23:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20130929122306.GS19304@sirena.org.uk>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
 <1380444666-12019-8-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kjwfQs4m3ZHLWJuw"
Content-Disposition: inline
In-Reply-To: <1380444666-12019-8-git-send-email-lars@metafoo.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/8] ASoC: imx-wm8962: Don't use i2c_client->driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kjwfQs4m3ZHLWJuw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 29, 2013 at 10:51:05AM +0200, Lars-Peter Clausen wrote:
> The 'driver' field of the i2c_client struct is redundant and is going to be
> removed. Check i2c_client->dev.driver instead to see if a driver is bound to the
> device.

Acked-by: Mark Brown <broonie@linaro.org>

--kjwfQs4m3ZHLWJuw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSBunAAoJELSic+t+oim9y34P/1yaB9IoWszQ9FUOORxR9cEz
VZnOE0uyMzkplrp4tNhWpKb6iplOP5HyHSSBxjvHRmXfaxmxMpxy+TYUVEE1CkP8
fil17lthI8NqQLrG5eWzteSbu16d8ulmb2VS+epR5/ExlPmsH3bzfV6P41kyYs8Q
nZXkaRm0RIN8GeaEtNM5O9BVAUOmHTGT/9ZiR+70qKpC3bN8gXaabPa92O6spauP
aIS9UT4539CkiwjGPzm4SkOwrjlHo5keLw5JN7cnroDNGEXRwNHto/pcnuel+/PB
0BvBSRw+ObwSytvjyANWto04B3JJxx+Ie07G9/lglcDspJQI1k1+KMcxfZXRIF/9
7fovtHBOGoIcgvmCc8ITPAhEhY9cYjYNp3YUUcn9UItTkfzYWmYIUt7wKyIOhRmy
hBvazKeWwU/K+SOnK63cznlr15KSEO7krIJMkNGmSG6Q19XKE0UMDXakQpR/0WRA
++q3RwQCcuBdtvHC4w+zhAAeqco0vAmqEiva3PWRuWzfDh5E2UNLr39VwF22jV3C
PS31QZBr/yWcooEMvKHWlmfvv2ZFCzG5XcmRq2Co0QINjdgTFjL+EtaJ6DHJkQCH
d7uQ0x2NAHdbSdHVq5qCHcVXWf7MgKwGoWkkjWd2Gh3xxsUvgjERLwILRyXcLZGe
zZ+FCSo8f9I48RBcDQCx
=ZBQD
-----END PGP SIGNATURE-----

--kjwfQs4m3ZHLWJuw--
