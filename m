Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3GDKpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:45:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33200 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3GDKpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:45:42 -0400
Date: Thu, 4 Jul 2013 11:45:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Message-ID: <20130704104511.GU27646@sirena.org.uk>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <1370950268-7224-2-git-send-email-bigeasy@linutronix.de>
 <20130611142336.GE29135@zurbaran>
 <51B7358D.7000605@linutronix.de>
 <20130614135358.GR1403@sirena.org.uk>
 <51BEF5F4.4090600@linutronix.de>
 <20130617160326.GE1403@sirena.org.uk>
 <51D53A31.3080704@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f8TtFscsztEXiewY"
Content-Disposition: inline
In-Reply-To: <51D53A31.3080704@linutronix.de>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/22] mfd/ti_am335x_tscadc: remove regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f8TtFscsztEXiewY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2013 at 11:02:41AM +0200, Sebastian Andrzej Siewior wrote:

> The driver here does not use atomic updates but read followed by write
> so your locking here is futile. So the API/regmap alone does not make

Doesn't that sound like the driver ought to be using a r/m/w primitive
though?

> it right. And look: the MFD part uses regmap. Its children (IIO &
> input) do not use it. After I told this Samuel he said that it is okay.

Again I think the point here was that they probably ought to do so.

But I guess if you're saying there's no problem that's fine...

--f8TtFscsztEXiewY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1VI0AAoJELSic+t+oim9i3UP/2C4EKEaIPUsV24E4/cF+ZwI
XeWYH6nVk9JBWSbTpXCtGTb51adOzeIp/ANLKs6dVXjL9EQlJZ5o4AK1nVvh2dbn
tEnwhUepfWKx4yrRvkocYsBjg/79fVFY3pCN3O5Jl5TMME6VemHlGwXcxNAvz96H
vQi2yyIAr+2iRWwDXpq4tnO9GniU/Oxs6jg7jKsif8Rwo/e3UJBuxgqANjgMgmAL
fL/SDUquMb5MPaALN44OOI3ke2GtOYJKgkH7ESnowzK5V5JIlUBUHDjJ4PzBvhN5
pliQEyfKZxrb73PawnU+AX+/npl1YPSfb19x+MnA6l9cmM3M93EE9d92O2x2wW6Q
fy2WWmaId120B75HaPfknKr+LaXLE8coH9/L835dN3mP3xOddyQtz5QjJdQuABLZ
VGL8UI8YfSRIGWwc9PAJIxXwezjoXYIIAcPW3CXryPfB15dgpJOeBS7g6EVwaTvM
IcOVnw+Jgdi1S26BkyPMR/iWJ0wAQzy91xrkX21JDeZxno4zCmgk2yreK+orM9Vp
Aa//qL6F41qhhHdmazFFBFl07lxUtj7oz36yha/K5C7AeD3gdvRhvlHwTLAq+CoF
RqRcHy9ZpVs+T1CODCHo2fJ/XnNEOz5gDuKcn2KEYc03JiiEk0knQ2mZMFv5URMd
x0T5doL6EW19k29hsJ7L
=l7ao
-----END PGP SIGNATURE-----

--f8TtFscsztEXiewY--
