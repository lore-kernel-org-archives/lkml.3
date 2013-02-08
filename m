Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946312Ab3BHLdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:33:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38355 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946244Ab3BHLdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:33:50 -0500
Date: Fri, 8 Feb 2013 11:33:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regmap: debugfs: Add a `max_reg' member in struct
 regmap_debugfs_off_cache
Message-ID: <20130208113348.GO8879@opensource.wolfsonmicro.com>
References: <1360237225-2184-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPOl6LAGMgeiWDic"
Content-Disposition: inline
In-Reply-To: <1360237225-2184-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GPOl6LAGMgeiWDic
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 07, 2013 at 11:40:25AM +0000, Dimitris Papastamos wrote:
> We are keeping track of the maximum register as well, this will make
> things easier for us in sharing this code with the code implementing
> the register ranges functionality.  It also simplifies a bit the
> calculations when looking for the relevant block:offset from within
> the cache.

Applied, thanks.

> Change-Id: I961320c4a56fdd25d74f1a6cc1b470ff22d8dbca

Things like this shouldn't appear in upstream submissions.

--GPOl6LAGMgeiWDic
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOKEAAoJELSic+t+oim9Wa8P/Av2/2npZkBWtBlXCfvIaWel
1OPgxjfp/oSW+Y+Qvet9g0Fg7KekQvDK3nE7pB2X/2OOkQ+ZTknJAEyJ0sybBYOL
nHgMc5Cu8SdaJAOGUSCKpsZHeaeiNDqguzvIQhpOIHF5Za2ih1C8NOGePeQIOBUG
OOWEkgGH+XUnmqXS46ej4BdIc/iPAxbbX/h/XAekbb1YquRTR3eAN/7AfdemCtP0
Dy1HTpDDeRyjINpKyUzhY3HB4r2L/wI4pcg3jSjRMfWteHGV4/5Po3Ovs3oPmX75
w5s5PbxXc92Iox9khAJ9ZLtcZAO2aI+u0aZRLGYDnRKQ0YxAkSJuHCDF6RD4REDt
vZiRcJ/rtLEIALR6gfRcn11DdzA8oh7RVOVooVF99zPowhCTxfY+5usM9jtmPMoA
K6/y+eX8VVaIiPoZawxKJ9/gYIyyMLtPLKfaKi14eCEHGPc4zcsHbrSjh02i6HO/
ZqAwpBGewkCTPHDfYcVjGUI8Y9jY3ojONcas/qS7C64n7Ljlt26jyULo4eD8sGmw
CuRn+fhbUh2f4nZi3IzbbTS1k8kNh+toojQlZqz9cvP183Dx2WIrBVYqaRU2GNeP
Qnz6SaswmruE6UWvfF7B/Y9NQpwpEoUfsiF1FahFNm4yO6VmwNF9hRcKmiVUY/iS
oeSjnEL0F3Oc59xTS9Qe
=wLhm
-----END PGP SIGNATURE-----

--GPOl6LAGMgeiWDic--
