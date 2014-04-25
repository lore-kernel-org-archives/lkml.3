Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaDYJAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:00:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34856 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaDYJAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:00:40 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a1-535a24363c97
From: Jingoo Han <jg1.han@samsung.com>
To: "'Peter Griffin'" <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
 <1398342509-10243-9-git-send-email-peter.griffin@linaro.org>
In-reply-to: <1398342509-10243-9-git-send-email-peter.griffin@linaro.org>
Subject: Re: [PATCH 08/13] video/backlight: LM3630A needs PWM
Date: Fri, 25 Apr 2014 18:00:38 +0900
Message-id: <000801cf6064$d3db1460$7b913d20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9fuerOUca2nTv6Qbe0KfiEeqUbeAAqsj9g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zQ10zlahgg3lTtCz+TjrGbnF050Qm
	i8sLL7Fa3P96lNHi/aFnzBYn+j6wWlzeNYfNYsOMfywW6x6+YLJYP/8WmwOXx+9fkxg9ds66
	y+7x6sIdFo871/awedz+95jZo2/LKkaP4ze2M3l83iQXwBHFZZOSmpNZllqkb5fAlfHi1imm
	gtncFc3t79gaGOdwdjFycEgImEhMuFbXxcgJZIpJXLi3nq2LkYtDSGAZo8SeR6uZIBImEi+2
	bAOzhQQWMUr07K+CKPrNKNH+6CZYgk1ATeLLl8PsILaIgI/E7YnT2UGKmAW2M0nsv7yCEaK7
	nVFi+2JjEJtTwFOic/liZhBbWMBW4tTMGWCDWARUJd42rQer5wWKn3vyhQnCFpT4MfkeC4jN
	LKAlsX7ncSYIW15i85q3zBDfqEs8+qsLYooIGEk8WqUMUSEise/FO0aQcyQEZnJI/Nrczgqx
	SkDi2+RDLBCtshKbDjBD/CspcXDFDZYJjBKzkCyehWTxLCSLZyFZsYCRZRWjaGpBckFxUnqR
	sV5xYm5xaV66XnJ+7iZGSNz372C8e8D6EGMy0PqJzFKiyfnAtJFXEm9obGZkYWpiamxkbmlG
	mrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgP+2t/rf44sWez95z7GYdsRGQ6
	O4TX3hcsz9jxgevI7N8cqVtjTQ63S874kvxDR2v2RjtThoBH/LUmqmcOTF5xVn3/r4OHfdf7
	8E77JZmWGa5R/Wj7Qrafy3YpuC5gSopv/5l/3uGUoaRl42SpH0IhC9YWiFrt3J+i+vWbq4em
	fu36pJMijkpKLMUZiYZazEXFiQDVQapREQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jAV0zlahgg/blqhZ/Jx1jtzi6cyKT
	xeWFl1gt7n89ymjx/tAzZosTfR9YLS7vmsNmsWHGPxaLdQ9fMFmsn3+LzYHL4/evSYweO2fd
	Zfd4deEOi8eda3vYPG7/e8zs0bdlFaPH8RvbmTw+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3
	VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpSSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYx5jx4tYppoLZ3BXN7e/YGhjncHYxcnJICJhIvNiyjQnCFpO4cG89
	G4gtJLCIUaJnf1UXIxeQ/ZtRov3RTbAiNgE1iS9fDrOD2CICPhK3J05nByliFtjOJLH/8gpG
	iO52Ronti41BbE4BT4nO5YuZQWxhAVuJUzNngA1iEVCVeNu0HqyeFyh+7skXJghbUOLH5Hss
	IDazgJbE+p3HmSBseYnNa94CzeEAulRd4tFfXRBTRMBI4tEqZYgKEYl9L94xTmAUmoVk0Cwk
	g2YhGTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFp5ZnUDsaVDRaHGAU4GJV4
	eD+oRQYLsSaWFVfmHmKU4GBWEuGdIREVLMSbklhZlVqUH19UmpNafIgxGejPicxSosn5wJSX
	VxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MG3Q+LNawYE1u
	f6aZvj8ufuN0gZ/GlvqxMX4b7xfENK/vZJObG+NTYiaaJdrfPV3PxmlK+9dSnR9BF7QXv5zD
	bdR61LRF27CtqEaE9/GVr9xnYkRM2kq/TK/e43etfK5H3zczb/X5bCz5PPVTpmt+aWVI+Pxf
	fGWBioS+uMWtZUdC/U/U+CixFGckGmoxFxUnAgCreSdwbwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 9:28 PM, Peter Griffin wrote:
> 
> The LM3630A driver cannot be successfully built if we don't
> enable the PWM subsystem. This patch makes that dependency
> explicit in Kconfig and prevents broken randconfig builds.
> 
> Based on Arnd Bergmann patch but split out into seperate
> commits per driver based on feedback.
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
> index 5a3eb2e..4791af7 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -370,7 +370,7 @@ config BACKLIGHT_AAT2870
> 
>  config BACKLIGHT_LM3630A
>  	tristate "Backlight Driver for LM3630A"
> -	depends on BACKLIGHT_CLASS_DEVICE && I2C
> +	depends on BACKLIGHT_CLASS_DEVICE && I2C && PWM
>  	select REGMAP_I2C
>  	help
>  	  This supports TI LM3630A Backlight Driver
> --
> 1.7.9.5

