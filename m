Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaDNVNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:13:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33091 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbaDNVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:13:49 -0400
Date: Mon, 14 Apr 2014 22:13:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140414211329.GD12304@sirena.org.uk>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
 <1397462949-22379-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <1397462949-22379-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: s2mps11: Move DTS parsing code to
 separate function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 14, 2014 at 10:09:06AM +0200, Krzysztof Kozlowski wrote:
> Refactor code for parsing DTS to increase a little code readability. The
> behaviour should not change.

Applied, thanks.

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTE92AAoJELSic+t+oim9BxQP/3ecEi6LTE6Ckd1pQ6OqRgz1
EIufuBNN1Ojs43/AaeKAaeKyV4gCJesBDtQAcznr0GIqNvZ00mRjAp076w/peU6L
0vMmCmhB1Vq3I8ktUJ8KhX8oMfbYmPRl48dwmEcYFbU88QVfecHM+av+bcLawUTE
NmGMeSCFYCCTnIa6wZBJCupwzKm9cVN/+sRbEmSyHAbOYqvQsSEo2WXDeDAcWrNk
iYz7Y3//nPfyzXeN3G+P+M42bswes8V4/0rMk//qe/8UsWuHDRiZSSAvTl79R/Z/
LLxsn7aDwof81IcXshKKwQYR7Gkc3G7lDHnLZGwoFGgOw7eOrxJ+lhMn58II1zIq
k9VbM/iChV6GROoOvfChByGx9/0pkzlbg+u5T4Um1xLJTf93PZ6Mt1WpWDtwYiY2
qK7abevX4XVKaEjwAaX/hjAZ+8xIbtDp4lSHgd5wzeKI9yGAvd0lnqB2nYJXl7Ql
KD5o87D9GaaNK/PtWN7wDo10HfQSQTHEXabDCKcjNVQ9eKC1wpMopNLrE3kRm+ZU
y+XoR4zOzmOhOxD6Y+mIA2gGnaKSLKGxxHLM1BXscUasVFsebWRAVfuFXjLfVgN2
4b2BpH8WNGqT8ORgMp2pXk5P/FNBLvAYxedqaoLMZxJslBKOEqmSxIXzK5oHgwIO
wiBZL86MRkGNTQMcBsTZ
=Odcb
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
