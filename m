Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaLSQYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:24:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36784 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaLSQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:24:12 -0500
Date: Fri, 19 Dec 2014 16:23:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Fabio Estevam <festevam@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>, Anson.Huang@freescale.com,
        Shawn Guo <shawn.guo@linaro.org>
Message-ID: <20141219162343.GF11764@sirena.org.uk>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
 <1414729631-11005-5-git-send-email-tharvey@gateworks.com>
 <CAOMZO5DzEe91pTv+UkCbj0DzgVDOb9hjuakt9NmpTJnEk-j8UA@mail.gmail.com>
 <CAJ+vNU3PQYCE4tABUiqU+vGkGqBEqdVKz25W88-ByOQZxunVLw@mail.gmail.com>
 <20141218142205.GZ11764@sirena.org.uk>
 <CAJ+vNU1YQWGFaEm8w8wtaFvUy1jig26jW3+3teMFHLB_oFyn8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="99MdDuYC93zIKUQv"
Content-Disposition: inline
In-Reply-To: <CAJ+vNU1YQWGFaEm8w8wtaFvUy1jig26jW3+3teMFHLB_oFyn8Q@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] cpufreq: imx6q: add ldo-bypass support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--99MdDuYC93zIKUQv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2014 at 08:17:41AM -0800, Tim Harvey wrote:

> frequency setpoint. If however you have an external PMIC that is
> capable of adjusting the VDD_ARM and VDD_SOC to the IMX6 and an
> appropriate regulator driver is capable of doing so, you must
> configure the cpu nodes vddarm and vddsoc regulators to those provided
> by your PMIC and 'bypass' the internal LDO's by setting their scaling

You're describing the implementation again, not the system.  Describe
the system then if you want to describe the solution you've come up with
for modelling it do so separately.

Please also try to use paragraphs to break up what you're saying a bit.

--99MdDuYC93zIKUQv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUlFEOAAoJECTWi3JdVIfQH4IH/0xCoOywtl8di5u1aN+LaqGl
u+Cb1TWAYi7JUKodpu1di6tqXmH3wJ5KOGVMK+DRavLO2HcKpNH+U0XVwLmshpCI
ymyBKs5z0aglba6HLWK6ksW6QSCtaqiOYQnVJVh1DzIPEbMzv9RPeNiNoO00cvgC
/N0OrkgBsKOXW/+TmcPddydExFZqBRi0/WkiTctLsqnDzEralYqclOUGtwSXajwD
R23WSiWNcbtkpxRo6Pp+Ual5NdKFNW3KgMuiYYdLUn77fxfKcj4rjG/w7iGjnyvm
8MeJUfVpQlO3Y5CdROODDtU4u+0G2TSYnvwNf0wuPwT9G4o+O98vORjDXC9SBCE=
=P0NG
-----END PGP SIGNATURE-----

--99MdDuYC93zIKUQv--
