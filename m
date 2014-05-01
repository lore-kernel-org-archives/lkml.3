Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaEASqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:46:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54283 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEASqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:46:03 -0400
Date: Thu, 1 May 2014 10:55:01 -0700
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
Message-ID: <20140501175501.GG3245@sirena.org.uk>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
 <1398694047-28596-7-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zgr1mbP1ee4HJQ5m"
Content-Disposition: inline
In-Reply-To: <1398694047-28596-7-git-send-email-sre@kernel.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 6/9] ASoC: omap: rx51: get GPIO numbers via gpiod API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zgr1mbP1ee4HJQ5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 04:07:24PM +0200, Sebastian Reichel wrote:
> Update the driver to get GPIO numbers from the
> devm gpiod API instead of requesting hardcoded
> GPIO numbers.

Applied, thanks.

--zgr1mbP1ee4HJQ5m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYopyAAoJELSic+t+oim90ZcP/3O5HOJYq4KcSyVaAEgBATDv
v+YXU7yPQa4/WlXy4kb6pYDuR9GInwTMQTsvNA7UwePX4kx2yuIDuf2lP8bYMIKz
OAr8j0ePJ3Vb4GUfll8s4ZW3wtADj1d6rPnXJ7UV2ONIoZIJgEEn6bFetS1yBOxO
dpkhdHhYYXeIE/CitU8agmZegBI2dvIpEbkpLMvlMp2L19JjWuM5O9UWkHGZj6FX
KJxFIyd4QNZQ/+iw9xsddvq3hSi07vQ168kENC1x+0Nzov1Hb8LM1DEv9vCvX5JV
OqZTRDeDP6RZLJmqadfq1UZZZ979DK6NBdphMaWbRBEZhIZmmkMAoC1C6hf4KDIs
mjtGpqa799YQGsc3IhefMP7X/kvlBRNnpJekttjP6BHdTaH+aC5lgrxEE8JKjA0O
EbEGfIDwBPnI67EpKlYZq8RVBOzZ6n3HKsUBjaAEk6Bn+a/g4MGVGgXkVM5qlXJY
YbVgEgBJ5YFimz+RmxvA07vSpYJvWQMZutpCCRi0DjXO/MwbWEgjWr8AY2kY9S+3
sGurHBc5MuPhGOW8LrbVonYyoaugTSdzrweHUEIxDOw1VFv0U87oU4RAoEjDyuMl
hIqav9ui9igAOVjj8qOAGldnGg3FvInYgwk77vhwdka8nwY5WRbyT71MJ9BWRvmN
BcKWdpcLqOcCC8lnEeaG
=qJ/Q
-----END PGP SIGNATURE-----

--zgr1mbP1ee4HJQ5m--
