Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3H2SUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:20:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53766 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab3H2SUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:20:21 -0400
Date: Thu, 29 Aug 2013 19:20:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        devicetree@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>, liam.r.girdwood@intel.com
Message-ID: <20130829182010.GQ10783@sirena.org.uk>
References: <20130828113459.48ecbb34@armhf>
 <521DCD33.2070008@gmail.com>
 <20130828121943.1c8327ca@skate>
 <521DD057.4040208@gmail.com>
 <20130829161217.GK10783@sirena.org.uk>
 <20130829163358.GS6617@n2100.arm.linux.org.uk>
 <20130829171210.GM10783@sirena.org.uk>
 <521F8CB3.5060407@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w1WLgcEPVIWvtHEy"
Content-Disposition: inline
In-Reply-To: <521F8CB3.5060407@gmail.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w1WLgcEPVIWvtHEy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2013 at 08:02:27PM +0200, Sebastian Hesselbarth wrote:
>=20
> it is referring the same differences Russell already mentioned. But I
> already came to the conclusion, that we don't need the information in
> the binding. For example, if you use that controller on Dove and you
> hook it up for SPDIF-in (which it hasn't), than I consider this a
> DT bug. No need to double-check that in the driver. From that p-o-v,
> please just let the current binding as is.

OK, great - none of these devices have any differences which are visible
only within the controller, they're all extra external interfaces?

> Thomas Petazzoni mentioned earlier, that the _usual_ procedure to
> name the compatibles is to pick the SoC that the IP appeared in first.
> But I am also fine with "marvell,mvebu-audio" and adding compatibles
> for dove or kirkwood _if_ we will ever need them.

Yeah, it doesn't make much difference either way so long as the base
name isn't utterly confusing.

--w1WLgcEPVIWvtHEy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH5DXAAoJELSic+t+oim90l0P/2/utVMEhajH3NZ0x29+MIvG
26ypM06oSc3QNnHVX/wun1t+GcKudiCYZyZehJPt7VM/MyGOi7Ogz9RzpqASuIUp
SEqYP2plWZ//iVY+fAZaBYWPSZC4vFboBElsSeu0lKmjvKHwUhTPhvnQi86MM/gY
b9IFtcs9IjOP+KdlijaqHuJreM7roroHRWgzj3uWOJwAVcjPPo6Sfsp6ZERi/G+m
sdD+U6qZqVJ+DiymhenJWUOm6Gn5Uhg0/g++eH9SnyUURGjRPCMJnqM5gfbNW0I6
Ckw+9zFQZJSM++yVrq0YveEYWrcp6t+eui2/8mA+RmTjvhq87eGuaUTA90nGJVkL
hvZ64omXI6iIqXdzpA9KN1A0FpRE4EApllARkl6B75aTVg8lwQzteWBuGyEbYq29
G3McArZAwuVX7iHsKAmBjjZmUFgcG20i0OoM0+Tto9GfXUEnZuDvYN7hJ4tdObUM
0KB5y2y/rkQtEeZAmYlNO5PWrXvpQElxy5rAWqsxNkRsAR3/32PQWZs5+TA6QfQi
obr46uEWIKOrhrsq92ZyRfVkYQWAztOAOjxJ8VWYwWzb7DD5U8DQlTVLYdTqesiZ
U5JurcqP1eg7eqCYltO8aB2Z5JIjQEiCW5o7393DB9mavFmzLVAdwuAfFKeA3oBc
/8uTtCa0C/Co860+25sO
=Zj20
-----END PGP SIGNATURE-----

--w1WLgcEPVIWvtHEy--
