Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaBDTVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:21:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35471 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaBDTU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:20:57 -0500
Date: Tue, 4 Feb 2014 19:20:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mmc@vger.kernel.org
Message-ID: <20140204192041.GW22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
 <1391529538-21685-11-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/z4P6UMu7uOEsbeQ"
Content-Disposition: inline
In-Reply-To: <1391529538-21685-11-git-send-email-ulf.hansson@linaro.org>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/17] spi: pl022: Remove redundant pinctrl to default
 state in probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/z4P6UMu7uOEsbeQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 04:58:51PM +0100, Ulf Hansson wrote:
> The driver core is now taking care of putting our pins into default
> state at probe. Thus we can remove the redundant call for it in probe.

I applied this one too, as with the last patch it looks independant of
the runtime PM stuff.

--/z4P6UMu7uOEsbeQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8T2GAAoJELSic+t+oim9MWgQAIJUzM6v/rxDmFZOtPEr9BkH
CWEZ2pLg5tHvcD3YkzFSJaIXsHXpru24Qp7v1zVazJ0ZBDKuvcjMkTERbTvwVVl3
A+3d52Mi5SjEDTm6JnaOlta4PsF94HG4ofHKHhisPmK88tOHlrWvTVKpVw5o+Rxu
TsaBw5hy+fx2qRs3H9gVOlBaTCYrYC93gI1R5IcI1ovE84JJaHCc8ib8UiQmWxRy
G7QPDrqU+zi56yPS0TT9mEYUWcuT+TpDWXUJUTyy59H15P7NVsPit4afpFDNL9GO
koSgDNJME7BB0ZoC80xcEq0HbDqHmZeoH8hyeg5b57TlURbxD41wpzlMdZni0GFt
Z5KidIjR++JLERPiWyO782zAcAsP2MZ15gEbL7FgUB8JaOWJYA9skDfM8owX8UXd
TSk/n1kF0uq+Yn8K6t7FWMwAHNbluxCpsjyd2QI/X8XHkaiTKdUGazjiHbSblL2A
m5Hz2M4bgA3PZfXqvofZuDR6o7zIteWRFk1X7LOUDwuAOM4g6ipfGHYs0YlUYeAq
1nARTNtoOWVuSZY2tkxwaO3l1oLQkuk0d/1y/HqiEkmA3qeWi+LuRhJWlmieZVJU
vpSFPiV1XpTFjLEGcTzbOfO/tKLQxZEwufBVdzjYQpEsWXKAjlyREaiIdHLWNtXL
eOaQw3KUxdu0rORzgEdh
=miYw
-----END PGP SIGNATURE-----

--/z4P6UMu7uOEsbeQ--
