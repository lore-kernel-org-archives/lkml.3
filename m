Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab3GCRz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:55:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38320 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3GCRz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:55:26 -0400
Date: Wed, 3 Jul 2013 18:55:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, yadi.brar01@gmail.com, sbkim73@samsung.com,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org
Message-ID: <20130703175523.GW27646@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
 <1372072858-6559-3-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QJLNdq7A0R34yxmQ"
Content-Disposition: inline
In-Reply-To: <1372072858-6559-3-git-send-email-yadi.brar@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] regulator: s2mps11: Implement set_voltage_time_sel()
 ops for bucks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QJLNdq7A0R34yxmQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 04:50:56PM +0530, Yadwinder Singh Brar wrote:
> Currently driver uses local struct s2mps11_info to store ramp rate for bucks
> whic its getting through platform data, so instead of using regulator
> constraints it should use s2mps11_info to calculate ramp delay.

Applied, thanks.

--QJLNdq7A0R34yxmQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1GWIAAoJELSic+t+oim9yzwP+gMuhFZlOlkAl1vBB3ZwSFhZ
9bXUwXaN0xHAhvB2PQlBfWSEBA0yt+sfSibs3OjqG0ooE6aTbJCIJ/PBYokvO4A/
W1D9gJVJUTrjySnlSvhr1KZwoIYRWQEauHZZyy+PWBjk4J3cb2z9MRscTu+bYOCp
910LtMjEmYUWiFY9+liFjApoOnhUf+QhEhs4LeLjZrvTP4006PIglVPcWdsF0vEk
57OMh0QOYImekGRl47HbvMWShDxSXYw5qkArJ2auR4HnfqzydkweSSuBDsIgJ3fG
vrt50Cp2fUj04PBSGaIpTNnBevOolmiyNtLClwxrngYhFCBDO0c4WeNGjZTZSzo2
sSLaKzTNUaX34EWWmyG/BK8E+iAUmnS1FjbpXriOnUs2RpLpCc/4XT5OLuw9aXD0
vIcrbWWkDioC5ANk3SoQyfJUvej+oBuDYyou8mSwOiFCgAEe61FpzbbHyhcQuOD1
1eDdzPbP1WOdLEg02ROLCivbodovZNRHQ0zjpFb4eKJ8i6FRTM6rPG0PpblJ7X18
Zd2b/1/D7YvcU9JFkG+I0CjlytV9h6XmvEMN3mrHrQ7dC/rh1/YO66phKLewkbQj
f8jlZdD/TdoMmK/bWeNort321L7zX0eSTFkLz47rQVsPmHgT08zon3nSvDjqmu6D
X/w7B0F44z9Q/6zrTbLq
=Dbh4
-----END PGP SIGNATURE-----

--QJLNdq7A0R34yxmQ--
