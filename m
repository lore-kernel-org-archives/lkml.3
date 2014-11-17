Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKQO6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:58:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43425 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaKQO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:58:11 -0500
Date: Mon, 17 Nov 2014 14:57:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, ben-linux@fluff.org,
        kgene.kim@samsung.com, perex@perex.cz, tiwai@suse.de,
        galak@codeaurora.org, sbkim73@samsung.com, lgirdwood@gmail.com,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20141117145717.GE2722@sirena.org.uk>
References: <1416221874-22092-1-git-send-email-rf@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1C2QhcYtVTlNtC1j"
Content-Disposition: inline
In-Reply-To: <1416221874-22092-1-git-send-email-rf@opensource.wolfsonmicro.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 149.254.181.233
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: samsung-i2s: Add 192kHz config option
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1C2QhcYtVTlNtC1j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 10:57:54AM +0000, Richard Fitzgerald wrote:
> Adds QUIRK_SUPPORTS_192KHZ to allow 192kHz rate
> to be selected for hardware that supports it.

> +- samsung,supports-192khz: specify this (without a value) if you want to allow
> +    192000 sample rate over the I2S link.

Two things here.  One is that the first half is a funny way of saying
"boolean property" (the other standard idiom is "present if...").  The
other is that "if you want to allow" suggests that this is a bit of
runtime configuration (which shouldn't be in device tree at all).  If
there's a quirk here it should be a fixed property of the hardware, if
this is a system integration choice then it should at most be specified
in the machine driver and the I2S controller should just advertise
whatever it's physically capable of.

--1C2QhcYtVTlNtC1j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUagzMAAoJECTWi3JdVIfQDl4H/0sMrAOagfVTHzLUgaXfmG1L
wtZnJo0MuhJW3QBKEh9W4vSsebAWBtFfBfGtaCElwBskwQo3Ty8Y6IxkauZRXx9y
DEMDI1x65RX7zQtYHbJhVvQi3vP/OxbFBu6KpGlChHRhQV/QDHOzq5AE5fqLzzPv
32ZrmB3h/6UsI58gx04MShrJQf4nUDEugadH7RS5nstb8sEi4/fadi1oT00vIltW
rtTjAU0sJd7YKGmrPUy2g7fjlvr8I8MpyCI1UGI1brTbnvceWqCQfL9oS2XOR/54
aPv4CdCsddblAEXj53Itac/N713LB/2kbYWF8+iPVXXYHJ511uRTwp2mRMTsre0=
=5YU/
-----END PGP SIGNATURE-----

--1C2QhcYtVTlNtC1j--
