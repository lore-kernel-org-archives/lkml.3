Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaBDTUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:20:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35463 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaBDTUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:20:11 -0500
Date: Tue, 4 Feb 2014 19:19:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mmc@vger.kernel.org
Message-ID: <20140204191947.GV22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
 <1391529538-21685-10-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MPRXw8klpfH35tNR"
Content-Disposition: inline
In-Reply-To: <1391529538-21685-10-git-send-email-ulf.hansson@linaro.org>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 09/17] spi: pl022: Simplify clock handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MPRXw8klpfH35tNR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 04:58:50PM +0100, Ulf Hansson wrote:
> Make use of clk_prepare_enable and clk_disable_unprepare to simplify
> code. No functional change.

I went ahead and applied this since it looks good and seems like an
unrelated cleanup to the runtime PM stuff which seems to be where the
interdependencies are - thanks!  It's on a separate branch with the
already applied change so if it does need to be cross merged we can do
that easily or even drop the branch.

--MPRXw8klpfH35tNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8T1QAAoJELSic+t+oim9k/EP/jun2k08R/PDUwQfKQMs+6t1
CQWJS80GC/9KPA9n+VqvK6XKB1Ld7kLcHDYgnwD7v2OlxtntgLSGuA9NR1p+H1Kn
YUBKC/pyOhTzbyof28TZF3sO2uM+bNmXdCKX9YtBy7mukVmGPjTmKD2WXWnz+/I6
xdddNac7ORKoVRwIFAIUGoSr4wHYxBSlN5emUEjWd0ARZPaQja3olmhcLN/CImx/
QBkRSe+pue4V+mx2OHMOLMdXBxGr3KGHQe6IQ4WJGZrzwpKF3mIXwgWKNaPGQQj3
2Hy97H6t2naaJMryCwZnunTUX2/YIXryV9qY0mKvO4UTJ/P6hjICdNQXHWsaJicH
TspgDBE0DX5Wf5jVvNMB+7Bc8E66ew1Ec4VHy0X56xmQ+NsgmweXmgsZZn9Li00L
iRUc0ozMfxvyewymM1Ma5KzZeywMuKuf+Xu14ZAI/NEqGUpWrX9UV4jCpwTNJqXO
t28WSZzCkJmwvuQfoK0mKepV1JQBcVgUzh2Xr9uRdd3fvqFAH1e9lURpiSfyvHha
vlo4iPtTyl7PpMbc79AZ0OPqF3eIjDZqDM+9pPkqazx8ec/tK8Gz7HxQMGSkgiYJ
pTT9QQ0PsyGLl8EGYzM8HBFBX4Kl8JEus6hAoXnDwyxM1x/ll2Jmc3TUTUDaATOC
MsQgnFyceoLVnKmXe98p
=y8go
-----END PGP SIGNATURE-----

--MPRXw8klpfH35tNR--
