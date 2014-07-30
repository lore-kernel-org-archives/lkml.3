Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaG3LPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:15:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50342 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaG3LPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:15:03 -0400
Message-ID: <53D8D3AE.3090701@ti.com>
Date: Wed, 30 Jul 2014 14:14:54 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Michael Welling <mwelling@ieee.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] drivers: video: fbdev: atmel_lcdfb.c: Add ability to
 inverted backlight PWM.
References: <1404440796-11090-1-git-send-email-mwelling@ieee.org>
In-Reply-To: <1404440796-11090-1-git-send-email-mwelling@ieee.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="EBVT1AePQ5tfB3p9UTkmL1wWC0TOGORip"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EBVT1AePQ5tfB3p9UTkmL1wWC0TOGORip
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/07/14 05:26, Michael Welling wrote:
> The code has a variable to change the polarity of the PWM backlight con=
trol but
> it was not being initialized. This patch adds a devicetree entry to set=
 the
> variable if required.
>=20
> Signed-off-by: Michael Welling <mwelling@ieee.org>
> ---
>  .../devicetree/bindings/video/atmel,lcdc.txt       |    1 +
>  drivers/video/fbdev/atmel_lcdfb.c                  |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)

Thanks, queued for 3.17.

 Tomi



--EBVT1AePQ5tfB3p9UTkmL1wWC0TOGORip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2NOuAAoJEPo9qoy8lh71S/AP+wY8hZz/fgbBrf+9sgKTgYio
sNu8TsEI8GKPfPQUg2IMGc6aYNnboZplB3fFtqMFOsbj0s/Km1hYhKGBEAyUMcPN
vQLuu8h3B6fDmCHrX2vbcxQSDUuhTGgBYoqtRQH2fLJZEinuFqGpwTX9qarkTkMo
TTnYtbqzJglquc1Zk/qiA3hOcezDvtFbQdfJzNfJA+XzRmguQaJT3q9kI2Jvz3Lk
GvJ4L3jdKqTaZK1jQI/sn5ZEhsvi/G+nhfnKAKB1vwspGEsVA9Z6ZwkPDCW9iXdJ
XooEfJauHDrm4baV0o1C4wes16xJx6hWpaYkLC7KbrxF3WXecb7X9JvRpw3/gSJF
5I9ilNX2e31QSpgIh0C/cBx+Yjh1CA7fjdEFUfyISQ0BvnPqHfcqSoYMmGV5X840
RCCtDDsoeyap7FHZIXAMP4ioW2BIad33knpkwz0xtrI9MdSDGnHH1CQH+KKk98s/
6NiFobujkZa19Egd+XV3sUmnVnCfq2KYmm03V46MUJ2wnakCteg/rKDz9xJp3Mt7
dM18MbAOZIVpK9laZ7CSRwbdeWfBa8oRvImZw/Zm9TP2hZ81c2GAJKFFZqk2Czr+
k2pkDweoyV5ooo6RSKCOa4J252ouh/kdNzHOtxcQnT74aI2ZHXNiupjPKbSvgOqf
s4p4DoWonUeSev7S4xIB
=BgcE
-----END PGP SIGNATURE-----

--EBVT1AePQ5tfB3p9UTkmL1wWC0TOGORip--
