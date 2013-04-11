Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499Ab3DKLwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:52:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60893 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759774Ab3DKLwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:52:10 -0400
Message-ID: <5166A3DB.6060700@ti.com>
Date: Thu, 11 Apr 2013 14:51:55 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 12/30] video/exynos: remove unnecessary header inclusions
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-13-git-send-email-arnd@arndb.de>
In-Reply-To: <1365638712-1028578-13-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigAB4BA7E4E18BE84D4AFF1829"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigAB4BA7E4E18BE84D4AFF1829
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2013-04-11 03:04, Arnd Bergmann wrote:
> In multiplatform configurations, we cannot include headers
> provided by only the exynos platform. Fortunately a number
> of drivers that include those headers do not actually need
> them, so we can just remove the inclusions.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-fbdev@vger.kernel.org
> Cc: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/exynos/exynos_mipi_dsi.c          | 2 --
>  drivers/video/exynos/exynos_mipi_dsi_common.c   | 2 --
>  drivers/video/exynos/exynos_mipi_dsi_lowlevel.c | 2 --
>  3 files changed, 6 deletions(-)

I've applied this and the next patch ([PATCH 13/30] video/s3c: move
platform_data out of arch/arm) to fbdev.

I also fixed the extra space mentioned by Jingoo.

 Tomi



--------------enigAB4BA7E4E18BE84D4AFF1829
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRZqPbAAoJEPo9qoy8lh71PlAQAJ1DaLc2zDE6qQNWqKoOPjrm
GU1dYSGqqXsiR9YaZy9zzTzS0kB+VhUchrBvrixvHVIdZyaxGR5VzqS2eeg5Iqh9
fHDcHpzN/gngg3DmDVcP1rmqltP6Wayhv3Der/1YfQXe2NukpY/Y+BOy+H5cNc2U
WCIom6Lu18g0BfWLCnYr594izyE3hrk1DsbOZdUq5DKQuL8UfrMC45GlzLx2T3GT
rhNG5WwcORxOq4odSlxI7GWrHv3FclqpLNqzc7nDGRZWTHHRmiPf+GrGHrPWYTRZ
5YhiNwGB6EdjKvMmyXiIOwqDGASYIU9Q5zNt9lucT2ppYkHfe4up+Bquuf7awR/6
U1lT5Gy6VwowAiWediyGsVMp/1YeOtpbp6Dnwz1RcLZ/lms/VaSDowWfpM6JjMgc
YdBT4yUfs9GH+iytaAWgZiBLqqWagTroPSHoRhUurt0N2lB+MsDLwYRtnib/pXvi
agrRCIC4ZNUCGdtRLKamB1zYenigEqg9OjbDXnKi0kCMu3TF8b4L9qrGiTDVM3H5
iNr7aGTOIzjODwj6xCiYFd037rzAdqb/pm1B0Nvvf+EJ1yaW/wtsyZ7nYzGEC1A6
VhcbxBkS9SbqqnZ1XWyT+mr4tSLhjH7N6jqrfLglhTSJyBuXkJyuXVjxf+OqUqjb
4xeyZlsS03PTiuPZumF0
=QPWV
-----END PGP SIGNATURE-----

--------------enigAB4BA7E4E18BE84D4AFF1829--
