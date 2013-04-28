Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3D1BNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:13:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40451 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3D1BNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:13:41 -0400
Date: Sun, 28 Apr 2013 02:13:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130428011317.GD20197@sirena.org.uk>
References: <1366775472.22788.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lc9FT7cWel8HagAv"
Content-Disposition: inline
In-Reply-To: <1366775472.22788.1.camel@phoenix>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: mc13892: Fix MC13892_SWITCHERS0_SWxHI bit in
 set_voltage_sel
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lc9FT7cWel8HagAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 24, 2013 at 11:51:12AM +0800, Axel Lin wrote:
> It is necessary to clear MC13892_SWITCHERS0_SWxHI bit when set voltage to the
> voltage range from 1100000 to 1375000. Leaving MC13892_SWITCHERS0_SWxHI bit
> untouched may result in wrong voltage setting.

Applied, thanks.

--lc9FT7cWel8HagAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRfHeqAAoJELSic+t+oim90qYQAJ0QTjeEuePS4H3gdnrbiuAs
BNFvJNIqjE/UY8izN7i0KV85zJHTKbr0/rms9V7WAGMz21TzZhk8FPPzEWFBfqGm
6y8yO5IGG8/mvFoaHRKqgpf7l1mbaYINmedLdAGWuwQ3vr5LWuR5bICVUlKuTBw+
2tta4GQIIZ6CmNfmvCc5x2i8lw5En5Gyl1uK6E5mqEFNcpUriZqgTV0O47SIz3hm
+9dOP+25XhUXWcMgWKitSanSwf7pRt+FEn2W/4aAF+LUHZuyn9zMppkQH9RNWZg3
x3bR7W/qB3BXUSxgmYwNc8rF9AhbUherhFXB1owNwb5m3vOabDJFoecHNXmHVOGC
QqukHUQl/KZAuNm/1D2LnV71Py67vuPJho4faaRK5jqY1IBdpKaMNv+INF16Mbnb
6UoZLHaR2V4CscA+6GHaL0C9xi5lc800kETChNEmH7/wJDH8XvpM+3vglVgVOVvx
Va6ro9EiWNm/Tegx9h+jJauopCURZOocZtnQnin6ATZpVIz8OuOpv3uy/K/NdmXe
f/M7Cvqd1yD7f35qwflvpSqhkcmkAfkEp7SotMcpYhrfLjGweFcelcxPkNGc94vX
CvjSSsyJ+yO90x78A484vz8j102wTbjNSuzNkxuMflj5uapfq3KL6vDF8/EtPZaD
vUl+g1h7tE2I7rOSqc33
=qivM
-----END PGP SIGNATURE-----

--lc9FT7cWel8HagAv--
