Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3JQXep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:34:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54546 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3JQXen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:34:43 -0400
Date: Fri, 18 Oct 2013 00:34:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-ID: <20131017233436.GV2443@sirena.org.uk>
References: <1382013941-861-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yKFK96CsHx70a80G"
Content-Disposition: inline
In-Reply-To: <1382013941-861-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: spi-s3c64xx: Add missing pm_runtime_put on setup
 fail
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yKFK96CsHx70a80G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2013 at 02:45:41PM +0200, Krzysztof Kozlowski wrote:
> pm_runtime_put() wasn't called if clock rate could not be set up in
> s3c64xx_spi_setup() leading to invalid count of device pm_runtime usage.

Applied, thanks.

--yKFK96CsHx70a80G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYHQJAAoJELSic+t+oim9CxoP/icS4A1e9WFvDuZeTe1oruiD
CRgZxOZJyTmzj1hzb732j67NmamZckOGDTag4S8ofYkO5N1ecCTH8rPHxwll0TiF
jsBcUg13gFqJBmRo9wuQAB6Y9mSeKxiXKZKj0Z1U3NBFDi72q2nmnCCinQcqfSw2
/FFohIvizTH5KeokJVLhWlnvUTMOdyuJHZMoaV2M42hm0d8za1yq5Zzp+lbTDhvr
AjyOl5GEmAOaLevtNmK6R/21XxLBgEw0aEsG4hSXcRzH/yOnkQIRTsQYC3svLlC+
dYqRzvDLslFRI4CQOU9UReZ/XAiFPhNtmjlzv1uS9GYTxNh8X/aPHJm7bRYuLnMS
uzI1lGttWAeRY2VUDwc7rAnhaZvGL9jLYWm2U2tJ0Kq/7dDmY1xud+GijPlirKWT
29swwcUIa1k9/RvW569vsZ0ydph5dsPVKEhB0rUAPh3J2zLL2NYBYqBoOab7fx7t
/0agKCQHG7pacrwC37M2hw1fmmMcjD4nsV1tJVUypz1mHOfJcthhMCM50ttkQlAI
3ujhqlN1dE4aHsRjQYhXFqqo+NUDAs4OOfFPzRHLZCiMGpLydc9XP7TIG1SrgiR8
v0GRQhZUu+RxkWfegA4C3ptuEAMFQaVb87eBCvQM3UoqAsIhPiJfQY7yqnQ9ArAP
+GXp8tW7A1CHUsUM7yiz
=9Etr
-----END PGP SIGNATURE-----

--yKFK96CsHx70a80G--
