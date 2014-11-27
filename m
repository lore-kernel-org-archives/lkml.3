Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaK0LAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:00:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40643 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaK0LAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:00:46 -0500
Date: Thu, 27 Nov 2014 10:58:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux@arm.linux.org.uk, nsekhar@ti.com, arnd@arndb.de,
        vinod.koul@intel.com, khilman@deeprootsystems.com,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, chris@printf.net,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, dmaengine@vger.kernel.org
Message-ID: <20141127105815.GE7712@sirena.org.uk>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
 <1417084891-17990-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PcDVawgyoD+Fem/v"
Content-Disposition: inline
In-Reply-To: <1417084891-17990-2-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] ASoC: davinci-evm: Do not include edma headers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PcDVawgyoD+Fem/v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2014 at 12:41:29PM +0200, Peter Ujfalusi wrote:
> The machine driver has no business with the underlying dma.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Mark Brown <broonie@kernel.org>

--PcDVawgyoD+Fem/v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdwPGAAoJECTWi3JdVIfQ7MAH/RnpLGoXRwTP9XeiV2TTbYT5
tJZBqFx5ZrFhdJICHzRhGTMnbKKEcYZ+zjVIs5ln6jEgn/YhOxAfR1lfwNUs9T+/
m3RZqF1ZBHPHWP+dLSwXSsdzZNxSO1G+4sx/+GtmXMeUZLODJb9ZJguMSDd7I+f7
jYH41qW9Y5/z7yp3Oo0Jx2BDwQZA0KmJ0jffN7XGmXMd+/fHUWFLknujfeq1XPkD
VDMElbg3PMqLKYLXNE1yCfP3jb/Sn50DEyyiotRFNU5pyU2vp+0nmIeygtRsukmE
RPdeQI6UAn/Wdj6PBVVhx7DbvVOjdIkwfdopP47RQolnFtf44Q9wmMtJwCaqNVM=
=fVaF
-----END PGP SIGNATURE-----

--PcDVawgyoD+Fem/v--
