Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaBLQFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:05:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40907 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaBLQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:05:01 -0500
Date: Wed, 12 Feb 2014 16:04:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140212160431.GB28112@sirena.org.uk>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-15-git-send-email-richard@nod.at>
 <20140210114154.GQ1757@sirena.org.uk>
 <1392039072.3585.15.camel@x220>
 <20140210141255.GI1757@sirena.org.uk>
 <1392046242.3585.41.camel@x220>
 <20140210163621.GA13533@sirena.org.uk>
 <1392070159.27939.34.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fowzm2eVyDiEwGH"
Content-Disposition: inline
In-Reply-To: <1392070159.27939.34.camel@x220>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/28] Remove MACH_SMDKC210
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fowzm2eVyDiEwGH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 11:09:19PM +0100, Paul Bolle wrote:

> See, if you scan v3.10:arch/arm/mach-exynos/mach-smdkv310.c you'll
> notice the string "smdk-audio". If you grep that string you get a few
> hits. But none in v3.10:sound/soc/samsung/smdk_wm9713.c. And if you scan
> v3.10:sound/soc/samsung/smdk_wm9713.c for strings you'll find stuff like
> "wm9713-hifi",  "wm9713-codec", and "soc-audio". But these don't show up
> in v3.10:arch/arm/mach-exynos/mach-smdkv310.c. So it's not obvious how
> these two files relate.

> And I'm left wondering why SND_SOC_SAMSUNG_SMDK_WM9713 actually depends
> on (among other symbols) MACH_SMDKV310 and MACH_SMDKC210 in v3.10.

The hardware is physically present on those boards but must be selected
with DIP switches, the device registration needs to be changed in the
kernel when that happens (as the DT must be when it is in use).

--2fowzm2eVyDiEwGH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+5uLAAoJELSic+t+oim9VugP/iZEteXqtzJ2i8/iw0CbFE2y
uvRWMNC3L+ewPETDiU+wtsq4MNUQsY25PK0u3FV2Wmqwt742P6AbX3jJ/zeV/knc
3pMhlRBPYP9/1scM2OBzw/4bkH4xPzgBJgXUQEyxeauj9cROSpg5pdGzWu5OSRyD
fMmj9tmLDkf30p9IP2s6xNorGhTDc+kXKlW6cU8+93bZyc9ZNG8kZjqRFIX03o36
SUm9seByWb7l0BQVoP56qAsu+j8yTKpNoqWP6QkYrjtiGHq5v9bX5+ZCoKS2Wlct
LmqK9x+cui4mfxxlz+d9zbHnQWc6FPIa3fZePqUp05r9BlN9EjqYD88touJiknbj
4rinWep1dTdqXoGm1rQ8T7PeqhHkyavzfsEVkc6M4g4hLYHP569m9fDtiLmwFGeV
rP0BguG5qVQ8uCWjPgOj5MMY7pp0/kaqrjGK+/81lyd3Gv/aSmIO/+4t+a4tf60s
Bqo6gDBY5eWZmNbNrMxhj4SZ0V6QOWI+kzMOdzqfzA+KFr8zwM+DJCWfSTOp+CWU
6n21C3EiSsLp/lHl2e86cUlVjfeBGjkzssoLqvjl/bc/TBZ5Xh/g4O1wrdwtSdgB
YB44X2Vc1Gz+wfZHxQ/rr3QSErHWJkIgXd0q2CsdcCFmOW9sTdhVkwsRPzikOKp+
49AGYVATCmQXu8nB0fB9
=kl1Y
-----END PGP SIGNATURE-----

--2fowzm2eVyDiEwGH--
