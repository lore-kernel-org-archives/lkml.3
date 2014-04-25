Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaDYI6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:58:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10666 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaDYI6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:58:40 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-d6-535a23be43e9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Peter Griffin'" <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
 <1398342509-10243-11-git-send-email-peter.griffin@linaro.org>
In-reply-to: <1398342509-10243-11-git-send-email-peter.griffin@linaro.org>
Subject: Re: [PATCH 10/13] video/pxa: LCD_CORGI needs BACKLIGHT_CLASS_DEVICE
Date: Fri, 25 Apr 2014 17:58:38 +0900
Message-id: <000701cf6064$8c4482d0$a4cd8870$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9fumKcpcQftRQuQk+6J+WrGkf9WgAqgvEQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zvu4+5ahgg7X9KhZ/Jx1jtzi6cyKT
	xeWFl1gt7n89ymjx/tAzZosTfR9YLS7vmsNmsWHGPxaLdQ9fMFmsn3+LzYHL4/evSYweO2fd
	Zfd4deEOi8eda3vYPG7/e8zs0bdlFaPH8RvbmTw+b5IL4IjisklJzcksSy3St0vgyljz8TRz
	QSd3xeWNh9kaGLs4uxg5OSQETCT+n2xihLDFJC7cW8/WxcjFISSwjFGi7cpyNpiifW0PWCES
	0xklPv9+xQzh/GaUOLXwHQtIFZuAmsSXL4fZQWwRAR+J2xOns4MUMQtsZ5LYf3kFI0RHB6PE
	g8/9YFWcAl4Sx2ZMAdshDNSx6HAH2CEsAqoSt37tZwaxeQVsJb7+WcUOYQtK/Jh8D2wbs4CW
	xPqdx5kgbHmJzWveAtVzAN2qLvHory7EEUYSc+eeZoYoEZHY9+Id2A0SAnM5JL6eOM0CsUtA
	4tvkQywQvbISmw4wQ7wsKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kale
	cWJucWleul5yfu4mRkj8T9zBeP+A9SHGZKD1E5mlRJPzgekjryTe0NjMyMLUxNTYyNzSjDRh
	JXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYjf4Eb9xc32Ue51cc9iPPQvtjTxWz
	fcmchZyyYQ0Lrc4yZh1hVUt333IgvmV/kf9CdxPD1Ttz5854tnH5/oC/vvr9zn1MrRNuHTyw
	PritNMRhR+tUea63YbvMWOc/WPA/l2H1MrbpaTYhCcJ73Fd37Wn4M/vr3uVq39R51m9bF1AZ
	VRvSZ5iixFKckWioxVxUnAgAmXAceBUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQd19ylHBBm0n5S3+TjrGbnF050Qm
	i8sLL7Fa3P96lNHi/aFnzBYn+j6wWlzeNYfNYsOMfywW6x6+YLJYP/8WmwOXx+9fkxg9ds66
	y+7x6sIdFo871/awedz+95jZo2/LKkaP4ze2M3l83iQXwBHVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SlkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjFjzcfTzAWd3BWXNx5ma2Ds4uxi5OSQEDCR2Nf2gBXCFpO4cG89
	WxcjF4eQwHRGic+/XzFDOL8ZJU4tfMcCUsUmoCbx5cthdhBbRMBH4vbE6ewgRcwC25kk9l9e
	wQjR0cEo8eBzP1gVp4CXxLEZU9hAbGGgjkWHOxhBbBYBVYlbv/Yzg9i8ArYSX/+sYoewBSV+
	TL4Hto1ZQEti/c7jTBC2vMTmNW+B6jmAblWXePRXF+III4m5c08zQ5SISOx78Y5xAqPQLCST
	ZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4uz6R3MK5qsDjEKMDB
	qMTDO0E2MliINbGsuDL3EKMEB7OSCO8MiahgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4H
	Jr68knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamC0NPI6rB63
	7WYjb8+8gzLX3JuuNz389u7znmM3zmzY4FdZYnx/mf9eDteIPfMFlIpNrYR2TXrFemJ5clGA
	yycBt+ba9efmzHuZey5ujtl12VvGPcFBhQ/OPHSaaeMzvW3b8z0/7Bcv1Q00YjF22u+iKvmA
	/f0c/3lCh7pWCLU3n1wT1Cy1Ws5eiaU4I9FQi7moOBEA6hZFcnIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 9:28 PM, Peter Griffin wrote:
> 
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This fixes a randconfig build error when BACKLIGHT_CLASS_DEVICE
> is disabled, by describing the dependency in Kconfig,
> as we do for the other drivers in this directory.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/backlight/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index ac6bc28..5675511 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -29,7 +29,7 @@ if LCD_CLASS_DEVICE
> 
>  config LCD_CORGI
>  	tristate "LCD Panel support for SHARP corgi/spitz model"
> -	depends on SPI_MASTER && PXA_SHARPSL
> +	depends on SPI_MASTER && PXA_SHARPSL && BACKLIGHT_CLASS_DEVICE
>  	help
>  	  Say y here to support the LCD panels usually found on SHARP
>  	  corgi (C7x0) and spitz (Cxx00) models.
> --
> 1.7.9.5

