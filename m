Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab3L3MLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:11:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48244 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3L3MLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:11:42 -0500
Date: Mon, 30 Dec 2013 12:11:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, shawn.guo@linaro.org,
        kuninori.morimoto.gx@renesas.com, fabio.estevam@freescale.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131230121113.GQ31886@sirena.org.uk>
References: <1388114078-24517-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7kZSb73GAX5WIGXJ"
Content-Disposition: inline
In-Reply-To: <1388114078-24517-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: cleanup asoc_simple_card_parse_of()
 code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7kZSb73GAX5WIGXJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 27, 2013 at 11:14:38AM +0800, Xiubo Li wrote:
> Since there is only one common format via "simple-audio-card,format"
> for simple card driver(CPU & CODEC DAI), there is no need to do the
> INV mask.

I don't understand this change, how is the fact that the CPU and CODEC
DAI share a common format related to using the inversion?  The inversion
specifies the format relative to the spec rather than relative to the
other end of the link and for any DAI link the two devices should be
using the same format.

--7kZSb73GAX5WIGXJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWLeAAoJELSic+t+oim9WKIP/1XtQFsll2slTSVJhHOZlfGX
mXuVyqQHcrWbG76GLL0sMorItGaqW/SWHY37hFJv5HZ8t4yOq9dYrmJplypFuN8V
/ebUDhg1WpHCXudIaiGxA2BeikoykUZLn60s2+tNidqdRzzd/Mny6zjMWtS4yy6d
SlREyzTml00FeNboab7dlOaT7Vs3q1uikCLZCp/GExiAkzWDqhgJcROI+TlM59MB
dFI4A00WcaDhWSebE0zG1896NPKkqiFIJ/YUJVbdO4HATB+YY4sO/LPz2CTOfU0K
EI5VPRyCOC0XkoAZ94Teqd0yyIkBe2y99iGGHnhFUWMvSZO3ylcN/GP23MkLisAn
xauIxI+vjTQaIX87KDy/5LLywiBMaOabt/6+yqeTqF089r0FmCPz+ZUmXt2ADHgw
qPpusu9mIdKaFQzyjjPrn1KPa+C74H325/eSbD9PXB03NgyY8Bhizu5vM9VH8j0l
Lp8q2qMrzpLasnksx+mDQ38InX47YE8ojgh32bC4wsNQZn+2DtCiFtNZLkcxYU3b
7oy8DEb8La3jtPHJXO60Fe0XcHiTPJGRhi+jtSlbROoPJqIiWyQCKT7VfTSaIMDk
Q0E8enRblptjV5GVQq0cql1ofdAu84HiOGxtI8J/GcNqDa6C6sSTTdjihBn06WRk
MvuZMjD4wFvVLICNOVV1
=OZB0
-----END PGP SIGNATURE-----

--7kZSb73GAX5WIGXJ--
