Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaBJOOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:14:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40065 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaBJOOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:14:10 -0500
Date: Mon, 10 Feb 2014 14:14:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140210141400.GJ1757@sirena.org.uk>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <20140210134310.GH1757@sirena.org.uk>
 <20140210135939.GA23141@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QFO1zB2dwAkGraMW"
Content-Disposition: inline
In-Reply-To: <20140210135939.GA23141@lee--X1>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/8] ASoC: da9055: Fix device registration of PMIC and
 CODEC devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QFO1zB2dwAkGraMW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 01:59:39PM +0000, Lee Jones wrote:

> > Applied, thanks.

> Actually, do you mind if I take this and apply it to an immutable?

> I'd rather not be on the wrong end of some wrath, due to not playing
> the game properly.

OK, but it does need to go in as a fix targetted for stable.

--QFO1zB2dwAkGraMW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+N6kAAoJELSic+t+oim9GMEP/RUikxwwk3i8Xwj/zR85LUI+
GvPKRyXt+zHnmz6Zsq12Y+y9wM8edVFtKJXUCSH4RRCxhSCIazMecYC+2AXPTcrt
DLPm19vaB8jTMHh7MOjcMf820sZHmgXt2Xj01DulNAxbQxi09iY4RK6+svKOz2up
hF0cGSvGu4mtEXetrBgDLFKpY4V4d2rmZ8iHaFqwBJYVO07TeylQyi+msr361cCc
zeIgg+Iv+Q7I/y9Vf+B1x6gW7sH1ap2scPebZSk4corwBD4g9yePZLRHAwp6N9Zl
r+Uev+Htwa9ta3ZbAayu3x04tPvvETnqyLuau6WIJPWEA9UzHbukFSTP8SS3mJDo
ZKB2olrDrlnJC/b0nBnW7c1ebksWQlgSebeix3hNdw7ryrN9jXDCpysmVJPFZ9Nv
i8ghPMu+C9ZfNmrAkhpFMCYT0yJfW4mNiucj1QQkaVyg5tIjoMx+oKjvSqCWK5ff
XO4zXLjLN/24zuS9d18lzW4ez5CPj4IGGvjom2A4mjyS+mp7cV8P5weNQWIUd3YD
fEhY0hlOPlgCNUm1jcgYMYUMMgrXx11Vu9y5XjCtCBuFrDAxkQrKvG8Jia4rG4YW
zyb5yN8swT3/s3Eb6d7ukotHDigDlLmK6NBH7K7nmdFhjv3ODxcA10CxXNf/2eJy
NQydh4//9hYJyoHdaeyQ
=F0Fw
-----END PGP SIGNATURE-----

--QFO1zB2dwAkGraMW--
