Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaHSQUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:20:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48993 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaHSQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:19:59 -0400
Date: Tue, 19 Aug 2014 11:12:17 -0500
From: Mark Brown <broonie@kernel.org>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, nicoleotsuka@gmail.com,
        Li.Xiubo@freescale.com, shc_work@mail.ru, fabio.estevam@freescale.com,
        xobs@kosagi.com, arnd@arndb.de, sfr@canb.auug.org.au, timur@tabi.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <20140819161217.GK24407@sirena.org.uk>
References: <bfed4dfd3cf1ef134dac1f114f3d2b8cedf55c68.1408440952.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zPXeIxDajdrcF2en"
Content-Disposition: inline
In-Reply-To: <bfed4dfd3cf1ef134dac1f114f3d2b8cedf55c68.1408440952.git.shengjiu.wang@freescale.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.65.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] ASoC: fsl-asoc-card: move 'config
 SND_SOC_FSL_ASOC_CARD' to 'if SND_IMX_SOC'
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zPXeIxDajdrcF2en
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 19, 2014 at 05:36:41PM +0800, Shengjiu Wang wrote:
> Build kernel with SND_SOC_FSL_ASOC_CARD=m && SND_SOC_FSL_{SSI,SAI,ESAI}=y
> leads the following error:

Applied, thanks.

--zPXeIxDajdrcF2en
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT83deAAoJELSic+t+oim9uToP/i3y1fRfHj1rQn0Iv+LEJd91
MjSO6dPrx5Bvb7AOzfSNTYpu2i3vnHiDfb/tu9/316WllJFZPf96rECTqJJAYnT0
63BM1UfkYtSR3nXB1EEa9vpKc2GJbEZthz3ONRiB8UGVmH0RHNhql6ErGig09TgZ
v6EylmP6t18LhL9rFzzZK0CpjaLAKADk59rTCqIYU+tyh3YEtQwAnqBOzsVtCfwU
SemBNPD3SkOoq8zoi1Pc9Ohc2pOgws2BSMOZDURZiU2vqNASJUIrb3Tgq7yiFqFA
Pf6xVBBZ0b3wS4I8FcWzyOnSs8PWGPTHQfUbeCqDmD1IBH6BYpTnzwS114PXZaNk
aThJnaYVEzhR5LZGCbfpfNMeDyKEXCOk99R7H7UCowBEAWBdzziZ6vz00sDLrACR
Z8pe4s0EqklPtYYBNqMu/OMR5Q5R5wJIGIrr0LiEZFs4O7vZ0rfDaqOw5N+f7VQ4
16vL4aTPIR3g2F4ehzUFldgL/Q5LdQlaTO9cGJ+x4B1Suim72Wboe0OywIeUlJXy
Sq7c+MHPHiEw/PnXrnhHvjjBV+vFx8UfR0wLyVge9QILofkccz4SiEzu9CClNDBN
O6TbXLcMnB3OsakT+qHe16dk5PuMKfIC+XUgA9DrXlKLgHt8yc+eJUQLJcMBGrmO
ZtHiCPbS2Qz3htw0LZrY
=V7E/
-----END PGP SIGNATURE-----

--zPXeIxDajdrcF2en--
