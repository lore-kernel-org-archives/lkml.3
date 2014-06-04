Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaFDMmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:42:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53148 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFDMmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:42:50 -0400
Date: Wed, 4 Jun 2014 13:42:24 +0100
From: Mark Brown <broonie@kernel.org>
To: ShaRab Shaik <sharab.shaik@gmail.com>
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140604124224.GK2520@sirena.org.uk>
References: <CAHWZSxgM17azkvwxOAcR3skaUXRcaoxbiHxE3bMNrfg2dNTRkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8tUgZ4IE8L4vmMyh"
Content-Disposition: inline
In-Reply-To: <CAHWZSxgM17azkvwxOAcR3skaUXRcaoxbiHxE3bMNrfg2dNTRkw@mail.gmail.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] sound: tlv320aic32x4: Fixed Coding style issues
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8tUgZ4IE8L4vmMyh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 04:49:54PM +0530, ShaRab Shaik wrote:
> From 617d7a25f3c0c08e0b95b24de2d1ea0f3f4b98c7 Mon Sep 17 00:00:00 2001
> From: Shahina Shaik <sharab.shaik@gmail.com>
> Date: Wed, 4 Jun 2014 16:27:19 +0530
> Subject: [PATCH] sound: tlv320aic32x4: Fixed Coding style issues.
>=20
> Fixed brace coding style, lines morethan 80 characters issues.

Your patch appears to have been corrupted by your mailer, it's word
wrapped so can't be applied by the tools.  Please see
Documentation/SubmittingPatches and Documentation/email-clients.txt for
some suggestions on how to set this up.

> Replaced printk with pr_err as pr_err is prefered than printk.

In general dev_err() is going to be usable by CODEC drivers and is even
more strongly preferred than pr_err() since it provides more information
about the source of the error.

Please also avoid making multiple kinds of change in the same patch - it
is much easier to review things if the patch is simpler.

> -    if (aic32x4->power_cfg & AIC32X4_PWR_AVDD_DVDD_WEAK_DISABLE) {
> +    if (aic32x4->power_cfg & AIC32X4_PWR_AVDD_DVDD_WEAK_DISABLE)
>          snd_soc_write(codec, AIC32X4_PWRCFG, AIC32X4_AVDDWEAKDISABLE);
> -    }
> +

So for example the print changes should be a separate patch to these
brace  changes.  If you're removing the } you should also just delete
the line.

--8tUgZ4IE8L4vmMyh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjxQtAAoJELSic+t+oim9j0oP/A+LwCUlCM+0xLql94V50lJp
VWhDBrg6/2+RJwymXGOit2SW7kSoLrTwJaFd/T46/OWW7ewoALI+57RLVMcx70Px
dl62mk5SvFVX4o78WgXSAPO0U0zDc1+9hsQchT5b8u8BEowj9iY9MAn0fpfmI1et
fXaAAOa18YEmZ70EbTPMTro/PPBntNfYehVXkRJabbBpYr2rtWJZAYjwdj2IbR5v
AiLwW+IieijNU7/9X0iILU7aCEkoum5KoiI60v6DTEI4220WnEPHgw3kkLR+JdBG
goi5LQERfFunK6eMuqk3qBNdfpZ470JPv7hkE6radTVUFhoNAe5UHJsj99cOoMC/
p4nNIkKqok7jCI+U0KMEaxBPSJv8qRBImF75BVTQvyi7ltRcabsyjhQfYIgYr6f6
9vwT4dkXXCl1AC6AEuuvc+j1W8qnQNpSK3MLXQ68Kr3KdqdzWHOkAzCc+821YO+/
WMPSmD7B9UyHcH4C7ICM83g1vyGb8uDAnCI2jO+0KZR8zPLaD6bM05XJNpxKnZic
Qb6DvbsZbJeGvlfgwkdhTLNUijoT9F4izkv8r99gIy9EugMjtR0fEAOtZ2OgocO9
wVXsWvqhcywR9iScAPQxYpjsOPkgHZfGg+6GeHoadShAIlttap+wNbH1+++9ZDfW
YsqzYIB1O9P7ZFfzU2tT
=J5VW
-----END PGP SIGNATURE-----

--8tUgZ4IE8L4vmMyh--
