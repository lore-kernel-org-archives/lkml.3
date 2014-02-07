Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaBGQ1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:27:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38285 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaBGQ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:27:01 -0500
Date: Fri, 7 Feb 2014 16:26:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140207162649.GQ32298@sirena.org.uk>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <9ec36c0633ae8291267be6802a34a469a34ae292.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <20140207162504.GP32298@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/OC9VIUhC1tLvmgX"
Content-Disposition: inline
In-Reply-To: <20140207162504.GP32298@sirena.org.uk>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/8] ASoC: da9055: Add DT support for CODEC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/OC9VIUhC1tLvmgX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 07, 2014 at 04:25:04PM +0000, Mark Brown wrote:
> On Thu, Feb 06, 2014 at 06:03:09PM +0000, Adam Thomson wrote:
> > Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
>=20
> This doesn't apply against my current for-next or v3.14-rc1, can you
> please check and resend?

Ugh, sorry - it'll be due to patch 1 of course which I'd skipped due to
the MFD bit.  If you need to resend it's probably easier all round to
just send the MFD and ASoC bits of that separately since there's no
direct dependency.

--/OC9VIUhC1tLvmgX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9QlFAAoJELSic+t+oim9bbAQAIWHlSl/4fPwKL0+LfDkDNE3
a98gt5tuWOdWH0U6n+s7s0D6y9cBcd+rlyBfQ3KfWXJmwzaZ/23yHtarPTimiHsp
QU1ANvN054dnAydl258CQpJmaaEcMRMz4c3p8qR9TG25r9hH/5lAn/bYZRNlgf1D
/7dpNQenDEV7aORQbmj2I8y1zoRpToao7jMzHklU/9cEzG2OjLH+HFMyGNmf1dcA
001EXJ6AhxFqCM0jKHSCnL94M8ntYqcypVhf6KyQwTlMsXJQpbgbnyZNJUuvP01D
D17C9rROMIRMnRr5HNS3d14N4YgTm5UnXG8/1rvd5RFJJOVcASFB67HXEcv3hpMi
XmqRaTOx+EVowYaFEl5b+wgL6plHO2fgpClLC0U+pDJf5glDELUBXDF6IFtdu0th
daasBuGdNw+bQfTv+KX57StcrP++g+82ZxtR1m4UiMI2A4oP1r0COTqZrFkvI8vo
CkgqvS47zzpbfO1FuRLUdu+cnX/tkasdm/UDAZjeagPczXsayPQL0vuf+DS11nZ1
g/ENcSy5EiPGnIvTx31lDVY1fzCrliCMszec1hYZBGG2IoBEdkzYk3xwfBbz0hnK
6tz5HzxCVqb8RSZGm1aE91AF7x12zfkAgv2/Lmq7RrM1BgnD3hntEIgnpfaRS24f
tnlB+yxuHEjyK5HWdDLc
=OSvq
-----END PGP SIGNATURE-----

--/OC9VIUhC1tLvmgX--
