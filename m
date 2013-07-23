Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab3GWNb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:31:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43830 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab3GWNbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:31:24 -0400
Date: Tue, 23 Jul 2013 14:31:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <20130723133119.GG9858@sirena.org.uk>
References: <20130723102320.56bc4555@armhf>
 <20130723084347.GP24642@n2100.arm.linux.org.uk>
 <20130723130622.GB9858@sirena.org.uk>
 <20130723132104.GT24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vZRzFRtr9HMcP32e"
Content-Disposition: inline
In-Reply-To: <20130723132104.GT24642@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: kirkwood: enable S/PDIF
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vZRzFRtr9HMcP32e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 02:21:04PM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 23, 2013 at 02:06:22PM +0100, Mark Brown wrote:

> > This patch will do absolutely nothing unless it's used in a machine
> > driver which connects a S/PDIF CODEC to it.  I see no reason not to
> > apply it, someone with hardware with more complex needs can always build
> > on it later.

> So... what if setting this bit causes the SoC to start wiggling a pin
> with the SPDIF signal which has been used for a different purpose?

Right, yup - didn't read it fully.  Like I say doing it conditional on
the DAI format should be fine though.

--vZRzFRtr9HMcP32e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7oWkAAoJELSic+t+oim9EIMP/0M2rod+o4SXCcLwDdQii7et
V2aahoI7DMNl7adfP6Ctbkhluq4Znf/WoDmff9H5azDrQ4ObndXY0Xlah4uYnRyi
5mONoLO54O+flc+Xb2yzsQr7hUm8D7qliFEefxSaxttNDHo/UctHi23IwiU9ekiR
MGBL05DX/JlR8Ft7GEuqoAyROiUo4Av3qXjrk1/C4Zr2wafnX+Gmi/hoBxEcYuID
at0ojCIdDWIc848Je3dclf8Z1pAFPqWyRm4hcqqijpIOq1GQNsJkLhHa18oU7+PE
PIehljhQnHzzKOEAKMh6OYn6Wlf/dwuoPfw4TUw81jbxzYdpmNDtF2eXqYN0bE68
6sz+287VQELUrH3+3aN/9kneibjbWxqUP5q90LwekHuC78o1PrFyN/xZ+zkTX28q
1dNXGnR/P0kfdp5wWfh3BrG9mrLw4wsz3laC98fi7i3OJiBETxDAGsPhrZoa23lf
RRwDK6XN15t8h1f9htrIx6tIBPTDDPBS4U7hWDRMuYCqM2QN9IJzkhdBMwZzwJcn
Zn9uKbrKkiO7/ydFwiUzQtrS9Zh6/kvigM3+aBAd17pCmaJoygkrIoD5jAtGyfSA
O5sqerQF3PtjRkMz8787WbE+SOvWz13h9qwew/u1BKrhRnLUp4fCNXMtcfZ0iT5q
3ZX0WVydScoHhx9/viQH
=iQoc
-----END PGP SIGNATURE-----

--vZRzFRtr9HMcP32e--
