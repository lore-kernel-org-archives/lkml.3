Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3KTMv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:51:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59086 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3KTMvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:51:53 -0500
Date: Wed, 20 Nov 2013 12:51:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Doug Anderson <dianders@chromium.org>, devicetree@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131120125121.GB2674@sirena.org.uk>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
 <528BB1F2.4080107@wwwdotorg.org>
 <CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com>
 <528BB913.6080409@wwwdotorg.org>
 <CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com>
 <528BFD28.3050909@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ghfi4GlmwTrWkODx"
Content-Disposition: inline
In-Reply-To: <528BFD28.3050909@wwwdotorg.org>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized
 using pinfunc.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ghfi4GlmwTrWkODx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2013 at 05:07:04PM -0700, Stephen Warren wrote:
> On 11/19/2013 05:02 PM, Kyungmin Park wrote:

> > Some pins are not connected (NC). At that cases, there's no drivers to
> > handle it. To reduce power leakage, it sets proper configuration with
> > values instead of reset values.

> Hmm. Shouldn't board firmware configure that kind of thing?

> (Of course, some firmware is starting to use DT to configure itself, so
> that just shifts the DT discussion, but anyway).

Even if it's not sometimes the firmware is intended to be thin with
configuration punted to the OS.

--Ghfi4GlmwTrWkODx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjLBGAAoJELSic+t+oim9O3kQAIvdeY7tzGmzEuyfDcnqDUZ4
y9t9LFMCjDRDyT+m8ggfFId66s1bx8U4HAvXygMo/M56ThVZ2AjdzNc0pbSvC1+e
kYGxfmXv2yYDcypmqQQZndZuIhCHBDOOjbFskkHYfqe588wzdFsBMjdo9hPAzxF1
T9eXKSADHLMcthw/cCsLGkgzn64uIQS1S0faNOle82Vzc1qqL63/HktAfnp95gwc
d1WxvdGbr5pUekFrdPDzisir5L5GKfBc0LC+dogWBqU0LWhDRSl6RgBJpHjilfnJ
KLdpo3TcIcLNxAOEGqZuR/tF3FP1yCk8LHZiGjqFTJ6svKio8HYtdXMDiY2Wjua0
qLhpwSobBpVLIUO5o46ytj28f49lKwL9yYt8riWr8aZmQTvlWGSrjR2H6cx/7KZf
RgO9GAdcRGbSzL3Ax1Oz9yGN2S8AOVsvPkyt3Yiph/8R42xu4t51DpyC99cku5CO
Lklh7HX2tfIRXPzQrPSzzmt2Pj8wUmEbl5Et0WrtmI3TKTSOwc7NUQc4yqlB468T
Y/PmooXeWIk7a/ZLYHFSvfAZoqsUggxmg1tIIDh3Dt3vzGkEmnEepQ+S0ce3MGxy
Phj+kQrC4BDrzi5czymLIORG5IEcYvFwCfzDJyf13QaD1glbdX7neZOAq9rwKy8P
zcTkxZI7R2nYVKbbHnrF
=f5LR
-----END PGP SIGNATURE-----

--Ghfi4GlmwTrWkODx--
