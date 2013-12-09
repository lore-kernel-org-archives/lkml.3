Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480Ab3LILPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:15:02 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54262 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3LILO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:14:58 -0500
Date: Mon, 9 Dec 2013 11:14:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
Message-ID: <20131209111421.GP29268@sirena.org.uk>
References: <201312012047.02299.heiko@sntech.de>
 <201312012047.42669.heiko@sntech.de>
 <20131202134110.GH27568@sirena.org.uk>
 <201312071446.11997.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kM4gEFU/49KOGupy"
Content-Disposition: inline
In-Reply-To: <201312071446.11997.heiko@sntech.de>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [rtc-linux] [PATCH v3 1/2] dt-bindings: add hym8563 binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kM4gEFU/49KOGupy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 07, 2013 at 02:46:11PM +0100, Heiko St=FCbner wrote:
> Am Montag, 2. Dezember 2013, 14:41:10 schrieb Mark Brown:
> > On Sun, Dec 01, 2013 at 08:47:42PM +0100, Heiko St=FCbner wrote:

> > > +Required properties:
> > > +- compatible: should be: "haoyu,hym8563"
> > > +- reg: i2c address
> > > +- gpios: alarm interrupt gpio

> > Why is this specified as a GPIO and not as an interrupt?
>=20
> sorry for the late reply, but it seems I got somehow droppen from your=20
> recipient list, so just found this mail on the mailinglist.

Your mail had reply to set on it.

> In v1 I specified the interrupt and the gpio. Apart from the resulting=20
> duplication of information this also resulted in the gpio only being requ=
ested=20
> but never used itself, which Mark Rutland did not seem to like this much =
:-) .
>=20
> As I'd like to keep the sanity check that really requesting the interrupt=
 gpio=20
> always provided thru a gpio. As there are other drivers going this route =
it=20
> looked like an ok way to go.

> So what would be the real way to go? Specify only the interrupt, only the=
 gpio=20
> or both?

Specify only the interrupt if it's genuinely an interrupt - requiring a
GPIO is broken as not all interrupt controllers are also GPIOs.  There
are some OMAP drivers that are broken in this regard but they shouldn't
be doing that.  Only use a GPIO specifier if it's used as a GPIO.

--kM4gEFU/49KOGupy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpaYKAAoJELSic+t+oim9OIoP/Rfqhqd5fwaEliUVkx7Nl9t2
RWMfysT/7JaHWrFEDGitE2LSMgl3rFvPLa1K+nM342kUN7gHbZjB13NVz2RswNmJ
wdgh8+ILesD+YqYrltsvggrhwW4lyvpYIoYvs6Df4H5xTITvR8ba2T+F9ymQEZh5
xvlTkDSR+rISFj9MwV7633DFZIrHCB+bgbwkJb+2fv/Rvs83MOtzxpyaF/L4uH5n
XInu83ika15gtnNqo8CHK5JjbCBhFkfohVr4m/LYtxyYi/m5gDtsbfOrxAm4E/SM
AplmaSjcGy1hgLJyMkQog8qDhVglQvc+MTMJ9GPZcZkXT2l4oaJmdJntxMY8PACJ
xy6mYIKVrldk0Kad6cixsdNRNFMWO6en0+xSlkGjnE9OStYp0abRcu3ag8GG+ljB
prybSlyEGw3R4IqShm7TfXcUsa6+pSGAG+6vvIDJ4L8aX40oNcuVPIe+dh7jHvRs
NDGkIbmRE3olhQkIzO3IHMZIJvLp+kx9QVlYjjU/P7bxqMrTF7kPyOCqRrN9KD83
OJcbGWd576/VBQjhDiJPCs+g4Wnu9ep1HmTnkXaDWj134nmBTPk5404aR/R7aJuF
4rR/zJyfZzlmw2hjs8Z1/SXWSK6byJSIPU/544bJjerac4B/EOTx9pkG8d1PdXoT
TODwuNBM5RI34Ez5N27R
=wRe1
-----END PGP SIGNATURE-----

--kM4gEFU/49KOGupy--
