Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab3I3QJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:09:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60629 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3I3QJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:09:07 -0400
Date: Mon, 30 Sep 2013 17:08:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130930160844.GD19304@sirena.org.uk>
References: <1380531434-15875-1-git-send-email-sachin.kamat@linaro.org>
 <20130930110125.GY19304@sirena.org.uk>
 <CAK9yfHzxDTp=_upSN0b+c-HtAPgVSOR9GODadJZTnKiMGXczow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xugVLPVe/nLWwmIL"
Content-Disposition: inline
In-Reply-To: <CAK9yfHzxDTp=_upSN0b+c-HtAPgVSOR9GODadJZTnKiMGXczow@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: ti-abb: Remove redundant of_match_ptr
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xugVLPVe/nLWwmIL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 30, 2013 at 05:22:19PM +0530, Sachin Kamat wrote:
> On 30 September 2013 16:31, Mark Brown <broonie@kernel.org> wrote:

> > Note that one of the things these macros are supposed to do (but don't
> > yet IIRC) is allow for dead code elimination to discard references to
> > things automatically even without the being ifdefed out.

> Yes that is correct. However, in this particular case all that
> of_match_ptr() does
> is make the pointer NULL if CONFIG_OF is disabled else assign it as
> is. Since CONFIG_OF
> is not used in these files, I thought it would be an appropriate cleanup.

Yes, it's not a completely silly idea but unlike something like removing
totally empty functions it's something that doesn't cost us anything and
which we might want in future.  Right now the drivers only run on OF
systems though.

--xugVLPVe/nLWwmIL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSaIIAAoJELSic+t+oim9euEQAJpwvugj1Xwma2sDfXQEvqR0
jmOjHtLqM/V0Yp/rTDsWHSLUGAL38XBJpA81GLKNe2/+LJVTg8OZcVt2DWIeQXxP
FMmOlbAZRrv0chbxS2qKtSBeI7CRJuPhjOmcuditaY8moFVk16aEyPDnWCNWWyvF
Z4iho91kggToKwwaJTTs8/27nAm4go1XyBki0jj2Ptvx3yGHVpjId56uegBBY6F6
KQd49ZOhmm1DGajdDoASGOyt+Vac3gWATfGOJQttvgeZMujnae7T+2ahPHjtUT3s
Mbh/YIp/WR4Jwk/mO3Ef5VmU1SG7v0CVA1Zu0QcY0Qr4UoWWFHyVrVOb/8pJiZJ5
kt0UUkPaOls6ClKwcEFQ7jSAIdfkcUwFTBvZMKgEl0uvB3Tm9IoC0x6PvHj7wjrT
bd+RFgtvyy3uZ8di7yyuALbP2uAsvK0Mh3tpGxFk+76LANW7PIaZy+3uSIe4siZi
e7qVYmlEXVdyzh7iiygGaFvjSm0ao9wwSom+ReILORa0msv5SNFaOK5G+F2/7i4O
A+h985FkCjn0/Dzc9rBKLi6mmwNEWvB+Ce9pgD4DjFOf0AsoE/Eaawqy5dDPLCgj
CUHB4K/Quxzrpe0plDYPy2qmngsH75vMnXZqLIsc7vlNVRHe2VxMUffTT/Q4lP/x
w0dReQLc7+H32U+iSsWW
=es8/
-----END PGP SIGNATURE-----

--xugVLPVe/nLWwmIL--
