Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaLITRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:17:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53491 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaLITRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:17:39 -0500
Date: Tue, 9 Dec 2014 19:17:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Mike Looijmans <mike.looijmans@topic.nl>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20141209191725.GJ11764@sirena.org.uk>
References: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
 <20141209161420.GJ1934@sirena.org.uk>
 <54873B8E.1060106@topic.nl>
 <20141209184817.GH11764@sirena.org.uk>
 <1418152471.15957.12.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XK4NhNJ9GVfup2vH"
Content-Disposition: inline
In-Reply-To: <1418152471.15957.12.camel@perches.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] drivers/regulator/core.c: Don't print error on
 EPROBE_DEFER
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XK4NhNJ9GVfup2vH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 11:14:31AM -0800, Joe Perches wrote:
> On Tue, 2014-12-09 at 18:48 +0000, Mark Brown wrote:

> > Can we do something with the log message that triggers on probe
> > deferral?

> Maybe add and use rdev_err_ratelimited?

That's not going to help, the volume isn't sufficiently high and comes
=66rom many different devices.

--XK4NhNJ9GVfup2vH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUh0rFAAoJECTWi3JdVIfQ7i4H/jvTzLaieiNKI5L5Z7YEKGQM
6I8jDGahe0b7OfXrvBttDotYHDHVmrhKkpfKy8wx1q6qqBidRcCTzcfxhz4gdoPS
Cc3N/L+A0/MFSX/6+BiHt415zLv8SpZzYLk6mv0iA/fVjXPNcpkBncWoojGYo5/b
x4Xk3LBHLeoWFhXjSwvu5N+Pgj9B3VMX/cfh2cIADL5wiRelWZEQuUefsD8gnnv6
XTcHCjOqdD1LT8qVvNX5u9cZ5Ch80UidQLRpL8jeXI1QVTlHH+xXUwRnU3V7Abr8
0qpXtTmVtrB3PHkTDHQDyE/9PYEIRdLw/LjgyzwDDEIphRialfOrpnq3cqB5938=
=HdnT
-----END PGP SIGNATURE-----

--XK4NhNJ9GVfup2vH--
