Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab3EHKee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:34:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60149 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3EHKed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:34:33 -0400
Date: Wed, 8 May 2013 11:34:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508103401.GX7478@sirena.org.uk>
References: <20130508080448.GG3102@gmail.com>
 <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b/3kIrr+SWblMf9a"
Content-Disposition: inline
In-Reply-To: <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b/3kIrr+SWblMf9a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 10:39:14AM +0200, Fabio Baltieri wrote:
> As enable_msp gets called only after some audio data has been received,
> if the userspace closes the device before sending any data it causes
> ux500_msp_i2s_close to clear device state even if it was not previously
> initialized.

Ugh, please don't do stuff like this - you're posting an individual
revision of a patch buried in the middle of a thread.  This just makes
things hard to follow and error prone.  Repost the patch series or wait
until what can be applied is applied then repost.

--b/3kIrr+SWblMf9a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRiioWAAoJELSic+t+oim9fkoP/0xYvB8xWrJTr9Wnopic7yX4
DvARISDa6cKnn6qKnNegFqr0apH8/MiwlAXHPgZmD3Of3UDoipb9b/66bsh8wDJQ
eMI1sqiC9i+8iaT4k1uEJuuYab1584MNfqzrFofSLIs/i3B+T/ghhQdUbaQYaZa8
2ghDAmjT18GV1s4MXAqCk9Jy1AyGnw5sCoeqRR6ZZEiDQDQ66p+S2zyk+ebI4EvI
dMY8T89b1AJKFSJws+0whkGO0Is64aOF2tgOxM8iGXBvVlca0fOGWdM70cY/BFE7
7a349XwtWZ4CdDf3TSlHI3+iWQ5qf8PBkO9XnOZvxt4jJNrAaZLd3OBVmjuOG4E9
8iWXbP2g5yGdWn2onS1NAwX2MttsA84ZeGtoA5xiIsHtFlNMzwExC0KGda8z9V1N
UnN2H8L4rJ8wCTEbT3p6RM3BIxW0Ft4AnWbOIWpA1v/F85nsbZ9w2+kUz5KQzC2s
OwT6q0MxpMI08e1Xfq4OTAsQ3/FMT4zWMq5MVpurOcDcSSPA36XEi2GNeviOE3e1
qwxekcegJFt/GkExopADjdKo9p53NqvNUVWfsiuAZN5Uc6mcYOEaBtX1gSVJ0+gY
iQC5F3GQ4zZDccm3VpiTTXHSm4VCiH1ps7dpwowOCkIHfCCVNXtxAtEm0xGQmOdL
VeQ6zeEizImF8gnjYP+V
=xVuL
-----END PGP SIGNATURE-----

--b/3kIrr+SWblMf9a--
