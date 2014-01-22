Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaAVUGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:06:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58342 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbaAVUGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:06:32 -0500
Date: Wed, 22 Jan 2014 20:06:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140122200623.GC17314@sirena.org.uk>
References: <20140115113551.0eb13409@armhf>
 <20140115165200.5f4e6077@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MxTdzNviYdWQq2Ha"
Content-Disposition: inline
In-Reply-To: <20140115165200.5f4e6077@armhf>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 8/8] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MxTdzNviYdWQq2Ha
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 04:52:00PM +0100, Jean-Francois Moine wrote:
> Rename the pointer to the private data structure to 'priv' to avoid confusion with the platform data pointer.

Applied, thanks.

--MxTdzNviYdWQq2Ha
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4CS8AAoJELSic+t+oim9og0P/RV4jevGWYcw5YPyn0Mqhq5M
WDMmPGmMB+oh+jN/ySK+sAvQf45bPwA7m748CectspufT4iiDZVjkVgc43PWYe4D
9LrmHTOPQO46hs8PjtmAzLxGkPprn427NXpNqh5MaUoAvX6xwD2RKV8zzdyfsBQv
1izfCLiHGiejnmoZWKpAFgcOAO1660FPFpuL5o7083QzTUBNoDh/oAl1qJ6jI5sy
V6pse1mTlJrI+Be7lwgf3UWCcil6AisS/Qy6nK0oECtYQ0vPuQmXS/XolvIiIrsv
4YxsaHHAYGqlqD3uLXG/pNyn+pk1xtGqfKfqFtxlKyYtXNuaP1DiT09s1ioO3AR/
gbNwzONbO/HOj33nH7IveStEOyiCvKmsOdb7D+yz5ld5Hw9ZauIxvX2Ob3vV0chL
UzHv9BZ1+WHgG5BuxyRssAh54ClT2V2MGwARWvQtOZYMDyeAf48hxRpEagXRyJya
znMUR9u0GiCtWLAjM/9Fg1Itj1Dph0JDPUaDiaLX5JIDV83dUD6PbizdYTEiueZr
MRUCYXWrgIW76taYJA4mHWfouf5/iiNdXWvXesnutGr4oOa7YasOfKDPmt3lM1zf
s+J7U+7O8Xg0aOizCaeqDM/fqHuabHWtxwkhl9QeZtwguH39yHCrpbWlMvM4kmaN
brpUBKWU1VdGN5xsrkxf
=LO9g
-----END PGP SIGNATURE-----

--MxTdzNviYdWQq2Ha--
