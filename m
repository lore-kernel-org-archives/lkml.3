Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab3HSQCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:02:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3HSQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:02:34 -0400
Message-ID: <1376928143.18111.12.camel@fourier>
Subject: [3.10][3.8][3.5] ARM: Fix FIQ code on VIVT CPUs (was Re: [PATCH
 076/133] ARM: update FIQ support for relocation of vectors)
From: Kamal Mostafa <kamal@canonical.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Mon, 19 Aug 2013 09:02:23 -0700
In-Reply-To: <20130818210952.GI3067@blackmetal.musicnaut.iki.fi>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
	 <1376692475-28413-77-git-send-email-kamal@canonical.com>
	 <20130818210952.GI3067@blackmetal.musicnaut.iki.fi>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LgBSyBWTdlaldiV8JWU3"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LgBSyBWTdlaldiV8JWU3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Aaro.  I'll apply "2ba85e7 ARM: Fix FIQ code on VIVT CPUs" to
3.8-stable.

Greg KH and Luis Henriques:  Heads up!  3.10-stable and 3.5-stable also
need 2ba85e7 but it isn't marked cc: stable.

 -Kamal


On Mon, 2013-08-19 at 00:09 +0300, Aaro Koskinen wrote:
> On Fri, Aug 16, 2013 at 03:33:38PM -0700, Kamal Mostafa wrote:
> > 3.8.13.7 -stable review patch.  If anyone has any objections, please le=
t me know.
> >=20
> > ------------------
> >=20
> > From: Russell King <rmk+kernel@arm.linux.org.uk>
> >=20
> > commit e39e3f3ebfef03450cf7bfa7a974a8c61f7980c8 upstream.
> >=20
> > FIQ should no longer copy the FIQ code into the user visible vector
> > page.  Instead, it should use the hidden page.  This change makes
> > that happen.
>=20
> FYI, this patch introduced regression (kernel crash) at least on Amstrad
> E1 board (where FIQ is used for the keyboard). See the following thread:
> http://marc.info/?t=3D137583169900003&r=3D1&w=3D2
>=20
> So any stable kernels where this patch was added should also take:
>=20
> 	commit 2ba85e7af4c639d933c9a87a6d7363f2983d5ada
> 	Author: Russell King <rmk+kernel@arm.linux.org.uk>
> 	Date:   Thu Aug 8 11:51:21 2013 +0100
>=20
> 	ARM: Fix FIQ code on VIVT CPUs
>=20
> That patch fixes the regression.
>=20
> A.
>=20


--=-LgBSyBWTdlaldiV8JWU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJSEkGPAAoJEHqwmdxYrXhZdPIP/iyrpunWkWkl95QCa8ecrxds
idGJkIweo/I1kL27zF4jaJ59BcIXLfr7tIuudUL236C232D8lfuOHIHSLu0FDU4y
LMhiNLVeJFBMLs+8gUUaq9+u9dO8kgzVdmZE5faMmYPIMzmeVcgXz1JfiTbJxoL0
ooYSGjUkVDVVYs2Q0v+pNRDyvXDBrdx8in4TpiOvYypTi6haI4CxKgJHIi36CyLm
vGDNxDTWOCtZ8CaiFhGWKbZEKu5uJL5RxfdY6SL3JHsHZwQFquzdBH4HXf1n894I
aDHZ12dslm/4tM47dF6atsxviOwRGSrAiE3Hmr9bHR3EwQv6b29IlYP3JUalyFh7
Nt51jlc0SJpHNZaIKZyBLdN7hIP2uuw+6JcU7f+xQ0pDI6P7POh1CKmygSmj1ZK+
7rCF1JcBu+2i+GwRK4fN0El+wlzyTrxhugL9ilT+ivuG/1GhvHFV3lP0nz1CE8Gw
a08bv3yzQQEa4vE0kgFRQTxZlRTuWj9JRstBkzns6LrDCO7Ut1rIhZL5YLCGdjNY
6yaNLvyjD4w51rWaygkzZI2ik4m+snxbGCRGwqspStV6jktuRbQCJN/GjiqA8cA3
GxzrsTYrVtZfhhgeNeJun00firEzW+QtfvbKbisnbujHAoK5a7nIE7Rhwtt1Tc6G
2XHpNHbCvdZKKzIOpmaT
=nK8c
-----END PGP SIGNATURE-----

--=-LgBSyBWTdlaldiV8JWU3--

