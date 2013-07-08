Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3GHQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:28:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46148 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3GHQ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:28:20 -0400
Date: Mon, 8 Jul 2013 15:49:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Message-ID: <20130708144951.GH27646@sirena.org.uk>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxVbOi/ze/qufdlG"
Content-Disposition: inline
In-Reply-To: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 1/4] spi/xilinx: Remove CONFIG_OF from the driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FxVbOi/ze/qufdlG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2013 at 03:29:14PM +0200, Michal Simek wrote:
> dev.of_node is in struct device all the time.

Applied, thanks.

--FxVbOi/ze/qufdlG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2tGLAAoJELSic+t+oim9mDMQAIyd/wdPMhoUJVJ7luOvV1gu
xwth42mMKmBHJqw28jBB8j1GszVdtz+zP/sikbPWi0S3eA8qMryXyYY2omHOID3t
T7Lx19ZLPMOoSCY6tUPv5xQgykyrV/fnDPjVODgUo45WMbrIU/tIJHpPM2wqWAOg
BI3SlQP8l9/gdNFucKK8Z70C5dyQYsJ8ZDYmLNCFMlavURWL4Fx3dCY7JQoNgaND
hYccPI+EA+IiojgY5eYqw5FH0mxlf1WRc/CMoTA0W/EnSNevsGsTFK2DgdqiRvxr
jI457KB3dMinXOWg7QccBdH05Ji4rU2vmmPVcTcsXq/EiVdLYZxq4026U7pfM1vZ
KIInc8/h0iFhWgD4LLd5Ny4Zzxgr/dZ4BXfELXUZ0ZFSJhNjAnLggmoGzzK43Amy
LBDnvn79EkceP9+P7jJ7DjBoCZWcmixPdFxjX7m48rH1vAxqJ/XqNyVVsGNZnp+2
K+vAWtKWmOAQA/RrQau5P7ndUXHJjnGzyP3YEbjmf2KIXel8SOWyW8esoTarU7yv
+lFMGetCawJWXIteRi0HT16ioarZXmpuYfmNHSlaCq4812EBTzYJyjL+UomxpzJ5
hKipS36VOkkBvYvM1SIl+EPA64CUGnYXTBGUHKwFh1juBqZA9zL8hTJNV2/+oA78
7L3cZs24Y24eZvgAgohg
=1652
-----END PGP SIGNATURE-----

--FxVbOi/ze/qufdlG--
