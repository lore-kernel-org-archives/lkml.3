Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbbA2Bc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:32:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38407 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbbA2BZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:52 -0500
Date: Wed, 28 Jan 2015 17:15:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Simon Glass <sjg@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Wolfram Sang <wsa@the-dreams.de>,
        Lars-Peter Clausen <lars@metafoo.de>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20150128171527.GY21293@sirena.org.uk>
References: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
 <1422442278-10405-8-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dYleC2xWAd0KQmG+"
Content-Disposition: inline
In-Reply-To: <1422442278-10405-8-git-send-email-tomeu.vizoso@collabora.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 07/10] ASoC: tegra: add sink for the internal mic to
 tegra_max98090
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dYleC2xWAd0KQmG+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 11:51:05AM +0100, Tomeu Vizoso wrote:
> This is used in the Tegra-based Chromebooks.

This doesn't apply due to the dependency on the previous patch, and
also...

>  static const struct snd_kcontrol_new tegra_max98090_controls[] = {
>  	SOC_DAPM_PIN_SWITCH("Headphones"),
>  	SOC_DAPM_PIN_SWITCH("Speakers"),
> +	SOC_DAPM_PIN_SWITCH("Int Mic"),
>  };

...it's not clear what the purpose of the pin switch is here.

--dYleC2xWAd0KQmG+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyRkvAAoJECTWi3JdVIfQLwsH/jZvWuboYO0fkeZFnSj8VLr2
5B04qTlws5iCIbceSv5B4cCza4fgxQObaceeCiVx7Zv+bD+hLakwV1UTvmpcOy4C
7qWMLtO3QJxqmcL/hGreLWobldGdooht/y+wfvehWqJ3ZGm8evJcbHYfQm92ISQE
TzaMfQFWtkWjbUbbMVxoZxmwyXEbRTiqQ2A05RlhLdV4/M7Ov7NGSs7kf9AAx1/I
pu4vkcwjCPI0D9DzWPuy3DPToA1ybhyQTEuuk1PUMDefyxII5xDRjaR1NtGPBw/0
hKU/bKdf1WCwq9Rqh1PoPR9MKuVk3MdI7IkcpatO94KZOKPulTFrpGrL61H5pV8=
=yywg
-----END PGP SIGNATURE-----

--dYleC2xWAd0KQmG+--
