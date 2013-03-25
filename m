Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3CYBIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:08:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38670 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab3CYBIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:08:21 -0400
X-AuditID: cbfee68d-b7f786d000005188-22-514fa383326f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Sascha Hauer'" <kernel@pengutronix.de>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1363732701.1390.45.camel@x61.thuisdomein>
 <20130320082427.GB28775@opensource.wolfsonmicro.com>
 <1363770579.1390.82.camel@x61.thuisdomein>
In-reply-to: <1363770579.1390.82.camel@x61.thuisdomein>
Subject: RE: [PATCH v2] mfd: remove twelve unused Kconfig symbols
Date: Mon, 25 Mar 2013 10:08:19 +0900
Message-id: <16df01ce28f5$3d2904c0$b77b0e40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4lSqjKbyhEN/JlQLCsu8hgop7MFgBmnORg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zQ93mxf6BBpfu2FhMWneAyeLf7FNs
	Fqum7mSx2PT4GqvF5V1z2CxmnN/HZHH7Mq/FoltnmC1Od7M6cHq0NPewefxd9YLZY97JQI/N
	S+o9Xk78zebR/9fAY+P2J0wenzfJBXBEcdmkpOZklqUW6dslcGUc+d3HWrBWsuLA4buMDYwH
	RboYOTkkBEwkrh3bzQZhi0lcuLceyObiEBJYxiix7c0zVpiin1NOQCWmM0ocOv+ZFcL5yyjx
	5OomJpAqNgENicPvn7GDJEQEjjJK7Nk+BcxhFljIKLG0+xUjRMssRokf31rANnIKmEtsW7ya
	GcQWFnCUmPp1GguIzSKgKrHw30uwGl4BW4ktjUuhbEGJH5PvAdVwAE1Vl5gyJRckzCygLfHk
	3QVWkLAEUPjRX10QU0TASGLLAgWIChGJfS/egV0gIdDLIdFzaQMzxCYBiW+TD7FAtMpKbDrA
	DPGxpMTBFTdYJjBKzEKydxbC3llI9s5CsmEBI8sqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxN
	jJA4793BePuA9SHGZKDtE5mlRJPzgWkiryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2MmeIPUyaYPbG+fnp+oqp/VuvCX2pn5Xmvvt3dJp97J/WI
	HBdP+rLJXw+9Z9pj9Fxszqfmq+HuES6KyxVfnGv/bdy+f+fPQ8x6F5dIRv1k2P3LxPn/p2X8
	OnOs27iOLV8x4fPJ7KDpBycm/6tbqdhjlLvixboZy3zWax33qjCyrDKs+HIg6dVRRyWW4oxE
	Qy3mouJEAK5j260JAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jQd3mxf6BBttnWlhMWneAyeLf7FNs
	Fqum7mSx2PT4GqvF5V1z2CxmnN/HZHH7Mq/FoltnmC1Od7M6cHq0NPewefxd9YLZY97JQI/N
	S+o9Xk78zebR/9fAY+P2J0wenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
	GlpamCsp5CXmptoqufgE6Lpl5gDdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfI
	AA0krGPMOPK7j7VgrWTFgcN3GRsYD4p0MXJySAiYSPyccoINwhaTuHBvPZDNxSEkMJ1R4tD5
	z6wQzl9GiSdXNzGBVLEJaEgcfv+MHSQhInCUUWLP9ilgDrPAQkaJpd2vGCFaZjFK/PjWAjaY
	U8BcYtvi1cwgtrCAo8TUr9NYQGwWAVWJhf9egtXwCthKbGlcCmULSvyYfA+ohgNoqrrElCm5
	IGFmAW2JJ+8usIKEJYDCj/7qgpgiAkYSWxYoQFSISOx78Y5xAqPQLCRzZiHMmYVkziwkHQsY
	WVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeRZ9I7GFc1WBxiFOBgVOLhFajxDxRiTSwr
	rsw9xCjBwawkwrugHyjEm5JYWZValB9fVJqTWnyIMRnoy4nMUqLJ+cAEl1cSb2hsYmZkaWRm
	YWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjBtEbB7sOrp69SfbRyf01+y+lh+/
	8XDb1idPJj7Ju249v26d0d3VYep73/ZsmOTgEPpIpdHeNLdn4pNT3RfvOPqIi+yrfCDC8ZLZ
	jt1QeEvEjbsL37zcrPD6wOeCa09k3TSn5ARfOPrwQsaapWuW3BHc6lTSd/91eduS233PJ3ZX
	v6iZrSux4GWhEktxRqKhFnNRcSIAWrNZYGYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Twelve Kconfig symbols, all related to WM8350, WM8351, and WM8352, are
> unused. Commit 19d57ed5a308472a02e773f33c03ad4cb2ec6a9 ("mfd: Remove
> custom wm8350 cache implementation") removed all their (actual) users.
> Remove these symbols too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

> ---
> 0) This version adds Mark's ACK. It is now also sent to the ARM
> maintainers, as Mark suggested.
> 
> 1) Still only eyeball tested.
> 
>  arch/arm/mach-imx/Kconfig     |  2 --
>  arch/arm/mach-s3c64xx/Kconfig |  3 ---
>  drivers/mfd/Kconfig           | 48 -----------------------------------------
> --
>  3 files changed, 53 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 4c9c6f9..6d9ae09 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -481,8 +481,6 @@ config MACH_MX31ADS_WM1133_EV1
>  	depends on MACH_MX31ADS
>  	depends on MFD_WM8350_I2C
>  	depends on REGULATOR_WM8350 = y
> -	select MFD_WM8350_CONFIG_MODE_0
> -	select MFD_WM8352_CONFIG_MODE_0
>  	help
>  	  Include support for the Wolfson Microelectronics 1133-EV1 PMU
>  	  and audio module for the MX31ADS platform.
> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
> index 131c862..041da51 100644
> --- a/arch/arm/mach-s3c64xx/Kconfig
> +++ b/arch/arm/mach-s3c64xx/Kconfig
> @@ -198,10 +198,7 @@ endchoice
>  config SMDK6410_WM1190_EV1
>  	bool "Support Wolfson Microelectronics 1190-EV1 PMIC card"
>  	depends on MACH_SMDK6410
> -	select MFD_WM8350_CONFIG_MODE_0
> -	select MFD_WM8350_CONFIG_MODE_3
>  	select MFD_WM8350_I2C
> -	select MFD_WM8352_CONFIG_MODE_0
>  	select REGULATOR
>  	select REGULATOR_WM8350
>  	select SAMSUNG_GPIO_EXTRA64
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index c346941..ebb1bed 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -687,54 +687,6 @@ config MFD_WM8350
>  	bool
>  	depends on GENERIC_HARDIRQS
> 
> -config MFD_WM8350_CONFIG_MODE_0
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8350_CONFIG_MODE_1
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8350_CONFIG_MODE_2
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8350_CONFIG_MODE_3
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8351_CONFIG_MODE_0
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8351_CONFIG_MODE_1
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8351_CONFIG_MODE_2
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8351_CONFIG_MODE_3
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8352_CONFIG_MODE_0
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8352_CONFIG_MODE_1
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8352_CONFIG_MODE_2
> -	bool
> -	depends on MFD_WM8350
> -
> -config MFD_WM8352_CONFIG_MODE_3
> -	bool
> -	depends on MFD_WM8350
> -
>  config MFD_WM8350_I2C
>  	bool "Support Wolfson Microelectronics WM8350 with I2C"
>  	select MFD_WM8350
> --
> 1.7.11.7

