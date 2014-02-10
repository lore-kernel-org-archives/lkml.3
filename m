Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaBJMvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:51:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39955 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaBJMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:50:57 -0500
Date: Mon, 10 Feb 2014 12:31:24 +0000
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140210123124.GW1757@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-2-git-send-email-Li.Xiubo@freescale.com>
 <20140123183829.GB11727@sirena.org.uk>
 <88ad355def5f440eb92ca921b17aabb9@DM2PR03MB509.namprd03.prod.outlook.com>
 <20140126124313.GF11727@sirena.org.uk>
 <d774da5b38ff47b6a350d92d1ffb362a@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wt10+cXOThorkX0z"
Content-Disposition: inline
In-Reply-To: <d774da5b38ff47b6a350d92d1ffb362a@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/8] ASoC: fsl: Add VF610 soc audio card Kconfig
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wt10+cXOThorkX0z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 04:12:19AM +0000, Li.Xiubo@freescale.com wrote:

> > My patch was "ASoC: codecs: Make OF supported CODECs visible in
> > Kconfig".  I can't remember offhand what the patch for i.MX was called.

> Yes, found it.

> If so, shouldn't the CPU DAIs(such as I2S) also be invisible in Kconfig like
> CODECs ?

Yes, they should be getting made visible too when they can work with
simple-card - that was what the i.MX patch was doing.

--Wt10+cXOThorkX0z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+MaZAAoJELSic+t+oim9PPsP/1TOvo9IJ7Wu9LgaYNPxXMU4
cZbc9YcQoPRgMBhIwofGhDVZs74xi5tiQhQ0ib2GZp+xE3JB2DN+XSn7PJ7cWDSL
B0E8rqoAkWAxUohLMrX9asRrk7naHWc1vYQOmKCgxYW7srZEXLuhnWlRdBlIDWPX
aRkzcPGMUjtD91eF13tfRxKnoHvDQfrLlY5O6VGjqVBTOdxKKNPe65P7DL0407jj
w9guocX+vM7V6GpUSRztG913crpKKml88Q/KE/rNRBOmQ9w5ER+J3FHcsipkJD4B
HmnxdLINqoEbY9eXIlLjts9lBgADzidqhvZz/3HxkqfLK7oy+noaOFVbB6BvTpaG
mxR3h4a230Ku4JIuCl3z+R3FbciHdtLn/cRNj/1XWfhimKuTvANZG/ISrQC/DUQy
D7uQEPZfZ3Pvq4m6CyYTq8Jrfa447N2n1StBK3RF+duaJ3O2j3+r6BqzCGXZFJSw
DjCkc/5UhD5jPD3sDuXqlIpI/rODMIOOTRykxv9HT78oimNmG06pFrNf9EZQL3CO
TbHiwpi2ZvwQxySAJ7e12ymGu5nlFbGn/urTKAD81denZQLbQdAH2dVFgWMAuW98
BKze+Yt5+cvb7o4GBwrEgVunHknKHLdtYJO/l083+CyQ50NQRLYTVrDIQ3z3HQ/R
NyV61TA7i2qH0ZBLVUC4
=GV1w
-----END PGP SIGNATURE-----

--Wt10+cXOThorkX0z--
