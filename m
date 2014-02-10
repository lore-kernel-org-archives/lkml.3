Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaBJLm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:42:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39898 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaBJLmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:42:25 -0500
Date: Mon, 10 Feb 2014 11:41:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140210114154.GQ1757@sirena.org.uk>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-15-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qd/SZIFVu+MYwfCR"
Content-Disposition: inline
In-Reply-To: <1391971686-9517-15-git-send-email-richard@nod.at>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/28] Remove MACH_SMDKC210
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qd/SZIFVu+MYwfCR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 09, 2014 at 07:47:52PM +0100, Richard Weinberger wrote:

> The symbol is an orphan, get rid of it.

Please fix whatever script you're using to generate your mails, it's
generating corrupt headers.  Please also use subject lines consistent
with the rest of the subsystem - between the two I very nearly just
deleted this unread, it's only Paul's mail that made me look.

>  config SND_SOC_SAMSUNG_SMDK_WM9713
>  	tristate "SoC AC97 Audio support for SMDK with WM9713"
> -	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDKV210 || MACH_SMDKC110 || MACH_SMDKV310 || MACH_SMDKC210)
> +	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDKV210 || MACH_SMDKC110 || MACH_SMDKV310)

Like I said to Paul this isn't fixing the actual issue - think about why
the symbol was there in the first place and why it was removed.  There
is a problem here but this would make it less likely that it would be
properly fixed.

--qd/SZIFVu+MYwfCR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+Lr+AAoJELSic+t+oim9vxYP/1rHH0BvAyI3uM47spId+ACF
8nArourCnAlMvprRcqnJhIwUzOmgLof9gIV3wjFakcSNzE/80zKE5fhvUMfoEmAa
Wvq08oOSJyGn3QUBBKInK36CXyB7M7AJQvTwj+HuhntyTmeaYx1Bvdh39SZEaiOd
g7lkrHMvD/NuKOn4jx6LnQtx0Uik8Y3RkkVNvtErUOjqyPDOwPBgnICU8832b+nb
NU7p8TNUgwAYwE86j/GJK40IrnWHz1uYMkHHzhvDJJDqzy7ZPTdcoO88xiDDMWf5
FW5bLNyOrwmCOuCqwXoPqKd59kYzesi3lpUsaf/n+xLwBvasMH+L8BD9zdjQCY69
ac8IRC7yzVpF78ZKCCj+GjPPBCovhqPbCW28ELMMS59ynU+QiezqKga8RaoydqPt
JL0n6nGFTn4eLImJJfADryos6bWTYVea2o1CQYnzInmqBqclX+M323vAKldwEH41
zkRN+HmbnfCVpqJyc8FJhJ7KjQXV5cSLqCkGqC4xS/v91eWsIAMDopHITt0jif1W
DcSFd+2MQDaAr/g4vZAcCm25abC6mtfaoNxeR6hcyuL58JZADdDZhHowbZ1gzOvt
OhjjDn8/l8WpzKjEUCr0reaVo71546kzpareUx6fY6lhKlI/vD3fkwa6MsAXUwas
6zCaFAG+cpKZ+eBb5uZo
=Qh7R
-----END PGP SIGNATURE-----

--qd/SZIFVu+MYwfCR--
