Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaLALRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:17:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44951 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaLALRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:17:33 -0500
Date: Mon, 1 Dec 2014 11:16:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>, Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Message-ID: <20141201111612.GF7712@sirena.org.uk>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
 <1417146874-5232-9-git-send-email-flora.fu@mediatek.com>
 <20141128153008.GS7712@sirena.org.uk>
 <1417403967.9547.2.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUAgMX1mmt35sX2N"
Content-Disposition: inline
In-Reply-To: <1417403967.9547.2.camel@mtksdaap41>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 8/8] ARM: dts: mt8135: Add support for MT6397 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUAgMX1mmt35sX2N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 11:19:25AM +0800, Flora Fu wrote:
> On Fri, 2014-11-28 at 15:30 +0000, Mark Brown wrote:=20

> > This appears to be the DT fragment for a SoC but you are defining the
> > system integration for the PMIC.  That's bad, the PMIC is a separate
> > device so should be hooked up by the board using it.  If there's common
> > elements from a reference design they should be in their own .dtsi.

> Do you mean that we should add a mt6397.dtsi and include it from
> mt8135.dtsi? For board specific, update them in mt8135.dtsi?=20

More likely you should just add any integration needed in the board
file.  There should be no need to specify anything generically for the
regulators on a PMIC except registering the device.

--fUAgMX1mmt35sX2N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfE37AAoJECTWi3JdVIfQi20H/im8teQUzpvlbmmrjqEIK63a
HqY0GfzbjgID2Qfnt6hRrKwg7wmB9jy2iF0I0VuXhlNECm8lFLtlQTkhYr4AOmlO
AgAbWIW0zezngY3XmiwCACgJnExUdLaSEPYFuOg6QsM51hMet+6c15mFA2m7SVhL
1rWxLT0L5r9YaWhWPzbQlTBbr45CRHY2s2wuOFmSXTsALymqYM2rFSMmDaWlrXMA
VdLit4jpcXbTmilAroblI/wrRsxvxbAN8/7g845mBeQZ9KsErbp3mZ21Zj37vIXj
r4DrTMfkNfLhk6qexHR8OCcqPT0Xl1MNX/cW16D36U/qVe5UkNerHsv7z3SBjF8=
=YkfB
-----END PGP SIGNATURE-----

--fUAgMX1mmt35sX2N--
