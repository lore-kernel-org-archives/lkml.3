Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3LKONG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:13:06 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53187 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3LKOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:13:03 -0500
Date: Wed, 11 Dec 2013 14:12:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131211141240.GW11468@sirena.org.uk>
References: <1386770863-32247-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="doUn1Hmx68n+7ij2"
Content-Disposition: inline
In-Reply-To: <1386770863-32247-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: s2mps11: Fix build after regmap field rename in
 sec-core.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--doUn1Hmx68n+7ij2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2013 at 03:07:43PM +0100, Krzysztof Kozlowski wrote:
> Fix building of s2mps11 regulator and clock drivers after renaming
> regmap field in struct sec_pmic_dev in commit:
>  - "mfd/rtc: s5m: Fix register updating by adding regmap for RTC"

Acked-by: Mark Brown <broonie@linaro.org>

--doUn1Hmx68n+7ij2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqHLUAAoJELSic+t+oim9cAkQAI2SaDsGygXnrZHp/bjfaEEg
2k6H0mf3bZzgC1SsiekANI//7YVdS85Sc2KiyWRlhKZW5ZWbVKLPPCqNZJ2VwUNl
GX3JPPLd2dT27K3++sStYYaA3pzCiXIhgtaOiPePnpZuokkpEjtCNxJNT8cz3OeP
l0Hvvy3zUDNx8uThoroCLgYXX6w+PaXjazGHtpbeksTDzg7z+HrxVzW9zcri/CYj
heZFbsNnWgQFDyFNB5y1kmOpLOqe6pMtsc9H7WFVsgJ+ZYin1hFgYvOMJMPVfIKe
NJVn4M0zEi1j1p0efQU0C0Wsz6jwfkgZYnNiZlIzUP/HgWvyCekgeao3t0vqDD9H
UWH3mXRfUODGWh5VT+Ol0pBXXE4N5NktkPL29JQO3cJWUwX93vibsOXHVz3LhvfE
q4YxurjxFxnLwBRsvK4dQYuzDw2fAaLkoRXmwuT2vGt3fUfdhq9kp2GwvRegYTGY
YN9njepakjlp3XH05206xrkLoCu+75GUlgN8jxqxclmXFYpRZXWW3Jnyew18+inc
ZCRqhJ/2qRdXSEJDFILLWBZfLOOc8z4VA9zVoArhpgnfbRLxGapFi9RafAZK+Baq
1/Bs1HK6u+RPgoBD/pJCUr+s/PjgEvxEbZ/XRwnqcwodGMcOG13yzOQD7fcGmwiR
ueyvw0AbVAvkFIPQUHnC
=AdVg
-----END PGP SIGNATURE-----

--doUn1Hmx68n+7ij2--
