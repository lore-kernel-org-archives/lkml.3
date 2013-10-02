Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3JBL2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:28:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34781 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3JBL23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:28:29 -0400
Date: Wed, 2 Oct 2013 12:28:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: Axel Lin <axel.lin@ingics.com>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Message-ID: <20131002112822.GB27287@sirena.org.uk>
References: <1355794210.5681.1.camel@phoenix>
 <1355794372.5681.5.camel@phoenix>
 <20131002101500.GD25376@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <20131002101500.GD25376@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] regulator: da9052: Use apply_[reg|bit] with regmap
 based voltage_sel operations
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 02, 2013 at 12:15:00PM +0200, Michael Grzeschik wrote:

> we should not play to much with generous functions for this pmics. With this
> patch we loose the fix_io code path from da9052_reg_update.

> I suggest that Mark queue the revert of this patch.

This seems far too obscure to be robust - if we need to bodge all I2C
I/O (which is what that looks like) then that should be being done in
the regmap for the device rather than by having stuff open coded in the
function drivers like this.

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTANTAAoJELSic+t+oim9258P/3zAgDi2fYb4mUwx70sK5fA5
fQ8wPuh1LwGOScTuPUCBgcI4NbeKWatOcmyoXetJiNyqIo6S0B703cmIJeiciv0e
xpExVvg1EV6/v1pUNVc0fWyXmjYyDHHD3XPHOWD7CCzmk+60jwqXgigE3xowfXle
2RqJh/L5wAJwS2sazd3EWkBXuyb+H+TRE5+rJgOopV8nogc+Cy/fZ3AlvcnM3qR1
G+De1zzrxthebJbn14a1gvTynzaZkgr+QmeOEKT4Yttct/P4JhdaT6AJYkLzLhN3
cTYPYVfjdVSRJweBqbTBTWFgLIIhuaaNjZQBsUPrjsO7jOGUT7EMvq9A6v8OpKFJ
lh5l9HoqI2O5k74iS+VyFjSUWjt5+/BpTdPXFlorZ6toJW7fXzmbx1bubP5/gk8V
tJVpgAPcnlZDu9QhAKw+QsghoPsP7QKMxfzRahd9ONIeayt+WB+o0i1MNIHhN4OA
DsV6buRb4pg9s3dOdx+CileYgulMntqDDDGtgaya7vNEjLyLf5mRsiCu3D2liAsM
SapVGwp2/Uw7EBCSR7SMRwxh7N/k2Z2MIJfYf5rxs1JEtAT8XgfaBb7iyKrfVyDT
8yRTtQazE0fyeRLtwhJU3bCofi5MyYpo1KUo120u0pThsCi63VaALqsHawMT0y6I
/5l2MOCtCvehZh2TCq7P
=dgVu
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
