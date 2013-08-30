Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3H3Pkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:40:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46359 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab3H3Pkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:40:46 -0400
Date: Fri, 30 Aug 2013 16:40:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130830154041.GA12809@sirena.org.uk>
References: <1377872024.10551.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <1377872024.10551.1.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: lp872x: Make REGULATOR_LP872X depend on I2C
 rather than I2C=y
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 30, 2013 at 10:13:44PM +0800, Axel Lin wrote:
> lp872x regulator driver can be built a module after commit 631a1fc
> "regulator: build: Allow most regulators to be built as modules".
> Make REGULATOR_LP872X depend on I2C to allow building lp872x module when I2C=m.

Applied, thanks.

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSILz2AAoJELSic+t+oim97eAP/RNlK0mHE6ZlvlneCDr79Lhg
H9H5iJnT3SRYkXPPVGKXD43Z2jk8nKaeZ5iWbt8C+BEw6Bsprhq9cDLul3mqAqgE
sppK5G7J3prsDW11JPcUaCppYnTiv7W3Ps7h5AtJgxdjk6sIQD2uARlHCHDi8O/g
3l3Sb3Kk4HbmBTS+esF5PaWiz1gjK45+Bd65HoKdEQ1V0Xvh2U3TMjBuKRChHvjx
TETRFMGWOwleq23DrS6m80PyqYE1gf904Ksud8LMVnZCzFrzb1SJguugIDZhh8MZ
br45OJpn9UCNirV8JScLXiuD9sDWuioBJP3Du1GaSkFj/PNxbjkyb6QEFnRiSsV9
kGO0yHiFC1IxJfIUQIJwYYJiorI7QYnOFiszDBrKn56ZlVrxiLpm8sVmyqBFiyEw
4QLUREi3Vxm3LA9FbLq4s6isTCFVOqPVAP/G1Fpx1O+15Wwaps5ZENUCLSBVOX2w
e1P+fMEhYj1kizaij5qpYBEDtrXXVvOy/oc7RT1apCIuK9tll1cs71EkWvrMAExf
0S+knkX2ZVroKn72cm9BdpooJy6P2HAYWXpaiABeWbgoB3K4C6Ug/pFXbSMkSeAM
sn/MmPJfP3+QO9ZAqJZoSXp8tzM9JVlHgY2+gfSQOZRe3H92kkDeytzwdDznNPgZ
oGV+YAqfPwdQsuyJbM8b
=Ju59
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
