Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3D3Sd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:33:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54346 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab3D3SdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:33:24 -0400
Date: Tue, 30 Apr 2013 19:33:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130430183301.GE26160@sirena.org.uk>
References: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
 <1367330994-7259-4-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HeFlAV5LIbMFYYuh"
Content-Disposition: inline
In-Reply-To: <1367330994-7259-4-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ASoC: ux500: register controls to card instead of
 codec
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2013 at 04:09:54PM +0200, Fabio Baltieri wrote:
> Update mop500_ab8500_machine_init to register mop500_ab8500_ctrls as
> card control instead of codec control, as it only contains
> SOC_DAPM_PIN_SWITCH definitions.

Applied, thanks.

--HeFlAV5LIbMFYYuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgA5ZAAoJELSic+t+oim9488P/R2T8qEjyfk4yEaJnu2Gp49r
NrmxsLCitnkLxtgz38NHk0sqPSicb/N2rh68MoLZzCIOVubY28vUgLZMUuE8z9xY
DgXc3m0BwCwm5NsLFsfGKExwY4vplB6uw2cx/26sW3p7u2GQ1nzIrGNNccANeatA
IZVpQEUGf9XEo1r/YWID+lx+XQ/RVQDz562Z+IalXx+3+uQhV9bpcpIZ8mLlLgzo
fpeCeAEjUz+KdeMFsdXM7xrq+O8WNS5cY9/r4FamBGgUT/8loaQoZZqF6+x03RCi
tfOLCu9aJmOMb0NS0i/m+qTP6Uh3JB9+uzi0796CG4KFMI+c1oobO9UxpzCDGijP
VCsDNHuGxNvZo4zJl+BcF90WLIXDzwpEENX7daKkLQdxt6N4T9P5/hz1adi+f5jZ
JQHYmZGrIX181N8DOfoMIY2bMU7ayx1IXu2Qq1wnQXjjmm9di8k00nmI4CNU6V8C
QTEL0HnHaBZ248RNAtjdXRHCV2mgS571EMMg6sSnhehesu6Zxor1dVVxTR5tgtU4
DZfCEWlr52j4RNQA3Qz3U/7JDkIJX8x5UDdohjJS3FBvkzIXByZckszHOBA7Ggsz
9y+CEuk3Q0C4xngg6PGZWirF023Ku+37UMoPRSur/BPGqWvPkq28MSy3rYeBkvtP
4uLEqFOU/dYTifz0t8am
=bE8J
-----END PGP SIGNATURE-----

--HeFlAV5LIbMFYYuh--
