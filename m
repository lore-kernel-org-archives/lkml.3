Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaKCM2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:28:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35292 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaKCM2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:28:24 -0500
Date: Mon, 3 Nov 2014 12:26:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        Li.Xiubo@freescale.com, moinejf@free.fr,
        kuninori.morimoto.gx@renesas.com, jsarha@ti.com,
        Guangyu.Chen@freescale.com, dgreid@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20141103122633.GH3815@sirena.org.uk>
References: <1414812138-6178-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKijDXBCEH69PxaN"
Content-Disposition: inline
In-Reply-To: <1414812138-6178-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: add "invert" property for detect GPIOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 01, 2014 at 11:22:18AM +0800, Jianqun wrote:
> Since hardware may invert detect GPIO of headphone or mic, add one
> property to support software invert.

Applied, thanks.

--gKijDXBCEH69PxaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV3R4AAoJECTWi3JdVIfQ/YgH/3yuttjMe5JiHreTvvv4Ykzt
l50OzgSST8B1AiR9c3PsEpHIq+kBhNUiid4ZBx6gqHQ9SBXxORYmfNV/+BGeouJx
k+k7zkWjT6kGDbp/i9rkOnGb+rJGMhvk5SQPvFimHEj3QAYqHOskpvL1xuXRHhF9
BSDXlIz6AtQXfYqjwUnm+EZvuKZIAq+eV2MgIgexpOJufRhIZw0qqwEANQSVzgvV
G46eAtzQmFGCUxFOqYnjOvQt1i1yDVJBILeIdtpTAETR6r+F06SNs6GgTtqFSb26
tJzUfD/wd+DeXgSom3hnfFogqZ4lAQ8UTogJc+KjjZO0AjHaEcjtjrNDFp7Q3Ko=
=30Fo
-----END PGP SIGNATURE-----

--gKijDXBCEH69PxaN--
