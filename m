Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab3GYSCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:02:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51311 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3GYSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:02:08 -0400
Date: Thu, 25 Jul 2013 19:01:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Message-ID: <20130725180145.GL9858@sirena.org.uk>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
 <1374683683-13370-3-git-send-email-p.zabel@pengutronix.de>
 <20130724172959.GR9858@sirena.org.uk>
 <1374773739.4382.18.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2N8/IdOpufTRkPb"
Content-Disposition: inline
In-Reply-To: <1374773739.4382.18.camel@pizza.hi.pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: Add Dialog DA9063 voltage regulators
 support.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2N8/IdOpufTRkPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 07:35:39PM +0200, Philipp Zabel wrote:
> Am Mittwoch, den 24.07.2013, 18:29 +0100 schrieb Mark Brown:

> > This looks like it should be generic (and there is actually a
> > regmap_field API for bitfields...).

> Indeed. I'm a bit unhappy about having to split all the masks into lsb and msb
> only to have regmap_field_init combine them back into a mask, though.
> Could we perhaps change struct reg_field to contain reg and mask, and then also use
> this for the regulator_desc vsel/apply/enable/bypass_reg/mask fields?

Well, the other option is to define regmap regulator helpers for
everything where there's overlap and just do that.  The helpers cover a
bunch of common things but there's going to be room for more.

--p2N8/IdOpufTRkPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8WgFAAoJELSic+t+oim9AQoP/0VfLrZdYehgaSiLh5L+Q1v8
ng3nnvlD5JeOIdLCIugTJxGS6ABtN5FDf+OyQ8OTmYwq82Ly07FtBdappOM4dPZ5
lqtWpweo9CAFTE3JMakcnq1pZCIQSVjDlOmv9modBq+OfWJCu2NZb/Y1xz/n4E7L
FwkJIVbSs4U/dpNKQLj+aFl4go49Gm/c20zJGgGMrvyg5jpuN7+MxgobD8g2aAyt
9LMssqIb+LTdJRurRh0xquPtwpqNzu6muHTdPwoE7xlh360MXn18vGBmqOgk3UKL
imO7TPFC5axnmsIVStOoR2L3fi3P5WiN0Gar6iVv341PQ17LU1Ku535qWPz1ArFw
0Bx/7PsFNvYYSvTfaeVA5a7N88mjoNSnLBG5kOxToCV1W9yr2h7ekeMlNbL2vj/e
3g74YrsqjOustQAbwhdlWUagFCHTHN+R/hwhGeNIkgOGQtpO4xl9DwMVwJnFrlR8
Tccm+7PEx/hWAkBwFL4DN9OShS7tQq5iL7FDLPHDYvMrEBowBy6rTOUB2N8CiX4/
XoZkzj9iiTcZ09cfPCoqETZdqG+zYUokzLak4299cM9mSBiuaaShyuCfD0XVMUYc
7V7b7dUEr/8V2r3cz9dMFlHDMVXwoHWPRAoasrhS1UqPp7bPSRxaBJBdnATY864K
RNznP9krxDGP3hPajzWL
=+eqX
-----END PGP SIGNATURE-----

--p2N8/IdOpufTRkPb--
