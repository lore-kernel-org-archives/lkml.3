Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3LFOem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:34:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58473 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3LFOek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:34:40 -0500
Date: Fri, 6 Dec 2013 14:34:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org, tiwai@suse.de,
        perex@perex.cz, linux-kernel@vger.kernel.org
Message-ID: <20131206143433.GH29268@sirena.org.uk>
References: <cover.1386322845.git.b42378@freescale.com>
 <bed76b8bfd2d4ed9739269657cd55e4a81b65403.1386322845.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yuedfix5hmtMJRO4"
Content-Disposition: inline
In-Reply-To: <bed76b8bfd2d4ed9739269657cd55e4a81b65403.1386322845.git.b42378@freescale.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: fsl: imx-wm8962: Grant hw_params/free()
 permission to control FLL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yuedfix5hmtMJRO4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 05:47:43PM +0800, Nicolin Chen wrote:

> +static int imx_wm8962_enable_fll(struct snd_soc_dai *codec_dai, u32 sample_rate,
> +				snd_pcm_format_t sample_format)
> +{
> +	struct imx_priv *priv = &card_priv;
> +	struct device *dev = &priv->pdev->dev;
> +	struct imx_wm8962_data *data = platform_get_drvdata(priv->pdev);
> +	u32 freq, ret;
> +
> +	if (data->fll_lock)
> +		return 0;

Don't we need an actual lock to protect this?

--yuedfix5hmtMJRO4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoeB2AAoJELSic+t+oim9WLQP/39fJ6OQuo085aTYMfcFvCT8
l2hRSP28s9lCYd+8OCPIOJgPkxu6NeSpdlSWrn+nl9g2/wbI7YixRsI9uAVVq7fy
7NtSwvpgekUmvzWEFWS7EWSUOeiPIn1bZ8E5Rjc0NhGvLlkX2Acch7jLxek9xTsE
Pc9hx9hPiz2ViXh/iVqC5H7w7R7WyBqyeDnlGLVagdUdc2Oa5xvMQuwJaM9LTLTw
g6w1VBd3P9KLv8/jirYNjHScv48ZKnQLbkawEMb9bpLt7zL8lYNhGr7uxokf2A5j
hiVsRMRBIknub8G8jK5FD8csIEccminYQhvFF5PaMHZ7IauZmDH0fEVw7zVoViN8
CeVQhi4VUFzgbHqtChHS4FBv5VDyFsZ9MbizHQWtKrf3XRm5CNwLsCTBNLqNse2v
0xX/NcEn5vgEboQNF6eaBP61JzQwVTTjsRCRT4HXLz200dS7+bjBuS3jDvTZQsm9
8bNANqkgn6rOZGoOHWwB1HK2Hmv1xO/rnWSEUTNxI3MTzijMr6TKXnPDtoCJw/G2
CHlc7pKxWNz4WBa5IsJi5pWZfSYixYBCkx77II5SRAopRuEvjXFb6K5rvBPnCCiV
USvuMvatXPAPFrBRg0KJZbZ59KmSmnOqmvpJvxu1Q4dJjpJPRl4eEBQ+4zIMLRNw
ReK0ASUxhh8yLB4MWhXj
=ILGZ
-----END PGP SIGNATURE-----

--yuedfix5hmtMJRO4--
