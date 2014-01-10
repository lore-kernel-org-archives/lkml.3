Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaAJBQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:16:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23865 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaAJBQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:16:33 -0500
X-AuditID: cbfee68f-b7f156d00000276c-9b-52cf49ef9d1c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Yuvaraj Kumar C D'" <yuvaraj.cd@gmail.com>, kishon@ti.com
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, mark.rutland@arm.com,
        b.zolnierkie@samsung.com, joshi@samsung.com, t.figa@samsung.com,
        swarren@wwwdotorg.org, rob.herring@calxeda.com,
        grant.likely@linaro.org, christoffer.dall@linaro.org,
        linux-ide@vger.kernel.org,
        "'Yuvaraj Kumar C D'" <yuvaraj.cd@samsung.com>,
        "'Girish K S'" <ks.giri@samsung.com>,
        "'Vasanth Ananthan'" <vasanth.a@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1389262005-30399-1-git-send-email-yuvaraj.cd@samsung.com>
 <1389262005-30399-2-git-send-email-yuvaraj.cd@samsung.com>
In-reply-to: <1389262005-30399-2-git-send-email-yuvaraj.cd@samsung.com>
Subject: Re: [PATCH V5 1/2] PHY: Exynos: Add Exynos5250 SATA PHY driver
Date: Fri, 10 Jan 2014 10:16:30 +0900
Message-id: <002901cf0da1$98335370$c899fa50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8NIsOtvDaeBSkxQsCYSQ2TTms6NQAfLoSQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t8zI933nueDDA51GFhsnLGe1eLF63+M
	FvOPnGO1OPBnB6PF5YWXWC2+7/rCbtG74CqbxYWnPWwW84/uYLLY9Pgaq8XCtiUsFsd2PGKy
	uLxrDpvF0usXmSwOrzjAZPHqYBuLxfoZr1ksVq07zGbx8Gg3q8XZU+UOIh5r5q1h9Fjw+Qq7
	x85Zd9k97lzbw+axeUm9R9+WVYwex29sZ/L4vEnOY+Pc0ADOKC6blNSczLLUIn27BK6MfbMW
	MhUcV644OXkLawPjGpkuRk4OCQETiRl77jBD2GISF+6tZ+ti5OIQEljGKHFp7wQ2mKJry94z
	QySmM0psWzyRFcL5xShxZOZysHY2ATWJL18Os4PYIgK2EsufLGYHKWIWmMMi8e/5fhaIjmZG
	iU3bFrGCVHEKuEvMfdDPAmILA9kfJu4Fs1kEVCXunt0HNokXaNLMb80sELagxI/J98BsZgEt
	ifU7jzNB2PISm9e8BbqCA+hWdYlHf3UhjjCS2NV5hxGiRERi34t3jCA3SAg84ZBY/Ho6E8Qu
	AYlvkw+xQPTKSmw6AA0LSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi4z1
	ihNzi0vz0vWS83M3MULSTP8OxrsHrA8xJgOtn8gsJZqcD0xTeSXxhsZmRhamJqbGRuaWZqQJ
	K4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUbWm50x48f3FRl5lLfvPFpSzr1/c
	tj/5zpSnN0V9/XWezxZ7osgzeclalp8ck+KqHBfzpn2tiQ5smmiwSXHVHrHQCYps3GZx2z2O
	uTwNnSA9a9uWP97MotYBLF9sknazhSsWPBTtcQ/XqO//0JN85MM0+ftS55Yal7r/SX87je3l
	TKZHnvdXKrEUZyQaajEXFScCAH51yYNJAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsVy+t9jQd33nueDDLau1LTYOGM9q8WL1/8Y
	LeYfOcdqceDPDkaLywsvsVp83/WF3aJ3wVU2iwtPe9gs5h/dwWSx6fE1VouFbUtYLI7teMRk
	cXnXHDaLpdcvMlkcXnGAyeLVwTYWi/UzXrNYrFp3mM3i4dFuVouzp8odRDzWzFvD6LHg8xV2
	j52z7rJ73Lm2h81j85J6j74tqxg9jt/YzuTxeZOcx8a5oQGcUQ2MNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAnykplCXmlAKFAhKLi5X07TBNCA1x
	07WAaYzQ9Q0JgusxMkADCesYM/bNWshUcFy54uTkLawNjGtkuhg5OSQETCSuLXvPDGGLSVy4
	t56ti5GLQ0hgOqPEtsUTWSGcX4wSR2YuB6tiE1CT+PLlMDuILSJgK7H8yWJ2kCJmgTksEv+e
	72eB6GhmlNi0bRErSBWngLvE3Af9LCC2MJD9YeJeMJtFQFXi7tl9YJN4gSbN/NbMAmELSvyY
	fA/MZhbQkli/8zgThC0vsXnNW6ArOIBuVZd49FcX4ggjiV2ddxghSkQk9r14xziBUWgWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEJ7Fn0jsYVzVYHGIU4GBU
	4uFdUXw2SIg1say4MvcQowQHs5IIr6fb+SAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcm
	2LySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPQI3BYzmbs3
	JXB/+32PfG7JojsV54rfBYs+dnQ86XbmmQ7T31zV8Okvthf/OrM2/n2bxGSuIIEKnvCi/wL7
	dM0nNfm6pYktVygOZssw07kYvOMjn9vGE98rhb/0hlh9sr5tlGAqdftB/Sw+PoHlbvun37y6
	0TbwwOxwS5WpvrZPZ/pY6S4tU2Ipzkg01GIuKk4EAAg9P+qmAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 7:07 PM, Yuvaraj Kumar C D wrote:
> 
> This patch adds the SATA PHY driver for Exynos5250.Exynos5250 SATA
> PHY comprises of CMU and TRSV blocks which are of I2C register Map.
> So this patch also adds a i2c client driver, which is used configure
> the CMU and TRSV block of exynos5250 SATA PHY.
> 
> This patch incorporates the generic PHY framework to deal with SATA
> PHY.
> 
> This patch depends on the below patches
> 	[1].drivers: phy: add generic PHY framework
> 		by Kishon Vijay Abraham I<kishon@ti.com>
> 	[2].ata: ahci_platform: Manage SATA PHY
> 		by Roger Quadros <rogerq@ti.com>
> 
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> Signed-off-by: Vasanth Ananthan <vasanth.a@samsung.com>

Hi Yuvaraj Kumar,

It looks good.
However, I added some minor comments. :-)

Also, you need to base against the following Kishon's PHY git tree,
next branch. Then, Kishon will apply your patch more easily.

T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git


> ---
> Changes from V4:
> 	1.Made Exynos5250 SATA PHY driver by default selects
> 	CONFIG_I2C and CONFIG_I2C_S3C2410, as SATA PHY driver
> 	depends on I2C.
> 	2.struct i2c_driver sataphy_i2c_driver made static which
> 	was earlier global type.
> 	3.Renamed the files to phy-exynos5250-sata.c and
> 	phy-exynos5250-sata-i2c.c and CONFIG_EXYNOS5250_SATA_PHY
> 	to CONFIG_PHY_EXYNOS5250_SATA.
> 
> Changes from V3:
> 	1.Moved devm_phy_create before to devm_phy_provider_register.
> 
> Changes from V2:
> 	1.Removed of_match_table
> 	2.Moved to syscon interface for PMU handling.
> 
> Changes from V1:
> 	1.Adapted to latest version of Generic PHY framework
> 	2.Removed exynos_sata_i2c_remove function.
> 
>  drivers/phy/Kconfig                   |   13 ++
>  drivers/phy/Makefile                  |    1 +
>  drivers/phy/phy-exynos5250-sata-i2c.c |   40 ++++++
>  drivers/phy/phy-exynos5250-sata.c     |  238 +++++++++++++++++++++++++++++++++
>  4 files changed, 292 insertions(+)
>  create mode 100644 drivers/phy/phy-exynos5250-sata-i2c.c
>  create mode 100644 drivers/phy/phy-exynos5250-sata.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index d0611b8..de1c165 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -57,4 +57,17 @@ config PHY_EXYNOS_DP_VIDEO
>  	help
>  	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
> 
> +config PHY_EXYNOS5250_SATA
> +	tristate "Exynos5250 Sata SerDes/PHY driver"
> +	depends on SOC_EXYNOS5250
> +	select GENERIC_PHY
> +	select I2C
> +	select I2C_S3C2410
> +	select MFD_SYSCON
> +	help
> +	  Enable this to support SATA SerDes/Phy found on Samsung's
> +	  Exynos5250 based SoCs.This SerDes/Phy supports SATA 1.5 Gb/s,
> +	  SATA 3.0 Gb/s, SATA 6.0 Gb/s speeds.It supports one SATA host
                                                          ^
One space between 'speeds.' and 'It' is needed as below.

+	  SATA 3.0 Gb/s, SATA 6.0 Gb/s speeds. It supports one SATA host

> +	  port to accept one SATA device.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 4e4adc9..8ccf8c3 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> +obj-$(CONFIG_PHY_EXYNOS5250_SATA)	+= phy-exynos5250-sata.o phy-exynos5250-sata-i2c.o
> diff --git a/drivers/phy/phy-exynos5250-sata-i2c.c b/drivers/phy/phy-exynos5250-sata-i2c.c
> new file mode 100644
> index 0000000..83bd6ee
> --- /dev/null
> +++ b/drivers/phy/phy-exynos5250-sata-i2c.c
> @@ -0,0 +1,40 @@

[.....]

> +static struct i2c_driver sataphy_i2c_driver = {
> +	.probe		= exynos_sata_i2c_probe,
> +	.id_table	= sataphy_i2c_device_match,
> +	.driver   = {
> +		.name = "exynos-sataphy-i2c",
> +		.owner = THIS_MODULE,
> +		},

There is an indent coding style issue.
The following is right.

+	},


[.....]

> +
> +MODULE_DESCRIPTION("Samsung SerDes PHY driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("ks.giri <ks.giri@samsung.com>");

The following is more preferable.
+MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");

Best regards,
Jingoo Han

> +MODULE_AUTHOR("Yuvaraj C D <yuvaraj.cd@samsung.com>");
> --
> 1.7.9.5

