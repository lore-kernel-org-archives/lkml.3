Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaEUXUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:20:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35740 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaEUXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:20:43 -0400
Date: Thu, 22 May 2014 00:20:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        lgirdwood@gmail.com, sbkim73@samsung.com, kgene.kim@samsung.com
Message-ID: <20140521232026.GZ12304@sirena.org.uk>
References: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
 <1400642540-24375-2-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z8HeKkXK+YwaFz6Y"
Content-Disposition: inline
In-Reply-To: <1400642540-24375-2-git-send-email-tushar.behera@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] ASoC: samsung: Use devm_snd_soc_register_card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z8HeKkXK+YwaFz6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 21, 2014 at 08:52:17AM +0530, Tushar Behera wrote:
> Replace snd_soc_register_card with devm_snd_soc_register_card.
> With this change, we can delete the empty remove functions.

Applied all, thanks.

--z8HeKkXK+YwaFz6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfTS3AAoJELSic+t+oim9bMMP/3PXJ4O2W+8D+lV0FfY7yWr/
D2wVUxBYnHeSbeU3RXazcDDt5pOkl6gn8KndR3h/FdaXXZjqETB6RIYgLauxbpQ5
MWMkwptggMnNSxGZMg31tUMAjUAqpvebtsUwfNVWpNlPyqf6m9OLl72sCLwnxsws
G4gGjx7fwCoVlACXRcVZId+DM4DWGM91ad/NRsWuQm52T3Mi41sZJC9EKeHTg0y7
R6ChVmwjcR9JYD0GkQ6LUKxLlSCu9Nhc7Vk+2ibgoTJmxqaM1SeSnciN2XCQFgDG
onPjmJuurnrD3KCy08uQaP9mJAMSTFpF9bQXdktu8twIdiOnvd7VPQMtbp4iI197
ICWgLj7dku4jhHM5Ahuu6v9hp4dIl1EArNK48xC4fzm4Z5xxwFS/uROwEuk+iGj6
X/sBb/pZJhwOrkPuOXPJvhImoxMFKvBILeRLJXjHNhkLjUNdfQOWPJgs2s3c3jJx
OQth3wwnre6aISHtm9x8m6ACp5C37P3auFNrKbkY8CGd1xrtoxDI+QM0r7k3tjL9
dR3RYm2EQtZ4lVFnI611BGbsVTJcbFAIvgpWXAzpDufBikmrOy96jvVC7KJ7HNm6
zXoxtX/toB0z/zNaZxhjcrFidBsyAHBo5x397qLx3mRejy9nZfIZEM5J8taB4Cf9
1lcOKbquMnT350DH45gN
=SRMu
-----END PGP SIGNATURE-----

--z8HeKkXK+YwaFz6Y--
