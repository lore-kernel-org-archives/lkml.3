Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaHQNzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 09:55:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40923 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaHQNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 09:55:50 -0400
Date: Sun, 17 Aug 2014 08:55:38 -0500
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        James Ban <james.ban.opensource@diasemi.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140817135538.GF14537@sirena.org.uk>
References: <1408271688.16342.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Content-Disposition: inline
In-Reply-To: <1408271688.16342.1.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9211: Check return value of devm_kzalloc()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 17, 2014 at 06:34:48PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks.

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8LRXAAoJELSic+t+oim9NuYP/i03x82NCP5GFdn1lEC/D8vB
l+9nRvdr8jHepShyxd79w2jjRWE2v5CmMDP2eZ3E2lyzZyNS6SsbIEUJbOycdZ84
ZLr5ZI2uRAwRsPBY8SGMftxPZk70fyhAkBMrBEgXb0RjN9xxh7yxBGCphdLj2XkY
m9/zOXQ7lIsz5s2RKq9TMsFkaWbvKbIbhVC4QYCAKgyObJN0WZnNjOoHNnUQgmTo
ZhRhuVyaZBZDKSp8Txe1q7a9LhpMv/RDIMQcCy4iy/uG+n5zQEWLsfLHxB9EbuHY
tk5ieyfFWOEQSkptvJBr3WYKwp2B9h111aofcDFggk6z6lvtvWFedu/kcU07Q7De
EaEiOrSXe1u/NDTX78/R0j1xPUNlCO2oj+N2mtxX4z7HtyEj7OIHKBn1O21mHsrG
jW57jGtcOHEqgMtoQRQ8UFo0Wh8i2PJ8eaXs1qxkuonJtAslt0TkbQa6P1+E3Hh7
6/anTDNDQsJ61kl1ivMJeVvKns5IVCDgwvv+FMCMDyTwoDAVKP9skg33ECUcQzam
a+2N2khCGfseG1lNiBACq2RewZO48WszckFoF2vrGilpGCz2ks/OVarJzP3DUgPU
/uaF7Zxxjcq7mxZnHaaIZBRiALWq8mux1uirLraJb+FiWHozIyVqOrjqipRZzIgc
odk3aRhD/98j0ifKj7wS
=3Fuj
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
