Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab3GCOSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:18:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51761 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab3GCOSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:18:05 -0400
Date: Wed, 3 Jul 2013 17:16:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Subject: Re: [PATCH v3 4/8] wl12xx: use frequency instead of enumerations for
 pdata clocks
Message-ID: <20130703141659.GQ15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
 <1372860209-3504-5-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OrT4iOlIQZp3kw4S"
Content-Disposition: inline
In-Reply-To: <1372860209-3504-5-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OrT4iOlIQZp3kw4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2013 at 05:03:25PM +0300, Luciano Coelho wrote:
> Instead of defining an enumeration with the FW specific values for the
> different clock rates, use the actual frequency instead.  Also add a
> boolean to specify whether the clock is XTAL or not.
>=20
> Change all board files to reflect this.
>=20
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--OrT4iOlIQZp3kw4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1DJbAAoJEIaOsuA1yqRER88P/i1Fbl2whPLiblQ/ycn8nTTs
YZM0bfxn7SXd9KRpR85jCB95iLdArWQAJRlCulgjGoGtRXbup1rGxbOVP7XqmbUl
Fr16lrVqAL+65JO8uh9p6Hkv59qFwytrHeOFNzHcR27W/JxKMgS6oZyu5lfOD1q2
ED0T0B4A0ONCn6v4+xIv6P7XCeuZgVTMFsTreGuMfeQpc4HSvcgp+SGwNGzKkl78
xn0It10iWyCna0gHYti700TfpX/Qv2qZoSpx8KqASgg+Y+6MvXDmv7KFaa+10xM8
iwMgwE2cwBv6TXcAKr+N4RdnAx25vAI/feqnds16Avcy+8tIqaLq2vOy0sj2AWol
XRJTCJob//oZrHG05GOiTQwfW44NxwMwAtmWQ28+hhVGt2UjkIT15VYI8PUDPrGT
sni4/pL78hndm+370PNCJT2KMuC5P6M5vqmNq/RI2+stBuHTUXqWCviQuiDJfTC3
wnLhxE4J04NNRjjFIRyulCj7iv84sQWUM2A4JsPxCYLTxNdy3A9bxJnujBZ6pYmH
hoZKo94ozIZIgT5cGUM2N9Ukw6u0VV5o8kEg8plgJMkdVXKlBEtDE/WKzvdWHim3
d3HXhVLHwGn1oDpWpTf/+/BMK/cmHdUWV4KzloO1niXhZk6SCiyfuOi5/D1JeYGp
uVCyQ5aJeVjqHE4eUKJ/
=z0st
-----END PGP SIGNATURE-----

--OrT4iOlIQZp3kw4S--
