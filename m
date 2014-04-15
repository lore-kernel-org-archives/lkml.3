Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaDOMYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:24:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33901 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:23:58 -0400
Date: Tue, 15 Apr 2014 13:23:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140415122332.GA12304@sirena.org.uk>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
 <1396733753-9820-5-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6nDKxlhctiV7bVq"
Content-Disposition: inline
In-Reply-To: <1396733753-9820-5-git-send-email-sre@kernel.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] ASoC: RX-51: Convert to table based DAPM setup
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6nDKxlhctiV7bVq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 05, 2014 at 11:35:52PM +0200, Sebastian Reichel wrote:

> Use table based setup to register the DAPM widgets and routes. This on one hand
> makes the code a bit cleaner and on the other hand the board level DAPM
> elements get registered in the card's DAPM context rather than in the CODEC's
> DAPM context. This fixes an issue with double prefixing of routes.

Simple patches like this, especially ones that are bug fixes, should
come at the start of the series to allow them to be applied first.  This
cuts down on review if multiple iterations are needed and allows bug
fixes to be merged as such.

--d6nDKxlhctiV7bVq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSTBAAoJELSic+t+oim9GtEP/3Gki0Cbu9rO7xov4AJpfUZl
JvG9ZwW9XlKsd1ThUErY6pcJdNubUAKU/MUL7xFO1sMbhy5ypAb+/qgTklaw3Xjp
p3fHG6J7swBDRbFrmIablZUBucHG1+oaOHls+jPX5Dpip1OQoeB5bsIESwfjijMq
/RxcuF7e62ImucMDGxXbZzoYKFrhe/qaFXEIIrXA6hVdExm+SOSf1MAGnb5Q+f0H
THJ0/N8KyAd1nZtWhPFO7h3Kco9cUULT9UmRfxRR3D5tUnuJbvE20xIJSkP4GktX
0fdZLAf9Jk+a4y4WXyghbRCIrYU2kOz1D8ec0dRC8ja3HENdkka8zVLuRE+7mSwW
QFz4iDrKQvv5oVmJdhAgoyoiHTGtNoFFmPfdfQ3mM4rcJYte18npqBwoUwR3rkIU
/yLmy+8cUI2fhCVgLVkQQ1QJsuMPwuwLe+1jgdpBI+cPQqCtnDRb1F2jXPH8fxP8
2rtZx3/ja9X2LgKotkDB3CFuiVrNyLrGfTuQisBg8zHTxtHe4O2EmJTAsXjexZvQ
tOxOe/R47+TWHLaoDabop47pp3Bc+KemMQjZoptydgYjjHsdfujF5B/0xkFOZq8S
gEQSIiJgvqaMmeYUMLD7ZSYT3Z3E+LFDPviJlc+vqdWIhVCaJq2Jde151MF734gc
dLPKh9wE0DMi2HQIJW7r
=+tMV
-----END PGP SIGNATURE-----

--d6nDKxlhctiV7bVq--
