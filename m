Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbaJaMn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 08:43:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59090 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302AbaJaMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 08:43:57 -0400
Date: Fri, 31 Oct 2014 12:43:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-ID: <20141031124304.GS18557@sirena.org.uk>
References: <1414581294-1315-1-git-send-email-k.kozlowski@samsung.com>
 <1414581294-1315-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j7Mt6kSMu9nlWjvx"
Content-Disposition: inline
In-Reply-To: <1414581294-1315-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 1/3] regulator: max77686: Add suspend disable for some
 LDOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j7Mt6kSMu9nlWjvx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 29, 2014 at 12:14:52PM +0100, Krzysztof Kozlowski wrote:
> Some LDOs of Maxim 77686 PMIC support disabling during system suspend
> (LDO{2,6,7,8,10,11,12,14,15,16}). This was already implemented as part
> of set_suspend_mode function. In that case the mode was one of:

Applied, thanks.

--j7Mt6kSMu9nlWjvx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUU4PXAAoJECTWi3JdVIfQR1MH/j8yXXZcoXZgVy1hV+alYtAc
vkFaBdMDXDhzLtYJ2oycj/PIRagMj57v8iniZmaFbUs5IxJ3adyAo6xWivQEN00h
/3ktpKo0ZEHD+YVWWtuYpd2Cy9CDTXIgDxCCdBYIaFPYLb00I2iikfYLXY298/IP
7z5Wqn6HMs5JQ85thtATxaJewASjIqesrRbWMbOyluQg1IUrpnvI9pWGsNgnZ5DA
pks7ZH9S3Gg9lDRSBbMVxhdKg4gYtHkNjFkLCSDnhZJ/X2rlyLc8VDL0f8+Yagp/
ADTZ/BFwWTYCttsGQYe99p/1OmSm1nDy2i/CxUlc312Eb1t2Gqvnyk46Ul0SA0E=
=f4RR
-----END PGP SIGNATURE-----

--j7Mt6kSMu9nlWjvx--
