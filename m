Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaBRAgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:36:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35634 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaBRAgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:36:35 -0500
Date: Tue, 18 Feb 2014 09:35:55 +0900
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140218003555.GJ2669@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eWcwVm1EAUAdFu48y_O5puu+eGvGW3k6923MdXfMa3UAw@mail.gmail.com>
 <1392383156.12506.20.camel@AMDC1943>
 <20140214210502.GX4451@sirena.org.uk>
 <1392624454.3755.12.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="72k7VsmfIboquFwl"
Content-Disposition: inline
In-Reply-To: <1392624454.3755.12.camel@AMDC1943>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--72k7VsmfIboquFwl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 09:07:34AM +0100, Krzysztof Kozlowski wrote:

> The low power maps to REGULATOR_MODE_IDLE or REGULATOR_MODE_STANDBY
> (depending on the understanding of "more efficient" and "most efficient"
> for light loads). However the suspend mode of S5M8767/S2MPS14 is more
> like automatic regulator disable by SoC.

I don't understand the above?  Are you saying that suspend mode actually
turns off the regulator or something else?  If it's a separate setting
for suspend mode then it should be using the core suspend mode stuff.

--72k7VsmfIboquFwl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAqroAAoJELSic+t+oim9cLAQAJxfSCNtCfAf6DCJKD8rj/sh
oSd11K8tcZhjxcN9Uyd72rd8v0G9QlSChQEFxh/1Nl96V+bJNQzbP82N9IxjsH6J
y3EdqyVtwLrpaEfWXqPLtK61yHkYqIm61sj/6JPe5+VKqGaYFWVrY4hYw3ZVWueb
7uNyHl9IhtTuWmlDr63LbxQAeKHcCI5Fsd03QX/eDEgnDm0eMm6cbyo6b54fwWXx
NmAxiU5sFo5yXP97/WMUOObHG6h1a9hADBKL0UD7IKOuQCBWCw5+zf7Um7IeFML1
EhOLmSjnncEInrs/ttqjA6Gfe8fDG7Po2X2qpxKrvp9w5J/AIHvHHQ4sTPUlSMCN
nUXx6cgUWPN+hfw68xjsg9JhQXPA+VgPYDqDsAcCfIEkagkoBtQaWbHEDpimLsJN
wI5rITZupKFhOW3Foq0eGmw+7sykGe/ltE9IDuICAuzk83ZQTII/t2VeqqN2KXTj
islUBV7SaaUG542yF/UxzKxWAVAYXGZ/QDJTsDQDs65Sm0ccOoYoDYhpfjFov+UT
Npk4d7OECsAZLAyAQlLLkQ4vVY78qcqqTjATc/7FZc+qo3OW2mZv5hq/LZaaHzzh
p+3zD+rxbI5b3VeqATczNtC3IGvHNnVNo3nxD41Qz0/QlztYF1JikcNWtP/QACUj
ojs02OIymDhSRQl3NeOl
=Oc9q
-----END PGP SIGNATURE-----

--72k7VsmfIboquFwl--
