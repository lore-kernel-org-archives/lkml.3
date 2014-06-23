Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaFWKyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:54:47 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57006 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbaFWKyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:54:44 -0400
Message-ID: <53A80754.9000900@st.com>
Date: Mon, 23 Jun 2014 12:54:12 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <chris@printf.net>, <ulf.hansson@linaro.org>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>
Cc: <kernel@stlinux.com>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 10/10] MAINTAINERS: Add sdhci-st file to ARCH/STI architecture
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org> <1401899424-1365-11-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1401899424-1365-11-git-send-email-peter.griffin@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="EOOXtWS7XOREkUW9Lh7gKmdeVvUII2idw"
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-22_03:2014-06-20,2014-06-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EOOXtWS7XOREkUW9Lh7gKmdeVvUII2idw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 06/04/2014 06:30 PM, Peter Griffin wrote:
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

> --- MAINTAINERS | 1 + 1 file changed, 1 insertion(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS index 6dc67b1..19dc265
> 100644 --- a/MAINTAINERS +++ b/MAINTAINERS @@ -1306,6 +1306,7 @@ F:
> drivers/pinctrl/pinctrl-st.c F:	drivers/media/rc/st_rc.c F:
> drivers/i2c/busses/i2c-st.c F:	drivers/tty/serial/st-asc.c +F:
> drivers/mmc/host/sdhci-st.c
>=20
> ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT M:	Lennert Buytenhek
> <kernel@wantstofly.org>
>=20


--EOOXtWS7XOREkUW9Lh7gKmdeVvUII2idw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTqAdUAAoJEMo4jShGhw+Jr5kP/26TFEhqQcxPolwQTqNrgLLT
F2LY4sY7tTqRrSPkIeQ4tfe30tveb2twhKpNmDmjcwGaAc5YZUYpaaB0PZHEGiMl
njGybn7cgPdhU8NX/FKEQCXjgFmEvbwnC4UOEsL107NUBH9TD+60kTAV+bwjxFXJ
gVQHrZIclJRNhHAshiMR2ogc3AaMcpmLEBOYCBeNl80VrTiCG/N2ZNELEdNtD0ZO
DESnlbDRJX46KHyKQZPuEcHh6HkXMsZ8dPaj+f8rLg1vyHZF+4qkMypl7inEbOba
kNQR2k7KM3ZFaFmLewBcGixu7EY5+Z9/qKXbof5DFpP3F88Zx56oyVEIacEfpa2H
qhE9b+sdZj5F0ZpKiLvUZZWZgsfZAYGl0TyRJAFteMIOWutTJUClYfp2GNtJ2UFB
G2ARN52ZGDFXYgMvh+wYOeg+a2Fy+wWO8cOa/hXnHHtH/rrHocTYPn4xH35rLjyI
4TDk9k4zalBD52u6AZ7jXGcHNHNrjrtyOVfgohRNLZNFBq1xlR/7ekMXcjykqBH3
PUkjcUiZLURSonV1UmBJAqRQLjcE+iXeCXQUylCqDv6lvbUnY05KOmJxB5TPEgxD
62dr152nsYYOOk6kahKR/DeGMDSgSBmn0pDQVEKoPG3/dWhSjWLhNY2h1/vnkr3i
LDxHOuxTk8YlrSgZA/zZ
=CFTR
-----END PGP SIGNATURE-----

--EOOXtWS7XOREkUW9Lh7gKmdeVvUII2idw--
