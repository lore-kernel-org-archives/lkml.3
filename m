Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaA0TvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:51:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60214 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaA0TvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:51:07 -0500
Date: Mon, 27 Jan 2014 19:50:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com, rob@landley.net,
        perex@perex.cz, moinejf@free.fr, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140127195057.GX11841@sirena.org.uk>
References: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
 <1390549386-4702-4-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A3ZnGbl6n9tZ6+mF"
Content-Disposition: inline
In-Reply-To: <1390549386-4702-4-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/7] ASoC: simple-card: Add snd_card's name parsing
 from DT node support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A3ZnGbl6n9tZ6+mF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 24, 2014 at 03:43:02PM +0800, Xiubo Li wrote:
> If the DT is used and the CPU DAI device has only one DAI, the card
> name will be like :

Applied, thanks.

--A3ZnGbl6n9tZ6+mF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rieAAoJELSic+t+oim9klYP/RUrRvunCnnl790+AAcNfMdC
tR9sTPqz2VJ6RrHhpYPaTIsenzlEnqDuYaf1+c0d+OHSJRyXC/I12+QOtK18iznR
9WMmNGMKCXxgDsXQ8Dbp5IQuLTpbwYRt6jYEQ0ByJIJ1DlOZz3r52VifLJesK86l
AgBwS8LngVHc5WHIfqkggKtQIgWdW1qaZZp60IyOBLDHWcIO/argd/sD5szwOfzb
+CcRJxNi7FhaM0t9LLJIa+1wYLqgLbfoquZHe7/tSSIttvfV+QYSiBzA55NIiLYv
VgymlmociIsSnmOy5lpcNVs1vDqkPEEZLEUiOoFrXju67hm7NvVo5yvGABRBBvIU
bdX2Zt/mmo1y46HmTVkb0cw/6MaSMNeHF5MotLEXtBFTWdL3gGvhLWTaXI5e3ukd
wC/cjvNAf587NUgdjNkjg37zZeyZimo3DZk0IesVbuSGYUvLjXNC77F9XakYBqAH
KuA/zt5/A0wNwmfucDSruaeJ24p9nqmhocHu1wCWMLOBt9iAl3Q283CVyJNqI3+n
gJ6l1rbZofpllD6G7+BNIeh8H0QbHWinxpF3hldz/1c61wNn4iGRzQKnfRBhARBb
zTQTMQyxfkblZ1WMNemcKCxjs+iLsbymUBiT5t+CdpRltigxncgD6dx0MTUhmVWK
/LkIMliLtyX7ZGHhaE9m
=u4Qp
-----END PGP SIGNATURE-----

--A3ZnGbl6n9tZ6+mF--
