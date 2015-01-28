Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbbA2BZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38393 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbbA2BZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:31 -0500
Date: Wed, 28 Jan 2015 11:02:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Simon Glass <sjg@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Message-ID: <20150128110230.GQ21293@sirena.org.uk>
References: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
 <1422442278-10405-7-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XPvsYLa7iS7+7YV1"
Content-Disposition: inline
In-Reply-To: <1422442278-10405-7-git-send-email-tomeu.vizoso@collabora.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 06/10] ASoC: tegra: Add a control for the headphone
 switch
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XPvsYLa7iS7+7YV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 11:51:04AM +0100, Tomeu Vizoso wrote:

> To be used by userspace when the headphones jack is plugged in.

>  static const struct snd_kcontrol_new tegra_max98090_controls[] = {
> +	SOC_DAPM_PIN_SWITCH("Headphones"),
>  	SOC_DAPM_PIN_SWITCH("Speakers"),
>  };

Why is userspace doing this?  If this is supposed to be associated with
the jack detection I'd expect us to be doing this in kernel.

--XPvsYLa7iS7+7YV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyMHGAAoJECTWi3JdVIfQQM0H/iFNJ3INZXCih/67wRAUDIct
2+j4H0gbnVoL2LBC/A8JEvyFSNO2+dx1yb+VGRYJTyoeVzbTVU5Wl2hY6OzLuRLn
5qECrRW5h5L4PLetqlwy5vHj/7y9udq91PQts0lvx/C1KIwPx5CdqY3KzGKQ192F
20eo/tCVObuAwr+AuVlefp54GX0G5gEFiOGjszenK99uD1D4w3pbUZuV4mwgZXDl
Et0vKqMsTcTD98uBuDempyTnKZUdaKS8WdeNcTuzYPxr5TZsBybyeIWwOrsIWw5o
3RZuCgEvBYhI8LpSRS3TA6esruMP1WC1DnLSw4WZdFz/Ooo1pjDkGjGKwLtKiWY=
=IrM6
-----END PGP SIGNATURE-----

--XPvsYLa7iS7+7YV1--
