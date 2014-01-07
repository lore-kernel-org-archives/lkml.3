Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaAGPnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:43:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48399 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaAGPnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:43:37 -0500
Date: Tue, 7 Jan 2014 15:43:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140107154329.GU31886@sirena.org.uk>
References: <1389057222-16686-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2ZSvGCaIhjYEV086"
Content-Disposition: inline
In-Reply-To: <1389057222-16686-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: simple-card: fix the DAPM routes map parsing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2ZSvGCaIhjYEV086
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 07, 2014 at 09:13:42AM +0800, Xiubo Li wrote:
> The simple-card's DAPM route maping is optional.

Applied both, thanks.

--2ZSvGCaIhjYEV086
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzCCeAAoJELSic+t+oim98boQAIP47K4LnmefewL0oCUf+dfY
swZZ1QJ/arGWFj8upNLBPUyg3hr8WR+QkVfT4CfFtn8mAKlrQFxG9jO3qVUjsZuG
H3eLGh/B0bc4FsEZELSWaUgy9T+LUm7FMF7oGQVr4B41oIyXeCt4n+m0hxHExs9K
G5zC6cKZVMrh7CbyJnbKJgzFxlIiIhz1sB2yQd18MucOnLyjgALU5UomKcSygwKH
bpV1yTZ3Ml4tU+DDgVgCk2q2obXOdD09vPMIF8G+vOk/2ARX+hj6QLP9fw/Kx21v
Rn4xBS4lyv803jPHpxn3hsAD1bmXUQC5Pc3zq0siZtQ2UhjO5cFmm+PPFAwP8sQt
tSHBaX9xQB+/UmxU4pAqupRZ2X6n74/NHsTCl7dcaHt7TogC+YYngG6KJs8Plbfj
/4vtIphsltRmEB0AGuqFP4APVOqW5Bur0v3KF3tgMCThBS5cU1XLGJH5rPvAGEzJ
mtCcMNwKQBFDLlb4UeiF7UEqvl/XMl9part5Jxx4CbdnshJD1X2+LVj2HuENTAx8
ffC6aPgPUTmAd/q9c67UiGSXmwE1Nzzj/MTTJTVHxO+z7lkJQGkOQJCZkd9mw8Bv
98+SqKtpVGRg2iVzSaMn80IFnqwBG88Q9j+LrmpQOs1LYdzzdRPlWGkxiIEqp3nL
Mg+J34Qf76zcpszRUUhs
=O638
-----END PGP SIGNATURE-----

--2ZSvGCaIhjYEV086--
