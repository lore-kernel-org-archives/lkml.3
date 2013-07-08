Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3GHQ2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:28:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46181 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3GHQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:28:34 -0400
Date: Mon, 8 Jul 2013 15:51:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org
Message-ID: <20130708145119.GJ27646@sirena.org.uk>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
 <95fea2ecead16435fc526b1d7f36a0a1ec1635ff.1373290150.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDFJ+9xGg5Gxc3IU"
Content-Disposition: inline
In-Reply-To: <95fea2ecead16435fc526b1d7f36a0a1ec1635ff.1373290150.git.michal.simek@xilinx.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 4/4] spi/xilinx: Use of_property_read_u32 for reading
 value from node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eDFJ+9xGg5Gxc3IU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2013 at 03:29:17PM +0200, Michal Simek wrote:
> It simplifies driver probing.

Applied, thanks.

--eDFJ+9xGg5Gxc3IU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2tHkAAoJELSic+t+oim9rP8P/32a12gQ9VKHJ4meAqT3kZDc
kcKwDkzHhGQf9qa32EC4iBHjthiFSrgSCHyP3O6TUna0VoxDoYNSg5M+JGQuJNeo
IfwErZmDh8Uf4xrL+Zc7E1DiPJ4DuPcgjrlrl+KG+ep5xymdO3RzWy4iMI9jZgkG
2V+mmrHDzG7RqK0J6DDPw1gkQkKqjCtf6oAJg1G/4KCY2LYZ5+gsNuQRnzzFnIzp
K92/YoROYHgENzmGdifiBcGV2XA1GDWtHRB0EMw6RVVoSIkAtWTSYK+TVyr0Wx1C
0XCVAf1DGd7kjrFdQuQjFkgCPGaXkRLaq/KQ0OyiSdvzn23hUk2WIuTJLVzvng4h
IIjbhPgaIJBwTrbtDKuOHlEUcw5lKvV/1URo0uErbbWwrrHK39SQxSDYu/0z+m3S
mwKbU+PPCtrfvE6xh0orb0LTMVZ2aYqLouDI5Sjh4B+YpczaWDmMlxilAsMhpDqM
JFbZRsLpzZ3RZ16+jEtwB7RKZ2uEM8XQsy5B3j0y0cnvT7xkTW4Z6ZBFG0Zu0NiY
J+AwWIqH4jWqTYbMR/x/X9QTBA+SfgUHsE1o8b/j278HfR4GIn9Vij1gwnn4Jy8q
ttVRAVqDS9kU1t1atUhjyr+3gzxY6OxF/Lzk63+YUwZeTrQUmNMH/7nsxsGKsleo
mdjhy91NYRbfTUtfocoQ
=QKnk
-----END PGP SIGNATURE-----

--eDFJ+9xGg5Gxc3IU--
