Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaAINaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:30:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50002 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaAINam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:30:42 -0500
Date: Thu, 9 Jan 2014 13:30:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20140109133030.GM31886@sirena.org.uk>
References: <1389271441-21046-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1389271441-21046-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SgAYzkuV7cEXWXHw"
Content-Disposition: inline
In-Reply-To: <1389271441-21046-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: wm5110: Add controls for headphone short
 circuit protection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SgAYzkuV7cEXWXHw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 12:44:01PM +0000, Charles Keepax wrote:

> +SOC_SINGLE("HPOUT1 SC Protect", ARIZONA_HP1_SHORT_CIRCUIT_CTRL,
> +	   ARIZONA_HP1_SC_ENA_SHIFT, 1, 0),

Boolean controls should be called ... Switch.

--SgAYzkuV7cEXWXHw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzqRzAAoJELSic+t+oim968EP/3ZP5zUGUktYrjG563kQtTz4
+K6YRZH0Nyy3meAwCu/F2asYsz8Xax2C407KS/Y7z01UkvbgJYv72YuFqF7hiC2d
9HcBLBSQg8KRSRRI6ldmq5jQX8Un3bB8i7H9XwYWgr8VeE14dhs4SckrVAw07c6A
1odUUHzJdEv5j/sXUiY1zz7pCfWpKKlVefaXVNFYmTTYSSPFC9OtR1/43Ah4MW/1
5Z6xj5glkw0b1p4P1p5gg8DNOtRbnqNh62TqDm0goUntNVg4A5bTcgBHV5yJRSAv
MzU7Ln6qIsqwNSMbC2XwW01nAXQlNHvl0HK3tR3h2Cbg7xhm6YXzTsoAMZPWKSFQ
U2icMp1YSDgK1VTjksmtRtR5bnsxJGsOZIaofWDnbUvowH8VJjmuxbS/uHiRkNaQ
pMGkS5YQz+yYk1weUT5G0maLtlsx0mfBKljjxGZeF9h4ye0CMxjM2LIZ0vDwjtKZ
qTjdmjo9dnk5XL3wv4VJY/0SSL0tSOXBGhOv8JtVSsr+V0xMhXHejvOdWdrs7B3O
Fk7c2nZLZfbl9TGxahg2dCOqIzAhqO0TKJUY3JpGwJtVoP+RXJu9S5cqhaxPSPeB
1OxGZGXZ5gQKo70V/WaI9549tqFKryQ7nxSHbMr6/XONackkwL7lvhhPLTyZULG0
XB8Rspc+XOhn20SraQP2
=I7qG
-----END PGP SIGNATURE-----

--SgAYzkuV7cEXWXHw--
