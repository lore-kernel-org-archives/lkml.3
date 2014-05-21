Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaEUNAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:00:52 -0400
Received: from sauhun.de ([89.238.76.85]:47908 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaEUNAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:00:50 -0400
Date: Wed, 21 May 2014 15:00:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        sjg@chromium.org, grundler@chromium.org, linux-kernel@vger.kernel.org,
        cpgs@samsung.com
Subject: Re: [PATCH] i2c: exynos5: Initialise Samsung High Speed I2C
 controller early
Message-ID: <20140521130043.GA2628@katana>
References: <1398350916-885-1-git-send-email-ch.naveen@samsung.com>
 <20140424162558.GB12304@sirena.org.uk>
 <CAHfPSqB5+mLiC07jbEpeUgW63pZVk700SkYGxToO7GRAsFm_nQ@mail.gmail.com>
 <20140509135153.GM12304@sirena.org.uk>
 <CAHfPSqDSTyQXPT-NCZ2hE01qpdmaR54tbWCUYC_zSDGFp58+7g@mail.gmail.com>
 <20140509145425.GP12304@sirena.org.uk>
 <20140521102515.GJ2708@katana>
 <CAHfPSqCOnW4YGPfMfpBMbLSaiSxRN=CHJK6kYdkXMujKvNwAPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <CAHfPSqCOnW4YGPfMfpBMbLSaiSxRN=CHJK6kYdkXMujKvNwAPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Kindly, suggest a workable approach for all the subsystems.

Keep this patch out-of-tree? I know that probe ordering causes problems,
and that it needs major efforts. Yet, I understood that adding more and
more subsys_initcall to mainline is not going to help the process unless
essential. Using subsys_initcall has issues, too.


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfKN7AAoJEBQN5MwUoCm2hNcP/A+xeI3nO4vZCWuEdMXs2+qa
KxPBorEF0k0xzIcFFkwRWjJEcm1nq/gkQbe0XJlmdi5uSkWN0FyGKtggY+6jNxCR
JCpwk50eGKfVtR/0B0KLuzrlkDckqwY13tZG8ySTAuYzcRA8TO6oVMjS8Hdy5Tmo
fYTNFWiMOVpGa3Nws71oWiEfqSVNXJDN3JOg6kHEiTjZvR1I3UExxxojOyV6PDqe
uuFFcdXNqNPrwr/9IlzSJKqwOaJp165WQtaSNdjvVK9JNa9xiMwaL6/5lbkAYyVY
jeAIS/IuLTQwNPQ0bGSzPxjx/RAKvyEfu+GdloaPBjH9I3lhLHd7Wajd8CQlr8aZ
KDt4hiAQKpyawX2+wElQi6FCwxD3ZatMAGfXDakj4VbzjCIzhuy84wGYjfK01fJU
m1RHNiqueKTLRdwMuQsck2FtSiXnJWwROb4uy/bo09K79n71/45H9ZMRNz4+mGS/
6Bj7K4Z5zaM1lVusfmBqbz45vglL472qONZBZGAEMsUGq7hSlgkklfDdMJAIrDAp
KodVfiNR/S2iuvqXo/68wISDTtX2BLZGPqvqcsuPUfS2vdsvQwYWvLMBDTSxy8my
IpaW4OlL0p0YIgCRyM4xbRioH/aMDJQElrouL8AEqpHpbHeJTIx14Vc7Ug/t2dMA
jfk+Ywssv7mOYleBgj7U
=30LS
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
