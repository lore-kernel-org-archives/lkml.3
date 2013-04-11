Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab3DKRTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:19:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45277 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934775Ab3DKRTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:19:44 -0400
Date: Thu, 11 Apr 2013 18:19:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 18/30] ASoC: samsung: move plat/ headers to local
 directory
Message-ID: <20130411171938.GS9243@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-19-git-send-email-arnd@arndb.de>
 <20130411164751.GK9243@opensource.wolfsonmicro.com>
 <201304111908.42532.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mCdhXfk5CmamXiy1"
Content-Disposition: inline
In-Reply-To: <201304111908.42532.arnd@arndb.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mCdhXfk5CmamXiy1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 07:08:42PM +0200, Arnd Bergmann wrote:
> On Thursday 11 April 2013, Mark Brown wrote:

> > This doesn't apply to my topic/samsung branch, can you please regenerate
> > it against that or let me know what to apply it against?

> This one should work. Unfortunately I now found during testing that the
> s3c24xx sound support has a few build errors at the moment, but this
> patch should not add any new ones:

Applied (after hand editing the commit message), thanks.

> make[5]: *** [sound/soc/samsung/i2s.o] Error 1
> /git/arm-soc/sound/soc/samsung/neo1973_wm8753.c:25:24: fatal error: mach/gta02.h: No such file or directory
>  #include <mach/gta02.h>

Hrm, someone killed GTA02 support?  That's sad...  if that's really the
case we could kill the machine driver but not tonight as I'm running
late...

--mCdhXfk5CmamXiy1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZvCKAAoJELSic+t+oim9X90QAIzA2iY67PTVoYsbI1wpdzqS
X3BABnsRX8jCeW4ddU6M798CiUzVfLqAmk1shpE4U4IJJ5bLlG2qCNECfdsCloDm
dH5iVP6+b/6i3srwLrYByeGkS9YHlHVjQYwmDS1mR7m9lRKN8+5iNfBhEG1yagNO
NIxPOuh0QxtmDbum7ZUN6ZzgSwQtLuk0AKicCFFEOISg3rx/2S3bu+q5HPU52kDb
LgKQt4Q6PW/MviuIbtJ9qtNEs85GOVcV1fcrjkq6MBr56fGB7c8wIqh24/YAeR30
5sVrviyutZOH8eP2+MFjiam/6Yi/otL7clho3yn6mvJvHzDd5qfNriT9QPSr5f38
t+TQkeQKclfIQZjhk1U7Xdb5L9DM4COrbayZYhig1kKnsj9Cl/Bg0fEjXwvNMV9r
w0XTeWQjXYbYEB79ei5RK6c6sFJZxI9v48+1rIj4/Dzqr37/rPYFMjem5sYPBKCH
6zaFcGLR91LQlnk7i7XS/mdx17SFv0dTGZzDYEU9WYWe76WESoZqKtIPy7H3ew1t
TwHqjx5iPFWeWKz2k4jSQjzFEOcqiPqB6uuXRAr2oqYNAZsQH+r/BuwECobWGk+I
LD0l+KpWaHz57MLxsZPREeyNIlMjBMrc8OWhtbsnbeYA+Umlwu3HHVGe1mcJyNdO
q/ELFztXkACZ5GaTXQv+
=Hc1C
-----END PGP SIGNATURE-----

--mCdhXfk5CmamXiy1--
