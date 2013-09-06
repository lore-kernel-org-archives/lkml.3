Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab3IFLVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:21:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42371 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3IFLU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:20:59 -0400
Date: Fri, 6 Sep 2013 12:20:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20130906112028.GE29403@sirena.org.uk>
References: <6ED8E3B22081A4459DAC7699F3695FB732FD0B57@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Content-Disposition: inline
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB732FD0B57@SW-EX-MBX02.diasemi.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: DA9063 driver development
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 06, 2013 at 10:47:58AM +0000, Steve Twiss wrote:

> Is it possible to remove this driver from linux-next so these issues=20
> can be resolved by Dialog?

No, sorry.  The regulator tree has already been merged into Linus' tree
for v3.12 so can't be changed now.

In any case the best approach to a situation like this is to make
incremental improvements to the code in mainline rather than just throw
out the existing code and start over.  This ensures that no work done on
the mainline version during or after merge gets lost.  The best way to
avoid this happening is to submit drivers as soon as you can, and of
course to make sure that any code sent to mainline is reviewed.

--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSKbp5AAoJELSic+t+oim9dDgP/jnM7HuGLH5y7kHAWeUGeDNI
Tglu6+y5F9SYTOfvsnH1Q2DnEC02TGfZc48hJZfFVhURJqyKS1W1/X4yW+L5VW39
k6dW9uLiAMNVjZEc28SffkPjyNGxOy/ev9w2wylXPfVNN0i2n028e50UtO5n33na
V2jUdTRtqFtILts0+P6RH73guyokxNu3Nsi/SAOow3dWnW1LBuxu0w7ZsyrjId7X
ykBdyQPTPS/6RbAp5tGpWRF3/78z6JXkPiJ92zntbPDQBb+6Mtf2RJy/sPK/4qZQ
b31TzA7KxQerl3qfM5ej7p8NzL4kxDK5WgKbxWOFL3q4j+/7+IropUv3UbH0PsWi
CVbn8V4U6/sx9owFezJFBItlgUGPtTXlJprm4a/wDdvO6Bbkwu1Ca2xrun5pA/Fh
xUzykszWArLw0fQyXhiLAQCzUwqXW1ZMDKwZEIOcd5EVYDQx2OHCZdduBAUaML/D
5vEW5O27V39fK/FfEvgdvvKW+JY4yVDcFTbFn4jcSgtvzf0hp34YtgE9VyeDZAxx
K6be8SushIoSiICvRANCzjkQBsUnFZ2ZNOzFznThSpdTtm0MCLuToXIlhMotlisW
R6RdWngmG/Phh+1FKdWLmbPpYWimSdxK1fEwVipHWKzI+vL8IQ5+TQyB/uYq8XTB
gq7VsADcrnO33oDZGrcD
=hzIg
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--
