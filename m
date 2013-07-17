Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3GQKhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:37:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33277 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3GQKhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:37:11 -0400
Date: Wed, 17 Jul 2013 11:36:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kiran.padwal" <kiran.padwal@kpitcummins.com>
Message-ID: <20130717103651.GP22506@sirena.org.uk>
References: <1373024862.3233.63.camel@matrix>
 <20130705114456.GV27646@sirena.org.uk>
 <1373031306.3233.131.camel@matrix>
 <20130705133752.GX27646@sirena.org.uk>
 <1373270091.11222.12.camel@matrix>
 <20130708112613.GQ27646@sirena.org.uk>
 <1373542576.9286.101.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N709L9vpgywc1qLv"
Content-Disposition: inline
In-Reply-To: <1373542576.9286.101.camel@matrix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Update driver name to
 fix breakage due to pmic driver with same name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N709L9vpgywc1qLv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 11, 2013 at 05:06:16PM +0530, Ashish Chavan wrote:

> accommodate this level of change. Is it possible that in first go we
> just fix the breakage due to name collision so that both drivers remain
> usable. And in second iteration, we restructure both of them as you
> suggested?

To be honest I'm really not terribly happy about this - I don't have all
that much confidence that the second step will happen, the fact that
this has been broken for a considerable time isn't inspiring here.
However I guess...

--N709L9vpgywc1qLv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5nPAAAoJELSic+t+oim90+EP/1ARV4T5aPfB98kWihLAKs4s
OYVCuerUjkXFtmhps/tYsKggB3BL2XdIue8/a/6lYIFBHwziRy2rEXlXN8Xb0Isz
V9J+pzxt0kisFD58tkmdp3mXDeLxp4clBdXKg+YEquyxGmItoJyPSujXL0CjCnCh
1Dp1QulmEpxNUyBX5Zce8a7hp49XJNg75wSQ/rVnebg2wW01h6TfddfiZI+TZeus
azlS7o58wixSRWcBE6EDCDFtN9n6CsiWx/70AtBLc4Kj1CRufoa5sxjZkwbCqTHo
zbvl9tX/qCTm8N2PXzIB4VIR7ETVsTJogQUNptAUJvtD3ySH35YbLKSYJUHdSY4x
hboKhO388o6I/kCVtw2OVFONGkS3iJffECZkVBg/TabFrmb3QHaNtHCdDBlZx3ee
LZ+3ScF6Clb8UshBx1E6f9Piii7425QTer/7DLQSZfJvpabTKipGyYQgfF0Y0opX
V/mGlxP3p3J0o01hdPFocLMfi4nHMX3BmXLtKEBGlwY73U3j/GYaadinMn3CrqIV
Vi/odibXNDaYBxE5jsej/qSqqcrp0wB9q9cwtoe7oCW9onaVv34dsw5+ZPAqf8E0
pAugVEyjmLX4NMBQX067XWGNW2yW2QR0XJtQvSbXyBkDXEajApL6rsStm+jm22lq
cJUxvPVr7jKM6ERlFO4t
=wUT7
-----END PGP SIGNATURE-----

--N709L9vpgywc1qLv--
