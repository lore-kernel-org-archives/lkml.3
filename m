Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3EOFAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:00:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34360 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3EOFAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:00:14 -0400
Date: Wed, 15 May 2013 08:59:42 +0400
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20130515045942.GK24524@sirena.org.uk>
References: <1368544041.1350.111.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZQs1kEQY307C4ut"
Content-Disposition: inline
In-Reply-To: <1368544041.1350.111.camel@x61.thuisdomein>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: remove saarb and tavorevb3 machine drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZQs1kEQY307C4ut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 14, 2013 at 05:07:21PM +0200, Paul Bolle wrote:
> Support for PXA95x was removed in v3.8. This means that the Kconfig
> symbols MACH_SAARB and MACH_TAVOREVB3 are no longer available. This
> leaves the SoC Audio support for Marvell Saarb and Marvell Tavor EVB3
> unbuildable. Remove these drivers too.

Applied, thanks.

--YZQs1kEQY307C4ut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkxY7AAoJELSic+t+oim9i+cP/j6W0qy+mM6Km08JaKKNB/2m
z9pBkcjRcVJujr+jHJUBGkKF2IfZTKDcTAQ6+c7H3k8PYNBZbKBBz+Vrjgu7UJoe
6VhFzCgkff7R193HIPVTsfrYidnU2xjPkRUhZgrFpAt6vKiPXVLewqoVrsh//uhi
1bqzbw4Q04OP328r+jH27hQhp+6xteDYseJ9JxLkgLZDD69a4EE0ya0BtPmz/xz6
Gx+5mCPUczvebt+cioF/3j1I6dH/QtRy3aJajP7VPBVBTKna+kxdeh4iELBf85vo
TD05tEJJUKb9oAnMj5gqJl0K1yylWREofRjnIt6Mp3Cje6KXkfyZkSd0eI3bjQKF
pSxp86s8cLw2BMutikxG2imR71KIQqsfNDfO1USoFWadFYhJogepGGIg987qfDb1
dIMJo0terP8M5+eGqlcO3Snfzwy5/+oAsOLL+AfqLdm3nId4LYgV6TgVRLa67QcD
QqhOJgNH5NCaeeTFGHmMKQiIc8QiDCVh/SlHyPNr8Cb4OntDLwk0fp66rHbG2l+l
tRdn5+faAoQr+EvtC4KE4tjdFOtE+zaV8SBa7hzwJQjflZ4UQWxuFxEjm2jHgILj
qIyQl7b0pj+A/NTtCQPi/DAOgwAsh6Vt9gUSM+hwAqeaIikZQkdr2xnV+U1cF5J1
iCmvYgi6jYu/50ea5sD/
=mlVL
-----END PGP SIGNATURE-----

--YZQs1kEQY307C4ut--
