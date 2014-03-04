Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaCDGq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 01:46:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55134 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaCDGqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 01:46:55 -0500
Date: Tue, 4 Mar 2014 14:46:42 +0800
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20140304064642.GA13126@sirena.org.uk>
References: <1393911933-25149-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <1393911933-25149-1-git-send-email-b38343@freescale.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: pfuze100: add pfuze200 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 04, 2014 at 01:45:33PM +0800, Robin Gong wrote:
> support pfuze200 chip which remove SW1C and SW4 based on pfuze100.

Applied, thanks - however I just noticed that you forgot to add the
compatible string for the new part to the DT binding, please send a
followup doing that.

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFXbKAAoJELSic+t+oim92SoP/RI+D530MIvHE6hXOPCJ17ZY
2cx4cdxjuDOTKTftzxof23Zbf2EY7Mfn3c3sOb+ChRp4/Bb/neToAJiAuzTuDeGU
tVbeA4TY7czWm2LrgFQrUYVEhYSZc+Y+hdfJyEOxRGPK5/BkGAY/kxIoikq7sIN8
ixwsTO4cK6UWmOiadQSEVGEEOKKjOM/R/F1p/DPMzheI8gkgmujM8/zu1igIywWM
qJuETC+xXq+N+zVei7TDOaVMrHp62HIhVWWKR1McJKqm0bsndpNGNuoQbfEiZghB
9pZzfxK9bPM6YkdmaPBnzZ0IZZ1180cbOOPbHRVKbi6d8/YJPh4A5Vl1P8Hyi7lb
E1qni97FpVR65n/FjbbYgX1W442wd2tz0uVWkHTQI+5OpqaSsHqXHITegNR8dSPV
k4eeSWss161JQxjlGc+1j9uMSgNcb3yO0e9qH4jZzTZ/d6pJ88uQ6CvEsJSzOvay
j0b3bmIOmUjfRrtdh8gV53iqGBpPnWiqt4qxkybsbcR7gqOsDIxhjOvSZcocr/0Q
1mXS/U+ghaMwwr+96GF7+bDJgB6pZGNRsLgpOUx+dFvDyTSXWm/4P6VzUUhS05du
HjyOnzuT2JyPT9YYNYCEsf9Bumh9gK8L7ZD0O9xMvebLlXYqot9HrkEBB24m7kHM
5dzC+ma0V0gLR6mZ8BFw
=tCHN
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
