Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3DEK3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:29:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55553 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab3DEK3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:29:39 -0400
Date: Fri, 5 Apr 2013 11:29:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] regmap: cache: Fix format specifier in dev_dbg
Message-ID: <20130405102932.GK6597@opensource.wolfsonmicro.com>
References: <515DAD0D.1010806@semaphore.gr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9RxwyT9MtfFuvYYZ"
Content-Disposition: inline
In-Reply-To: <515DAD0D.1010806@semaphore.gr>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9RxwyT9MtfFuvYYZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 04, 2013 at 07:40:45PM +0300, Stratos Karafotis wrote:
> Fix format specifier in dev_dbg and suppress the following warning
>=20
> drivers/base/regmap/regcache.c: In function
> =E2=80=98regcache_sync_block_raw_flush=E2=80=99:
> drivers/base/regmap/regcache.c:593:2: warning: format =E2=80=98%d=E2=80=
=99 expects
> argument of type =E2=80=98int=E2=80=99, but argument 4 has type =E2=80=98=
size_t=E2=80=99 [-Wformat]

Applied, thanks.

--9RxwyT9MtfFuvYYZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXqeCAAoJELSic+t+oim9W7cP/3l8Jeb75SKGw7XXUgLk1aFD
+AYbKoXhLMKYB8MJqmm7Rr4/aNCYRacUbIXndCPtfpdUvNxzr59NPfn0MZlB5R8+
ttDT3FgSI5U7DSVSX+06V9v7ZM3nqgga0u2WDN0Q3c1NF6OyEv1f4EmE5EhOS8wx
+MoAj4+UceMveH0yE2uRqK16ZRgsG7ZKLhX/rn+maG37W6kL1yRCwbYmwdHTY7vT
9FWIwNI3C+CnYhNsFctNDjJlLRaZMKYeQU0+LMHaen5m5S3Axnd4QYQ2wcK+Unul
rx+Ze1/IjBLqyLWvzEJuStAxVipTQv0Dp52uZU2+Hi0aAfFI0qU0hL4F6zyZe7jf
9tVGJRi403C5A1ttI7/Cp1HI9Q2O1Hvg7Ww39IUDZm4j5nYNQ+CYmke7ndKyha1l
WOdD7clumoEfhX1c+a19h+qqI0+qpFATG963Hf3G+jWgR/CBVpGetf+kcVoAGW1f
th+XedOYYfZjlXJzKETCix0dCfpEztw3xf5NO98DCQhHAkos41xQGtGPROMy8Cbe
vzC5qsLm3ZJIZO1Ntl8uYl3hMukks99RFBU527blbRY5zecyX2MW6/m56xMQfgPz
uCpY345H+HztxXH4dzwNd/auvAKVuL7w1C0vCzsA09fEX0Ks/8z+0hfHfHtGt6sj
QFK0VEmVW0DaJO6RLlDO
=HLfw
-----END PGP SIGNATURE-----

--9RxwyT9MtfFuvYYZ--
