Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaEASnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:43:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54230 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEASnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:43:41 -0400
Date: Thu, 1 May 2014 10:55:18 -0700
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
Message-ID: <20140501175518.GH3245@sirena.org.uk>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
 <1398694047-28596-8-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6ZcLte273om6Oiqd"
Content-Disposition: inline
In-Reply-To: <1398694047-28596-8-git-send-email-sre@kernel.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 7/9] ASoC: omap: rx51: Add some error messages
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6ZcLte273om6Oiqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 04:07:25PM +0200, Sebastian Reichel wrote:
> Add more error messages making it easier to identify problems.

Applied, thanks.

--6ZcLte273om6Oiqd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYoqDAAoJELSic+t+oim9HkQQAI1gAaxPhXluopgD+/MZ3fsb
fooIXqgVaFpm8TdgzRdq2sz4z+/dqNy+u4d1ISD3s9I6qMP827s68s6sO9ut6f/R
HPa1QrTtxJzi5zrLuOzcRhligXvmHlZv35EhcVbyDNZrrws5rL3INtGAB9+JXmkv
DvARFcbWGmnxVWK76y8ZaOi7EIGSeYvmdQXOWrr/hogO8D3P6DoEr8y0hqbpPldu
H0XWhf8/YL1Jtm0cvvMmzGelgL8aM9Bdfs4CjqDnezfYV+8w2Jn9LkHHVZpjcFd4
A4O5Ee6h3LG2ZXnIpmirwlZ/pqGd+AGI8Fq6ZwlnIHCQEep14FmV5bfNW+bV9Umf
INAZY+zaeqehU7OT/h0CNwmHCBetfRWC1ndTSjSXZndxlkT8B4CpFmf4UE6KI/Ng
F217Q6lknPNAVZW+jpLQBQJbqHIMvdLZvFVTpdIlp9KTgwfOBmrW/+veE5AGlEsK
BxRXuKvw0CpAFRkldGAGZpbn49GLDNqRAGOwr0Qa1xfeLpHPybXr6xSru+IhIeU4
TQdpi05bYyRkEV1cFVquruatuCW+F3P3AZ0a8xFrAZtUjZsu6LrO2ou7qkLcR+Rb
+mk1aOIBsPi/RZdIYbBe9GZIjOGa9Qe3U8gS5zNBlkM4QkA8xXhx5zH8ofGHypUD
9GmPI1uO02sbUftRsUam
=HVzp
-----END PGP SIGNATURE-----

--6ZcLte273om6Oiqd--
