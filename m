Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaLVLqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:46:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43740 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaLVLqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:46:36 -0500
Date: Mon, 22 Dec 2014 11:46:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20141222114616.GD17800@sirena.org.uk>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-25-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WChQLJJJfbwij+9x"
Content-Disposition: inline
In-Reply-To: <1419196495-9626-25-git-send-email-wsa@the-dreams.de>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 24/28] ASoC: intel: sst: drop owner assignment from
 platform_drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WChQLJJJfbwij+9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 10:14:45PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.

Applied, thanks.

--WChQLJJJfbwij+9x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmASHAAoJECTWi3JdVIfQgA4H/0dwQoP2nZcP5uyxPZFwUN+V
EJ3afFfJ7wi/m03A+zFafcJDHPrQwHy1uBR+8cd7INSdJF8rz9xX89Pe/+rPiM2f
vJyockqQH4a+3eQsFKcO6muHFDGcWQBu4ukYJ2udxt4U40lKcvMqpPecBMluJr8Q
FLl74lsVgDwWOOdnX+EYRHLtSJhdrpGLOLusBcdIybwlAQX/VEixamXY/hXjj8ew
WXHW24mh0927U3fNejO1nXFP8MmzHStNLr9yzggWSKF7ZuRUouJlzQUYy4FlKEz1
yAeWcxJPIRgQvwukvf09YJ79jw94WgMIuf8s/+WY1tmQwrhrQ5Ejn5ZgId9zxas=
=Flip
-----END PGP SIGNATURE-----

--WChQLJJJfbwij+9x--
