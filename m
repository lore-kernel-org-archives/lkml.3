Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3HMRxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:53:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35851 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3HMRw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:52:58 -0400
Date: Tue, 13 Aug 2013 18:52:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Message-ID: <20130813175251.GC6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
 <1376243970-6489-13-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4eTFwF/zYFyPfRP5"
Content-Disposition: inline
In-Reply-To: <1376243970-6489-13-git-send-email-tomasz.figa@gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 12/18] ARM: s3c64xx: Add support for DMA using generic
 amba-pl08x driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4eTFwF/zYFyPfRP5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 11, 2013 at 07:59:24PM +0200, Tomasz Figa wrote:

> +#define pl330_filter pl08x_filter_id

So, this is pretty fun and probably not going to play too nicely for
multiplatform kernels...

--4eTFwF/zYFyPfRP5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCnJwAAoJELSic+t+oim9iX4P/0mKyY30y0RW4LOIunTc50nE
DILu3P9bUBK+XQICmpq5Oxlyxhvi71PI4AYzfAFz8GC2+i/Wvu4U373SuXG0Mjvc
PjNOgbpUfaOhIztONRaiiDjJ/fSixuMbyi+fKldMYN3q1oSMAgObfv5Q07WlKvkE
38FgUAUPjr6KMbhDFR/Q/Wg+PjuyJecjjg9F7t/0sOQPhPX5n2JSFQs7Tkh9+dQt
c/rmlEpk22Q1GfxNI8F6MVwF2K9kG2IEizJubJSfUVs5vV9k/JtzG1HgH5ft87tT
PUC2MI2LX1X9bODoD0o3KHShQQb47YkSqErFgwREYn6xP9zuvNGA6xqeTcACdnz9
wRREpYHDfpm15upc0SDwTumLeJs68cEBSCV+0qp+Bs0xdrYyXlCuosC9JpwvZKZg
MXlnRqJSHQzt6dQmnac2mIUUTbe8YTRN3dkin3Tn4E0uFoDydrYxQzXyxyk9hRb6
bAC1zzZ9wESgBEglz7AN5tWxIwx9xwRaVxU4CgDKurc52/mEV/uD3y9nYpbBCB9o
FC7OPA/1ZO8ODzeH0nNzTUtoEgH91JDOVi0KzlnVWsQWepW6fTWDAe2VdemNcW2k
3eEFqoCPR/6VWA+rE2szgWrdtHD59B6k/GrzyTfWV4qkNcW9DtoRpfYxuqY+eqqU
mnuNn2uldSSOHtIydZ/j
=Jom3
-----END PGP SIGNATURE-----

--4eTFwF/zYFyPfRP5--
