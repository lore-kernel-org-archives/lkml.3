Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaHFEXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:23:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32247 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaHFEXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:23:48 -0400
X-AuditID: cbfee690-b7f526d000003627-7a-53e1add19368
From: Jingoo Han <jg1.han@samsung.com>
To: "'Xiubo Li'" <Li.Xiubo@freescale.com>
Cc: wsa@the-dreams.de, linux-i2c@vger.kernel.org, joe@perches.com,
        s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, b35083@freescale.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1407296708-12563-1-git-send-email-Li.Xiubo@freescale.com>
In-reply-to: <1407296708-12563-1-git-send-email-Li.Xiubo@freescale.com>
Subject: Re: [PATCHv2] i2c: i2c-imx: Fix format warning for dev_dbg
Date: Wed, 06 Aug 2014 13:23:45 +0900
Message-id: <002801cfb12e$36620840$a32618c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+xKWQ0VCAedggwTJaugPktvAxwmgABI52Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zQ92Lax8GG/S9N7eYdXc/u8XlhZdY
	LWbff8xi0Xmhg9Wi4+8XRovLu+awWfzdvonF4vbEyYwWK0/MYnbg9Ph3uJ/Jo/+vgceXVdeY
	Pfq2rGL0OHnqCYvH501yAWxRXDYpqTmZZalF+nYJXBlTfp1nLzgjUPHq/wL2BsZXvF2MHBwS
	AiYSk3/rdzFyApliEhfurWcDsYUEljFKnGoQg4ibSNw8vJ6xi5ELKD6dUWLf3KPMEM5vRonm
	G1vAOtgE1CS+fDnMDmKLCKhLHNj2nR2kiFngOqNEw+xmdoixbhIrvy4Ha+AUcJc4duocO8gV
	wgLOEr//lICEWQRUJa7e/wlWzitgK3FzYQMrhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5kh
	nlGXePRXF+IEI4lnv06yQZSISOx78Q7sAQmBRg6JI/3TmSB2CUh8m3yIBaJXVmLTAWaIhyUl
	Dq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIiesJ
	OxjvHbA+xJgMtH4is5Rocj4wLeSVxBsamxlZmJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA2Mht1sZs5MUT8KVmrZsr8JFrJdZjVb+L73w580pfrbeZHXfgPeb
	V12zi1yVrjj5yI4tV29Jnoo8uTDrXsy634ULp+ypvnte2ErNREr1w3H1qf6yM+b8Nyo8Inth
	3enku7eFEqt5Q19ObAjaGPJReeGfqtme8pJVNy/9sdGVeHtKxTHeUjLq60ElluKMREMt5qLi
	RACnO0wrAQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd2Lax8GG8xYb2wx6+5+dovLCy+x
	Wsy+/5jFovNCB6tFx98vjBaXd81hs/i7fROLxe2JkxktVp6YxezA6fHvcD+TR/9fA48vq64x
	e/RtWcXocfLUExaPz5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm
	TPl1nr3gjEDFq/8L2BsYX/F2MXJySAiYSNw8vJ4RwhaTuHBvPVsXIxeHkMB0Rol9c48yQzi/
	GSWab2xhA6liE1CT+PLlMDuILSKgLnFg23d2kCJmgeuMEg2zm8ESQgJuEiu/Lgdr4BRwlzh2
	6hxQnINDWMBZ4vefEpAwi4CqxNX7P8HKeQVsJW4ubGCFsAUlfky+xwJiMwtoSazfeZwJwpaX
	2LzmLTPIGAmgvY/+6kKcYCTx7NdJNogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGJ45nUDsaVDRaHGAU4GJV4eDNMHwYLsSaWFVfmHmKU
	4GBWEuHdEg8U4k1JrKxKLcqPLyrNSS0+xGgK9OhEZinR5HxgUssriTc0NjEzsjQyszAyMTdX
	Euc90GodKCSQnliSmp2aWpBaBNPHxMEp1cBof/xWoNmuyXOX7J90oa0u5cuWvJm/ePTPJxzZ
	yZ7bv2hBb+VlEda+q0lz1ni1tfjKmK5Ys9JJ2a09JqqH6/33Y3qO8v5eL8yVePSD360X/Coo
	0/6wVb9x5SZBE88SBV+j5p5ghl/923q+9DJ/tjx1ROrhL5/bjLVZ347asv1bZxHPKjH5Ob8S
	S3FGoqEWc1FxIgA06k0iMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 06, 2014 12:45 PM, Xiubo Li wrote:

The subject of the commit looks too general.
How about the following?

i2c: i2c-imx: Use printf extension %pR for struct resource

Best regards,
Jingoo Han

> 
> drivers/i2c/busses/i2c-imx.c: In function i2c_imx_probe()
> drivers/i2c/busses/i2c-imx.c:689:2: warning: format 0x%x expects argument
> of type unsigned int, but argument 4 has type resource_size_t [-Wformat=]
>   dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
>   ^
> drivers/i2c/busses/i2c-imx.c:689:2: warning: format 0x%x expects argument
> of type unsigned int, but argument 5 has type resource_size_t [-Wformat=]
> 
> drivers/i2c/busses/i2c-imx.c:691:2: warning: format %d expects argument
> of type int, but argument 4 has type resource_size_t [-Wformat=]
>   dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
>   ^
> drivers/i2c/busses/i2c-imx.c:691:2: warning: format 0x%x expects argument
> of type unsigned int, but argument 5 has type resource_size_t [-Wformat=]
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
> 
> Change in v2:
> - Follow Joe Perches's advice.
> 
> 
> 
> 
> 
>  drivers/i2c/busses/i2c-imx.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index 1d7efa3..b8a9543 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -686,10 +686,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
>  	clk_disable_unprepare(i2c_imx->clk);
> 
>  	dev_dbg(&i2c_imx->adapter.dev, "claimed irq %d\n", irq);
> -	dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
> -		res->start, res->end);
> -	dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
> -		resource_size(res), res->start);
> +	dev_dbg(&i2c_imx->adapter.dev, "device resources: %pR\n", res);
>  	dev_dbg(&i2c_imx->adapter.dev, "adapter name: \"%s\"\n",
>  		i2c_imx->adapter.name);
>  	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
> --
> 1.8.5

