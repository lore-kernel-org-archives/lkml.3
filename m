Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaFBJvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:51:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50682 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaFBJve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:51:34 -0400
Date: Mon, 2 Jun 2014 10:51:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140602095112.GV5099@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpokk_sNQ7Be5F8NLa7pLrssPm9qPf-fDEUYkiurJ6Etrpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/fydkOSwztHu2te"
Content-Disposition: inline
In-Reply-To: <CAKohpokk_sNQ7Be5F8NLa7pLrssPm9qPf-fDEUYkiurJ6Etrpg@mail.gmail.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/fydkOSwztHu2te
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 12:50:59PM +0530, Viresh Kumar wrote:
> On 28 May 2014 23:08, Mark Brown <broonie@kernel.org> wrote:
> > Whatever - I don't think the particular code makes any practical
> > difference.  We would need to audit existing users who don't have a
> > REGULATOR dependency for breakage though.

> I tried auditing all 29 files which had this symbol: regulator_set_voltage
> and couldn't find anything which might break with the proposed change.

> Either these are making sure that we have a valid regulator or they have
> code inside #ifdef CONFIG_REGULATOR ..

When you say they check for a valid regulator how are they doing that?
The stub will come into play if there isn't a dependency on REGULATOR.

--E/fydkOSwztHu2te
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjEkNAAoJELSic+t+oim9yi8P/2OE21qPypEX7bRroMjlSRCv
o2eibMvSm2DhSrxqrx75x0wp4ykDGlZbc4NsKJXVFkU1zzJL2H4LDir13R7mhh+j
ghP04uLzdvTp53VzNut8Ig0TKDI2liN1vTv/RDlamQiWhd+uw/UPA0FrPraFebJq
F0fP9mJKAR9IidmlR8MrctRBkiNsAM7Kk9F3mx8pPiZKGvIRvyCnTUbxdCVL3c1o
RmihWFd5wVOX1i5oWYfHep9D60LxJMXc13TfjI9oIGfz1RYpI9jXq/9ggLifgrhf
jvo6nSqCBBQkwo60lusFWIKKrGLml3Pp3dspbYDRpCjvkRiHz9alGgWaAuJR2jKa
apPsNfyBFJHtc2HFOcxIwY68iI9nibt92jYFqDpvVOey9MmHwW1iAOUZPilH3bEO
0XreXDeob1UIMCfoUgIipWKdVK2/QzDDVVNiAcz2AQbN/oMHHI46dtF3FMCBkH+m
27IUDaeau34YJc/7tOuSBDgJBfhw5ZyPH/2TxTJpZWH/SVdI9wA82MbAarpTLrzA
iRaM8Tt+jO2QlB4T+ZSl8boeEoTzsXhyVNfvGasJBCbxnLmO8DRUB/Jny+K+dwEq
nX3GfgUiPzBSWbkIStGLnrhVueJd6kWnQpOrZupNGNLEcVemwtsT2JBaHAx+DDVE
ZdzdBDvXKCzFlr+iaBSg
=a4Mr
-----END PGP SIGNATURE-----

--E/fydkOSwztHu2te--
