Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3LQLSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:18:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40150 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQLSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:18:45 -0500
Date: Tue, 17 Dec 2013 11:18:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lars@metafoo.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131217111816.GN3185@sirena.org.uk>
References: <1387264600-14225-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oMYUQGQaTbnds07l"
Content-Disposition: inline
In-Reply-To: <1387264600-14225-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dmaengine: Add config parameter NULL check.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oMYUQGQaTbnds07l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 03:16:40PM +0800, Xiubo Li wrote:
> Because the "ASoC: dmaengine-pcm: Provide default config" has provided
> us one defualt config of DMA. When using this, the config parameter of
> devm_snd_dmaengine_pcm_register() will be NULL, so here we need to have
> a check before using it.

Applied, thanks.

--oMYUQGQaTbnds07l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsDL0AAoJELSic+t+oim979YP/jeJcXPbJHMfVQngwCz5l9rt
vGK27S1M2fDu2S/RCD5l2GUioc7iuz068N8K96/CHjbsv3kazotaPgK4G3KCRW9G
HqbdzXV1DW0taqhdKFOAEjwZwMPOW//i6I2+DSiRdtN9wqPDoRieM20OwUZTOgeB
HZHiOH42YY5p09AmJHCW87NFWAvGcA5xT8J4btKRtG+sxM9Ps0EJRxZT/a3MvgrM
Oc1cgJTKsVWvZUDXAmepvH7ZgO14nKodfoUQQP4SNUUYSPfrtStMzeBVck+GuX7B
o/0LwAYY0Q7qf5H5Nmv/K6CsUPm5lBg/tRt9LNqXj5LP2wOBOo80bYUS+P+XMIq+
TGnJy6n0ydZBriR9wMRurWhZjHqd48zqabF2UVZmdgeR6RRToDlJTexCgpmAsMj9
UNozTqdnVd2n7QsdPLAAq4e+27jlMKDRoHw8vysr3J4Z2wVWrpl64XLQNyH4xux2
MIOIc2EDcXsZGVt2NfArkhyxooqDsbVkcpz0uubdLJVOLl6pIs8xrkcpyVQbSd6g
W/gptQKmh1GSiBDijO1a0RKLPUD4aq7rMdmRfOEc4Fi5FUQilmPUjerqdKDIxKs1
fFBpKA76y4mLeENvlGnTysfnAvS1RsJhdEW2up+hfv7+uGfZwWgez/6433FYtNHW
AelZ/XjDXKazQXdgcc9C
=8huy
-----END PGP SIGNATURE-----

--oMYUQGQaTbnds07l--
