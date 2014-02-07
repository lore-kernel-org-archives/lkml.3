Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaBGMwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:52:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37783 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaBGMwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:52:45 -0500
Date: Fri, 7 Feb 2014 12:52:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20140207125237.GK32298@sirena.org.uk>
References: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
 <1390570678-30686-2-git-send-email-k.kozlowski@samsung.com>
 <20140127202524.GQ11841@sirena.org.uk>
 <1391776833.16500.1.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O1HwIoIQdgOxwxO6"
Content-Disposition: inline
In-Reply-To: <1391776833.16500.1.camel@AMDC1943>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] regulator: s5m8767: Use GPIO for controlling
 Buck9/eMMC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O1HwIoIQdgOxwxO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 07, 2014 at 01:40:33PM +0100, Krzysztof Kozlowski wrote:

> I can't find these patches in your tree. Did you applied them or am I
> missing something?

They're there now.

--O1HwIoIQdgOxwxO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9NcSAAoJELSic+t+oim9kqIP/j1QmttkWoCt4SfZoByRgexe
47Wj2WMUInfBQBYhl319cOFtB3gB+3KBpJsOIjVrCPvJxAQtmrYOfYMWMUlFg/j+
1p4Ihn/0abHkoKDzil3Igl+NzjsY4Eyzd2UUntrHK5dbBb6XYdbLHZmuDdqM2IsA
k7a2SU7za1jHUZFLUy+uk9e2ce+KnjyXqJ0ipBpEbHJ6CVYWTaGUVkP2uZ4R/CjK
S9NQV4zK8pcPuEhF7jb0FQ5PMampwk3gakQZn6CetY/jbLQawXCCeuQpvFRVBBRf
jfdsO0TZ/U5BowocXHocpA9ViEGCmI4g5j/QUS64iGzDTjsPgW9mePHdXR+XZzan
2jCm7JGGsOpvOwEgEBlU66yR3JRLIqObdgAGCNxr0/C4I4X9ItlB/iDXNOcyFJb8
YZTSHO21EH2e6NRaFEpTVeSghQLL0yxPWOZronATFY9Me9tmaC6PxI1EORR9rXQg
D8ZuubKnl1pfJKoDOINFs7KYOxcMvnwYU5J7PXFRmjNrq+DOCp60+U1Q2IOtsyxC
pKM/JWvfF7YJQ16ob2xlsQmhrLVezXan/zFMQIAPIOWJ6ZxrOvF3N7IjB0XmUrQE
mzyLFoIr8SJyeHL15jqqk/DT9B7As34G+9dJ0N0i+oONDtabDOQ1ZUaOF+vor378
S6oodnjsBDm3JX8iJSUL
=PX3J
-----END PGP SIGNATURE-----

--O1HwIoIQdgOxwxO6--
