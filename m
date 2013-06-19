Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944Ab3FSQnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:43:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48313 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934837Ab3FSQnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:43:17 -0400
Date: Wed, 19 Jun 2013 17:42:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, ldewangan@nvidia.com, sameo@linux.intel.com,
        grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Message-ID: <20130619164254.GA1403@sirena.org.uk>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f1Ot4QhJn5dlG2/n"
Content-Disposition: inline
In-Reply-To: <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f1Ot4QhJn5dlG2/n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 11:27:47AM +0530, Keerthy wrote:
> From: J Keerthy <j-keerthy@ti.com>
>=20
> Check if irq value obtained is valid. If it is not valid
> then skip the irq request step and go ahead with the probe.
>=20
> Signed-off-by: J Keerthy <j-keerthy@ti.com>

Reviewed-by: Mark Brown <broonie@linaro.org>

--f1Ot4QhJn5dlG2/n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwd+LAAoJELSic+t+oim9Po0P/ApRELd4efvrDfhsfTBaE1/K
HXDV4j01sG+AQ6jPYnsODw5gJkGGEh9Z6/oKUPK4+VBHwg/aOalCwTMAgJ4JQ95D
ixOZCql8s+Rxf7XbB7a4/HLvJjtflUySnxTGVozS/newrbD991n0RcyjwL+97yEp
xWCgn6D+bYOXLnpVN2Pb4TnwgqHLVJ4QMYD525o4j1RqkRSL1nLSb/JWAQWtsQZp
P7R1WRgkn0eEVf7XHPP/GECCuUMypCtw688TDH/rs4rBIixGJ/wiHlPtxSN0e9yt
+e09y5lo25Xf3v5pW796XDzyWS28kcCUqV+ipDWle81xVd3FooIhnouEKO3l8QbQ
JDVq1NCGFbWOUfoXnixSYQjrEA+/modH6RTGUUjJLMhi+ooXCN6pRD3DXPSIb9Xr
WHQZsEUkuPbdKm8xvTpSb4ICVlGtgXgmTLD/TKyl2CJgD2lPc7afwj8UVdjcltYx
yjw2YNJAFm6aJn5/KyB89CAoZSm9v4fxao4jFpD12O2SSU045omuFnJZ1DqgTXBg
jMIyeAa+X+jQSV53mqdL508idcXJwELjoNQeVGaAkXJ9iAc38D5eL2Ef4zjre33T
uSH9unmilfYAEvj3nPWZ3hBwzGTc/dJyWamM8C41hmo18aauyv05yQ3xmBqIzDme
uwVzUmodTsqD5jEaiVqm
=8YBj
-----END PGP SIGNATURE-----

--f1Ot4QhJn5dlG2/n--
