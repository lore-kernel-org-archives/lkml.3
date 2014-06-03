Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaFCQCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:02:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52195 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaFCQCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:02:40 -0400
Date: Tue, 3 Jun 2014 17:02:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140603160207.GI31751@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
 <20140603145347.GE31751@sirena.org.uk>
 <CAKohpokRk+PDokcgRdQc+EfRs6t7Uduk8mJinBfANCs36-5_oQ@mail.gmail.com>
 <20140603153258.GF31751@sirena.org.uk>
 <CAKohpokVX80K3DEMC7NTVNsxmrNT39t-E1QED2VYycjEmT+ukQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0k7NRaGPjSSxFfo/"
Content-Disposition: inline
In-Reply-To: <CAKohpokVX80K3DEMC7NTVNsxmrNT39t-E1QED2VYycjEmT+ukQ@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0k7NRaGPjSSxFfo/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2014 at 09:05:56PM +0530, Viresh Kumar wrote:
> On 3 June 2014 21:02, Mark Brown <broonie@kernel.org> wrote:

> > Could you please be more explicit about what you mean by "valid"?

> I meant Not NULL..

To repeat yet again: NULL is a perfectly valid regulator, anything
checking for NULL is broken.

--0k7NRaGPjSSxFfo/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjfF8AAoJELSic+t+oim9gDAP/15k45XlpORGsvFAlsVKmfgp
fr9GimjWeG9dBU9bjM5/VQtgFe0TieOC2kcMA8U5VlsqbKrMruZiB05ckWGv0YBK
C/P63Gt9hgFevuEWHALS0/353is3m+PhXMXV/whSbsg0tohJygiIW0+jXgxhcQal
iLFCCPnydAiRWdNKtVrLf+0mGaC75dFTnCtsQGbwkrC4Ls2CcpJSznt66csCwnfY
P/InbffEQJs7YdPupA6q1ilxtF4qC49caq27lG9E6diIIW3oul1t3blckQZzpsnF
VuogmM9sWrVFqZsHYvc/g4QKBAI82EK47opFfic047IYx9iAtdJHB+l0xsSXibJN
zV/cpqrppNLnekZ/VPdnZ+EXB645Acf15cUxF23fDI7c8cWSmPo/OO+RNZf2HMqs
ICBw7aY8QG+hTMX0YaVxOg7dZY+Zw8nuCZa2ZZEIKQ5a457Sab2E48NLA6KO9FA8
BrIKn2FpQBSJn1z4Pb4GL5PNKIjf/wj9lyHwu69j9Ew7c0W3NIVB3lH9h89c8Sia
6G8Rg17gg9eSZSKpxSTdME8KnI9pPKqO4FI1zSvIyJRKxaIfRd9nrySuSMn0k0ND
KqKPEuoDTyO5Qlh+mPBMrrXXrWfyEJW6tyUr5r4WiESac9CtxA+4NPwuM2RmlTl9
YpEZfvBqC1OHYF7jF12i
=dC0z
-----END PGP SIGNATURE-----

--0k7NRaGPjSSxFfo/--
