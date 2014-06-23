Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaFWKyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:54:21 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:47893 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbaFWKyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:54:19 -0400
Message-ID: <53A8071C.8090309@st.com>
Date: Mon, 23 Jun 2014 12:53:16 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <chris@printf.net>, <ulf.hansson@linaro.org>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>
Cc: <kernel@stlinux.com>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 09/10] ARM: update multi_v7_defconfig for STI
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org> <1401899424-1365-10-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1401899424-1365-10-git-send-email-peter.griffin@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="HOR5cGsoHwLw1fvDJL46tjJwuNhfCgpws"
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-22_03:2014-06-20,2014-06-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HOR5cGsoHwLw1fvDJL46tjJwuNhfCgpws
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 06/04/2014 06:30 PM, Peter Griffin wrote:
> This patch enables SDHCI STI platform driver.
>=20
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org> ---=20
> arch/arm/configs/multi_v7_defconfig | 1 + 1 file changed, 1
> insertion(+)

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

>=20
> diff --git a/arch/arm/configs/multi_v7_defconfig
> b/arch/arm/configs/multi_v7_defconfig index d4e8a47..48951fc
> 100644 --- a/arch/arm/configs/multi_v7_defconfig +++
> b/arch/arm/configs/multi_v7_defconfig @@ -277,6 +277,7 @@
> CONFIG_MMC_SDHCI_TEGRA=3Dy CONFIG_MMC_SDHCI_DOVE=3Dy=20
> CONFIG_MMC_SDHCI_SPEAR=3Dy CONFIG_MMC_SDHCI_BCM_KONA=3Dy=20
> +CONFIG_MMC_SDHCI_ST=3Dy CONFIG_MMC_OMAP=3Dy CONFIG_MMC_OMAP_HS=3Dy=20
> CONFIG_MMC_MVSDIO=3Dy
>=20


--HOR5cGsoHwLw1fvDJL46tjJwuNhfCgpws
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTqAccAAoJEMo4jShGhw+JhAsQAJabGblynDfRLIeG3CEVIRaA
b3osDGHMYdd9sdrVTv6StOnXcqqBUu0Wv3JQqVuEpDWUOmE8bHKFaD+aw+TzNXwo
WqgIf03PuPOLmRq40EOm8QR/mREJBIMG8DK9lGu8u3yc1A9VJ/mTMEhAocKLRKdf
0LzKa7HzkTaweciI7iX+x88OJcVuXM+XfHZXo4iN1st0+gF0C0Kuxw2CNG9xl4yn
87urXkstu5LydtwcsMZaNlgVqBStOc3SmGW8yGZwh/awCv5Noz6uM0iBalTJ4by0
Bkg0GyarO8rtLsY+o9n+J0tHukfOV/OPSy2TKz8Gu9r6KeTyaiXOG41WaoJj+p55
Sph061gPCMFaKUUS4nwzTEnr0ctBgmeCt2WTF8F7InlqpvYB3FIg0tkl1yCvzBZs
+bJjPdxYSGN05yl6l2qVO1tbXL/tm27THfgx2gF1PkR973TUzzE2nDrbFY0oiejK
uNVngzOZF4B3aq2fd88hzVDccj2FRuKnZrvVQV6bxbvAovEjc5Qy0zewWr1HPU2r
2FBrI4m/hZtDFBqmCv4NPYO7R4HvEh1WYED6TwXKIDTP/P7MjLF7B24hus3yDnBb
jwvtcLnZIJbzalPKPHozXvUQgYdHRlaagcK9WmID9ccVMkq7oNCyQybSrALMpsQE
xJYigi0kj1loffStSPKG
=zZ5P
-----END PGP SIGNATURE-----

--HOR5cGsoHwLw1fvDJL46tjJwuNhfCgpws--
