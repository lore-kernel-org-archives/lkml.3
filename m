Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3H1Jx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:53:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37206 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3H1JxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:53:25 -0400
Date: Wed, 28 Aug 2013 10:53:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Message-ID: <20130828095315.GG10783@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
 <1376243970-6489-10-git-send-email-tomasz.figa@gmail.com>
 <CACRpkdZd+LJeZdSjsD6OCLOnZ0VrDg0aa-e163NXsw6ajWf7rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bfHXWC0AWsk5KHuB"
Content-Disposition: inline
In-Reply-To: <CACRpkdZd+LJeZdSjsD6OCLOnZ0VrDg0aa-e163NXsw6ajWf7rA@mail.gmail.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 09/18] ASoC: Samsung: Do not queue cyclic buffers
 multiple times
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bfHXWC0AWsk5KHuB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 28, 2013 at 09:06:27AM +0200, Linus Walleij wrote:

> If patch 1 thru 9 are uncontroversial now, maybe Vinod can apply
> these for v3.12 so we can get less noise and risk of collissions
> in the next merge window?

Patch 9 I was going to apply to ASoC towards the end of the release
cycle - it shouldn't depend on the earlier ones as ASoC isn't using
dmaengine yet.  Holding off partly to run testing and partly in case
this ends up getting applied.

--bfHXWC0AWsk5KHuB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHciIAAoJELSic+t+oim9fJ4P/j2sUwQRjMcCBS9A+6sCysTp
N2dRUyj6YYqlhYZhCzYVvM7Gs4fENfFbsVBfr2XJ4uct8YooUJ+L2Unq0h33ZHGf
4/Zelr4XydWS1T1xXljpU8qt1IulOxGIynADOKZ3craKsnqbpVI0tBk1yG0eLOYZ
Cjkn8bSMTvme+TMPN9ecPEjik+o8gy/VBDstx9D8RiVPTfDOq2ZhMRuPzJ6Zsmce
ZSO5sQI/KeoF3vajH0oxsw+U5Q6ziKuYVrYnBGmO38qEzVIGJNo2sreGup9bzOR/
l9DFqS7MGOeNFIv7EzW2ztjj30aJ8XlnYyMc0cguMN2/pQMtq+27nADiwOnM3LOt
fk3IusueuTc8Gn+GFnK37UikdBmn7EzuKl2RV7xWjN3V+SI6409Ei3Jp4+KTyk2C
GpH4bG1e4/6/pzWdEPj8AcPL0ugpFXCN8vN9ZDQru2CTEul6YHORbP0MPBqYflzg
FSOmzLmHCNAl3qoRhRF5aHvmnOXP05Pd50Mn46F2GR0xo3qYyY+7Y5OAGsCv6WzH
CsMy0Ak2GUbW5RXgTMmiwyu1MjRTpeAPhcJdfuODnylAiEfyKwCxCwEH89eqYnEw
tHrhzOkONwarQwnQ+nY1DcZAwiIAgDMG5ej2MsSnVW/ChRh1zZtJcBb+2Wp+f+Nm
Kaex90saPSjyXDzm4d/V
=KUZC
-----END PGP SIGNATURE-----

--bfHXWC0AWsk5KHuB--
