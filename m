Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3KFJmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:42:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58608 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3KFJmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:42:40 -0500
Date: Wed, 6 Nov 2013 09:42:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Oskar Schirmer <oskar@scara.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20131106094214.GE11602@sirena.org.uk>
References: <1383653634-13691-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
In-Reply-To: <1383653634-13691-1-git-send-email-oskar@scara.com>
X-Cookie: Serving suggestion.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl: imx-pcm-fiq: remove bogus period delta
 calculation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 05, 2013 at 12:13:54PM +0000, Oskar Schirmer wrote:
> Originally snd_hrtimer_callback() used iprtd->period_time for
> some jiffies based estimation to determine the right moment

Applied, thanks.

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSeg7zAAoJELSic+t+oim9a7EP/iPo0l0U1rZTYPoQcGJA/N+w
cPXGQgkmtVpM+AhOoHVywgdljveq757GQTW//o8D9v/UykdlWpeUdZqnl+JwE/zk
GnGcN10na46VzneZHNhqIU/U/Tgkdr3MDbbpynA+EXmUDt+A5xQNWTFOp/ThpLa4
PAW6hRDVyVWXrPcE/ENFOVZklFTByMgJrvJH/vLlpiOD+i8+GUv5NOE4jg724/uS
6EGgPhZWXI85Yzw3NeHhDY/6mqd3t17/iaMU6Ml+C859pv50+YjyiKTkC1Vnjpk3
1yVUYWYY2GTDeuuHCUOGCKFfHORIdpwUpyvD8BB/G9e2Q8SuMgD3DmfxdVgSzL05
fB4y1Ah/VjomxCpVwNu2FNTuSiESEnhnLY5HwNSlQEF5JvkYsBz2odNepQS9g4Si
FpJCmkMbXComKr1J38cABueFMtSpZAYD8Cp0qBIjMOo9dZ1kGzejuupyicSu8eGL
YqHe94qgEzEHv8cjN9ZA/EOaFWfNnGfVezHVQtbeZkP/0Kk56z6oSnKat5j8fepJ
zxqs1NWfALqxpEeS8xTviwhnEPeqbhRLFwLOXRQQMQK5WUs0TyHsiNM9zPv3KoCW
BjKCBF6++nw4jGw/f8+T5hU/QZ0fOcZE1NcDFGW/Gc4Ali9PFRdC+/NzovUjvA7V
Af9KjZh4vTX509eBFWi3
=M2lH
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
