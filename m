Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461Ab3DKQr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:47:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38126 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935198Ab3DKQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:47:54 -0400
Date: Thu, 11 Apr 2013 17:47:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 18/30] ASoC: samsung: move plat/ headers to local
 directory
Message-ID: <20130411164751.GK9243@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-19-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ttldl3tz4cUGhF4e"
Content-Disposition: inline
In-Reply-To: <1365638712-1028578-19-git-send-email-arnd@arndb.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ttldl3tz4cUGhF4e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 02:05:00AM +0200, Arnd Bergmann wrote:
> The plat/iis.h and plat/ac97.h files in the samsung platform are
> only needed by the ASoC drivers, so they can be moved into the
> same directory, as one more step towards a multiplatform build.

This doesn't apply to my topic/samsung branch, can you please regenerate
it against that or let me know what to apply it against?

--ttldl3tz4cUGhF4e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZuj8AAoJELSic+t+oim9NfMP/3AFkNQ4vUYYj52O/TMmAbrb
fdsNZ2zyj9Dm0O6dggeEpSzPwMnb8pDzjRItgKXtGg8kHXsy75RtLDO/azasnGwv
UkKDAvlgOoAnZ9d7PLDXaxBwb46BH6+VTfHqYaF5DBGrvEiRFRjqUMi3fgrkmlzd
2+hznWx9dASF2VxiJGkH+xZnYkPB5qrfJ0FgtU9caSAGVpu5gKLVcF22X/nELcGa
ny6hrJf0lB4v/qanfrqGrRnHpLQPrOndG8vjAZ3UBBEm6urm4e2tclyKfzt28ajJ
E7eiuMUrRSYKGv1jYeULJoJYYPBWlhQ7dwWDBMbMTa7eIEp6HC4gJrVPAbBHsy2/
lEkFnLq/wgxNkm0Px0DUInYOgxUlM5KmmweJWgv2qR9UtXZvXw0H0Fpq8om5WdBP
Gz9EFhmA62JJLEgxKpW/IV1DLCwN2WEl25QzAZIIyZ5usfwLzc87OJhrj+bO1ZL4
kJCqfwCmKR7IJ6hvMXT4t2qHujny608MmlnEoS+bytQ7/ogbhzV58Xbyey3ykJeR
E9lgQ9IRt0Z+3kZbFqRmcrkRbvpPhNVQuieMdXJ62svzGClRBxVTvAB9Sr1lNf6h
b2Ux1/xnRGGwI2xE555AQiiAfc8rq7FLA9v7JXtXwXgm0jacAHNSDvqyqwXMEsBn
EuksXjG51vffotJLIIft
=jmpU
-----END PGP SIGNATURE-----

--ttldl3tz4cUGhF4e--
