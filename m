Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaBSHvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:51:03 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60826 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaBSHvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:51:00 -0500
Date: Wed, 19 Feb 2014 14:00:49 +0900
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Keerthy <j-keerthy@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140219050049.GE2669@sirena.org.uk>
References: <1392726059.13262.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wGsBW1q6OHQ8jQvR"
Content-Disposition: inline
In-Reply-To: <1392726059.13262.0.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.145.86
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: tps65218: Add terminate entry for
 of_device_id table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wGsBW1q6OHQ8jQvR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 08:20:59PM +0800, Axel Lin wrote:
> Fixes below build error:
> FATAL: drivers/regulator/tps65218-regulator: struct of_device_id is not terminated with a NULL entry!

This is good (though I'm not seeing a build time error myself...).

> Also remove of_match_ptr as this is a DT-only driver.

This should really have been split out as a separate change.  We
probably also need an OF dependency in the Kconfig for this (there may
be one on the MFD but having one here if the driver specficaly depends
on DT is better to avoid bisection issues if the MFD gets updated).

--wGsBW1q6OHQ8jQvR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBDp+AAoJELSic+t+oim9DbMP/iCEqIg16ciNcdvL0VOKeyMk
6pkDY3H22LcxJzbkPpsS2y2mnf+6lA0B64QjqjKrG51Mb2V9zRGv061HJYyNk9kn
yAFx3ztrJRSF1SV91yj7lsbRl08ajV2ZPrLW/tlzThGTYbffNxju8QHSYTFv9IdB
z2/WAoK9S+lOBZyAYoI70xjN0VAHylDoLyMfdHqfKPta+VU1e60ZW4Q0jhLLOKYQ
YP/K3HxOeQXBFQGZv5l6jXjuy6RHaZfPvNC3egQSSOFbpKSDC2PZr9TmZtmjrR3Z
QGOLJpwRF/0gWyNPl2aMvUxPOejenE90aT/gbJTKYMaiYMn3QbWgvEQJ7D7Chk25
BgTiQknAAWJZfPQ4PTwM0UQo8ulj5zd49yktaDrDphVgYjSA1e1/Q2JI1b3kkOt1
0+vRXksWdDtCxHiJ/6CRkhN2F8QA/p65ics07gMLi6Sx+27gBi3D8iwWK9TkofaC
rK6K6gkz+uoWiw74nhx5dU/77jh0z68ynIPFjRMsOVv33cOpWDKxzWQw6b8szoZx
iw7U/BwFPKa98MDQyHWYTK4ufRghF6V9xdEwZfepEajM5aNYC+h68Q3M45YpQMYX
uSSAZsajpnQg9VK+Z19+/gASkmNsiaPljRiLfRjiwGRr0J4ifqdPnzcxeaVRP9jh
ugIbuLBlq+v8nD3zwYHE
=2PqO
-----END PGP SIGNATURE-----

--wGsBW1q6OHQ8jQvR--
