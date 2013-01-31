Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3AaKm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:42:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54880 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3AaKm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:42:56 -0500
Date: Thu, 31 Jan 2013 11:42:41 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Donghwa Lee <dh09.lee@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/3] video: exynos_mipi_dsi: Convert to
 devm_ioremap_resource()
Message-ID: <20130131104241.GA8676@avionic-0098.mockup.avionic-design.de>
References: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:FvcX2AUr1dOo9kzuNZEn2wEAPpDSxpR3VWryviaYJnG
 JBt/5Anjw9PjptjE42jamsnboDg34L4oYzzNVBixkNRTlcJnaA
 jixdNzjp2GpcSHnTR9n8m/aA2oQVME3I1EOigs+dBms3yZRXhj
 jkpd5XWb2ZRCfASGYzySEsO2sowOKjdZlTGjU9hfTsZHW6Vdvj
 J0TK3pTBIz4atDNE3kcFab1iv32nHBDx+I2Usq60U3ldS9IwWx
 +S6qcjegJr3UUzlPKNiW52cDS1bcScQIteaL7kvf0y/Gy9yRpN
 Vzlfh6FAFB0TGlaa3ONPU39zkOzUfrurO+32/onTAALVykz1js
 D5rMMZPXSVmLGC8+JVjg8YdsQaVSu46yk/g/6Xids6YGiwOoCa
 /2j0cxCLIjBw3+t5CusE9j1LLBU3n5yN1ql0jPaxgzpT+KNCqE
 d7PfB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 03:55:37PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Donghwa Lee <dh09.lee@samsung.com>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/exynos/exynos_mipi_dsi.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)

All of these can drop the additional error message because equivalent
error message are output by devm_ioremap_resource() itself.

Thierry

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCkqhAAoJEN0jrNd/PrOh3goQALyFuRRHioY8l4PZuv0oTjQv
vrIzvY9KGFF6ihNUiC4I6Kw55/Fezb8dHtw0ZE8ryLnrBN//ZgKr1FsG8s9w9zN6
T5SPQGvQSAod5vrRG8Ps5Yc8jkzWXLBQVQ+TERFgmw0xMARR3fPtaet9tCz8Esq4
sdT/HJdEj0NqbJpyAh1FizgBmPaH3ZJOeTDJelIKgxIadhiHYLV6x2Xy2lpWRZvY
rx+WnSVmxosa4/QoeaYlJ58KchMUo7cSq/YHgnaCZl26GLME8aHlyDaQmzZznItL
KMQk3W3UGFrs60+0H+xS059GfT/HBeF+NOjihA/38cAmdk0i4klUCgUXOAv04eEP
ViFSrZgVKBJ5Qqx3wV3nKi9BgiAVkA7l+vUszRokfsl79ZZHWVio+eRflL7Bi7K4
tWxi2nGrO/6UrGmxxA+K/urQeSqgU2+WsL9iohutqhfw2aNNIYaZ0iIssILWce9Z
dBpSzScOkDA25AtbHB7/EZ/H3GiXSJmO9WJtIawU1yxqL9+HMPy6jsnjpXw+JdoM
OiXQ5YKOd+6SUKoK6/4Swf/Virh0b6zxKtgvrwz+M1OtjYgsR5m669oKbwdb4t67
xajxoFpuvN7GAtY0Drvgg8U+rvAFwoohpz5ADze4RCY4sHz9SXdAsbJKGK0WmQo/
uhyCmTUDwJA/X63VIlqe
=2ol7
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
