Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaHROWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:22:38 -0400
Received: from [207.46.163.140] ([207.46.163.140]:20075 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572AbaHROWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:22:36 -0400
Date: Mon, 18 Aug 2014 16:19:56 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tgih.jun@samsung.com>, <jh80.chung@samsung.com>, <chris@printf.net>,
        <ulf.hansson@linaro.org>, <jarkko.lavinen@nokia.com>,
        <balajitk@ti.com>, <baohua@kernel.org>, <viresh.linux@gmail.com>,
        <ian.molton@codethink.co.uk>, <maxime.ripard@free-electrons.com>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <spear-devel@list.st.com>, <linux-tegra@vger.kernel.org>,
        <michal.simek@xilinx.com>, <swarren@wwwdotorg.org>
CC: <patches@linaro.org>, <lee.jones@linaro.org>
Subject: Re: [PATCH 1/5] mmc: remove .owner field for drivers using module_platform_driver
References: <1407860069-12706-1-git-send-email-peter.griffin@linaro.org>
 <1407860069-12706-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1407860069-12706-2-git-send-email-peter.griffin@linaro.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="fbjn4odFFoAwguFUomUaQxkj0tNXNrD4r"
X-RCIS-Action: ALLOW
Message-ID: <3815db00-4b32-4484-b97e-2144dc5abb45@BY2FFO11FD040.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009005)(6009001)(438002)(24454002)(479174003)(164054003)(377454003)(51704005)(189002)(199003)(31696002)(568964001)(70736001)(74502001)(71186001)(104016003)(64126003)(95666004)(76482001)(86362001)(512944002)(19580395003)(31966008)(74316001)(1496007)(83072002)(50986999)(106466001)(54356999)(84326002)(77982001)(83322001)(102836001)(92566001)(81542001)(65956001)(44976005)(74662001)(21056001)(81342001)(80022001)(64706001)(65806001)(4396001)(107046002)(87936001)(85852003)(99396002)(83506001)(2201001)(76176999)(79102001)(6806004)(19580405001)(20776003)(46102001)(85306004)(92726001)(65826006)(142923001)(107986001)(921003)(1121002)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB058;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fbjn4odFFoAwguFUomUaQxkj0tNXNrD4r
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On 08/12/2014 06:14 PM, Peter Griffin wrote:
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway.
>=20
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/mmc/host/jz4740_mmc.c      | 1 -
>  drivers/mmc/host/moxart-mmc.c      | 1 -
>  drivers/mmc/host/mxcmmc.c          | 1 -
>  drivers/mmc/host/mxs-mmc.c         | 1 -
>  drivers/mmc/host/omap.c            | 1 -
>  drivers/mmc/host/omap_hsmmc.c      | 1 -
>  drivers/mmc/host/pxamci.c          | 1 -
>  drivers/mmc/host/rtsx_pci_sdmmc.c  | 1 -
>  drivers/mmc/host/rtsx_usb_sdmmc.c  | 1 -
>  drivers/mmc/host/s3cmci.c          | 1 -
>  drivers/mmc/host/sdhci-bcm-kona.c  | 1 -
>  drivers/mmc/host/sdhci-bcm2835.c   | 1 -
>  drivers/mmc/host/sdhci-cns3xxx.c   | 1 -
>  drivers/mmc/host/sdhci-dove.c      | 1 -
>  drivers/mmc/host/sdhci-esdhc-imx.c | 1 -
>  drivers/mmc/host/sdhci-msm.c       | 1 -
>  drivers/mmc/host/sdhci-of-arasan.c | 1 -
>  drivers/mmc/host/sdhci-of-esdhc.c  | 1 -
>  drivers/mmc/host/sdhci-of-hlwd.c   | 1 -
>  drivers/mmc/host/sdhci-pxav2.c     | 1 -
>  drivers/mmc/host/sdhci-pxav3.c     | 1 -
>  drivers/mmc/host/sdhci-s3c.c       | 1 -
>  drivers/mmc/host/sdhci-sirf.c      | 1 -
>  drivers/mmc/host/sdhci-spear.c     | 1 -
>  drivers/mmc/host/sdhci-tegra.c     | 1 -
>  drivers/mmc/host/sh_mmcif.c        | 1 -
>  drivers/mmc/host/sh_mobile_sdhi.c  | 1 -
>  drivers/mmc/host/sunxi-mmc.c       | 1 -
>  28 files changed, 28 deletions(-)

I have checked this for all xilinx drivers we have in the tree
and I have sent similar patches.
This problem is probably in all subsystems.
With communication with Mark Brown. Don't you have
cocinelle script for fixing this everywhere?

Thanks,
Michal




--fbjn4odFFoAwguFUomUaQxkj0tNXNrD4r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlPyC5IACgkQykllyylKDCHd3QCfT2L7l1xjP/Mc6c/ym+/aRN6t
er0AnR/VATsUMTIO6Lr8XTeDvzl6m0QG
=Glle
-----END PGP SIGNATURE-----

--fbjn4odFFoAwguFUomUaQxkj0tNXNrD4r--
