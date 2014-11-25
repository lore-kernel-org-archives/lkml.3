Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaKYMUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:20:02 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37995 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKYMT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:19:59 -0500
Date: Tue, 25 Nov 2014 12:17:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20141125121749.GV7712@sirena.org.uk>
References: <546B5EF9.3080102@mentor.com>
 <546CAB49.8030103@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GkP4R6qzw9SWbMoL"
Content-Disposition: inline
In-Reply-To: <546CAB49.8030103@mentor.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Question about fixed regulator DT properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GkP4R6qzw9SWbMoL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2014 at 04:38:01PM +0200, Vladimir Zapolskiy wrote:
> Hello Mark,
>=20
> On 18.11.2014 17:00, Vladimir Zapolskiy wrote:

Your mail is really quite long and all in quotes which makes it hard to
follow, brevity is really helpful to readers.

> > | regulator-boot-on | enable-active-high | GPIO polarity | GPIO output |
> > +-------------------+--------------------+---------------+-------------+
> > |        no         |         yes        |  active high  |    low      |
> > |        no         |          no        |  active low   |   high      |

> > I'd rather think that both resulting GPIO outputs are incorrect or
> > better to say do not correspond to my perception of "regulator-boot-on"
> > and "enable-active-high" DTS properties described in the documentation,
> > however above "enable-active-high" and actual GPIO polarity are the same
> > (when they are not, it is another open topic for discussion).

What you're saying seems sensible.

> > Should documentation be updated to reflect "regulator-boot-on" role that
> > a regulator is re-enabled by the kernel?

I'm confused about this.  That's the sole purpose of the flag and as far
as I can tell it's what the documentation says.

> > Should "enable-active-high" be replaced by getting GPIO flags directly?

Probably makes sense, it predates those flags by quite some time.

--GkP4R6qzw9SWbMoL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdHNtAAoJECTWi3JdVIfQb1oH/AsnpwoEhS5tk5UMF7HYZphB
04+FG7LtSNoDPuY+mJD37PIpivewQsg1gW3yYzxTvHf5H+7iTS5rDeBoTvsuj/+b
r+5AsBc0RyiUOSlOxDa1B22KpiJ0AuJZfh0FZ+fYxx+nuz0KplfYWaZqVc4zYZI1
RMVpU/GhDTkxYM1o4xr70XlEVE3aq5Sj8zIxOGo2rarnsidQEvvkQl+kHgyOxLjQ
upCeFrwTVi2la/vrXlC0O3YFgqG+7knyvJo2R/igx78+nlFOZQiDikeXPtG/U+ui
neFrzPKBCk9iWNJxUXpU0CuFJbT+fKOM8ukvCu5upghwnI3sfRGW4vdxqY+JcYA=
=lvs6
-----END PGP SIGNATURE-----

--GkP4R6qzw9SWbMoL--
