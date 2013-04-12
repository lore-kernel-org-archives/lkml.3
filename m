Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3DLMzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:55:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43982 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202Ab3DLMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:55:24 -0400
Date: Fri, 12 Apr 2013 13:55:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        Padma Venkat <padma.kvr@gmail.com>
Subject: Re: [PATCH v2] spi: s3c64xx: move to generic dmaengine API
Message-ID: <20130412125521.GA12534@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-30-git-send-email-arnd@arndb.de>
 <20130411165536.GO9243@opensource.wolfsonmicro.com>
 <201304112242.03252.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <201304112242.03252.arnd@arndb.de>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 10:42:03PM +0200, Arnd Bergmann wrote:
> The spi-s3c64xx uses a Samsung proprietary interface for
> talking to the DMA engine, which does not work with
> multiplatform kernels.

Applied, thanks.

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRaAQyAAoJELSic+t+oim9TUcP/3PKIvuiWou4mfU71VB/mwcN
ZLMNz/HtiY31ff5s1Z2Sz6nrG4lzaFuY2OD/J3q2xxJ/WH8qNwDmKw7KR6tYOKBf
2itG8KEuSJvf1J7T6qRb0wYlWYzR2hkZi1o2X8Itln6y6NQsH+UVplgN/0S1FiB5
WpyTQjuLiNBe+E+Ij9Issk4iNbi32/PeqiHH/gXkxNhbiisCpzuXO2fLCkErq2XV
jvboOYb7j4Q6g6L2hTNyodZhjNAvPUsoHqSVAZKm4kVMWtRydgKMwOY4P0EpneUk
+guKm2c6y9uAf6mLcASBj7OqQ71XfZ71vYAfpttaNt0DHxZJkG2UL/tiQSF8Fgyq
vN9ey9miXQc/75HphjqJt/H9xvGj5mmXDsiw83qFNmSkHd7fJt+z9wFyqGzMsJXS
fBmVY6xXPKUXthItwyPdCJS5CtCdrRSHo8teFBE0WYWGMqzKTjYEtNTSJUt45JU+
O7L4cilI70pcxoLUHrkkiBDYJ8H153x1rm8PPZ2FXkvyA3EJtRCHTr86ZqYnuoMq
lUMp3KD8RusRxbd6WzzJbDeT78GdJCnpGl8rr0nVr+wpj/sQVhrgU1pZyn42yDf1
jc29u+sFZxEBFdk1sC/t5eFq5R2L2eomibwDx/HAVShRNkS1OB29UU+LpwowH+lq
kh3o1lqApOaTSdFetfPe
=wIGk
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
