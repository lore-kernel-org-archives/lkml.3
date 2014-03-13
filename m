Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaCMJN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:13:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52335 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaCMJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:13:24 -0400
Date: Thu, 13 Mar 2014 09:13:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>
Message-ID: <20140313091311.GC366@sirena.org.uk>
References: <1394646926-30496-1-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
In-Reply-To: <1394646926-30496-1-git-send-email-jcmvbkbc@gmail.com>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/3] xtensa xtfpga SPI controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 12, 2014 at 09:55:23PM +0400, Max Filippov wrote:
> Hello,
>=20
> this series adds driver for SPI controller used on xtfpga xtensa platform,
> device tree binding documentation and an entry to MAINTAINERS.

Applied all, thanks.

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIXakAAoJELSic+t+oim9NigP/0mex7MCLxmUPE4WFRMvo4db
4wc3kWMz34Qag9v1l6vmHgVFFR4lGd04k27AF5FbVcZnd+ocyJSglsTF5syEevjl
CZMJF6DMYBdFZ2AITBtUdY0zCMInxhsh0DUC1fhtmraEjUcyO3aH+Cmq4Wuhs5e/
j/kOJlIz9veH5vcVYQ8yW1kF8BkjlbRAAiadcrmsQUTQj/ASi70uhWaWTHcZt6bj
rFfniplpV6ICvuOC/ovHhXYadOGqLBu1IqNN+XZkee9sL3Folq7FfP8SxPPC/5r5
xu3NSrgf0W7J/7jNyUSk3pEUHU7z1WqvPNUDfv3AGYsuk4d7T5+yv5qsJW2/mFaa
DCKkkOSxS59boUA88psA/Xn1FybBrfwqtdCso2scBZk2ACW7Xmk8wd4r9PjrOyRb
Dz3GbEAl+/pZ7VGQJEqOXfxe9THGN8dSWrbyksHah4SHRwlJIBWuatByO8W8zKx3
qRrf54k0JyNb/c4AvbHE8qq+iA8QbrFlo4Q2P0ZPwevlAeTHE8Gm3ChrucACnFJK
V0TLyziuhoRqmcBNZ3TlYpstEy4cafRpz83WrtEYk6zEAfxqfoHXC4OqMEkm0d59
qEMq/pQW2wNycnOWtIEkO3VVHEs8GHvdzgYFCrlzKyBvI8gRQj1ZSVDKJZ4SxIBv
4veffbtr94JiTM6t0abU
=T3F8
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
