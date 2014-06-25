Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaFYKS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:18:59 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45513 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaFYKS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:18:56 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-7c-53aaa20e7aff
Message-id: <1403691532.22107.8.camel@AMDC1943>
Subject: Re: [PATCH v3 03/14] clk: max77686: Add DT include for MAX77686 PMIC
 clock
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 12:18:52 +0200
In-reply-to: <1403202040-12641-4-git-send-email-javier.martinez@collabora.co.uk>
References: <1403202040-12641-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403202040-12641-4-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4FV2+RauCDV7OYrZYcvEqu8XUh0/Y
	LDb1b2W3mH/kHKvF2WUH2SyO/i6w6F1wlc3i/tejjBbfrnQwWWx6fI3V4vKuOWwWM87vY7J4
	OuEim8Wp65/ZLE53s1pMP/6W1aJv7SU2B0GP2Q0XWTz+Pr/O4rHj7hJGj52z7rJ7bFrVyeZx
	59oeNo95JwM9Ni+p97hyoonVo2/LKkaP6fN+Mnl83iQXwBPFZZOSmpNZllqkb5fAlfGxR6rg
	pUDF+tvPGRsYH/N2MXJySAiYSHx9OZsJwhaTuHBvPVsXIxeHkMBSRolVH78yQzifGSVWTp3E
	AlLFK6AvcbN7FViHsECoxNzLE8FsNgFjic3Ll7CB2CICdhI3Vj8Ea2YWeMQi8WjLH8YuRg4O
	FgFViXWPHUFqOAUCJLoeTWCEWDCVUWLX9Slgg5gF1CUmzVvEDHGSssS8/ceYIBYLSvyYfI8F
	okZeYvOat8wTGAVmIWmZhaRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCIvHL
	DsbFx6wOMQpwMCrx8AbwrAoWYk0sK67MPcQowcGsJMLrOAcoxJuSWFmVWpQfX1Sak1p8iJGJ
	g1OqgVHmkMwaS6klfTKRT4uULgROz5nxYvqSKYsOnsnI2sWV/ENsh/Hk8+5GNdvSJPZLPbyW
	UlqwNk+16cSy5h9mL6LddmVrN02/rxl2O2OF7tzft6Lf3tjLEXyId6OC3Y1VEzf5V9w8ez4r
	5diMS5K2v/K70yau9ldZXC3/z/2nt4tDa/NM3Ye7tgsrsRRnJBpqMRcVJwIA3+42eaICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-06-19 at 20:20 +0200, Javier Martinez Canillas wrote:
> This patch adds a dt-binding include for Maxim 77686
> PMIC clock IDs that can be to be shared between the
> clk-max77686 clock driver and DeviceTree source files.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/clk/clk-max77686.c                 |  7 +------
>  include/dt-bindings/clock/maxim,max77686.h | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+), 6 deletions(-)
>  create mode 100644 include/dt-bindings/clock/maxim,max77686.h

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> 
> diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
> index 3d7e8dd..185b611 100644
> --- a/drivers/clk/clk-max77686.c
> +++ b/drivers/clk/clk-max77686.c
> @@ -30,12 +30,7 @@
>  #include <linux/mutex.h>
>  #include <linux/clkdev.h>
>  
> -enum {
> -	MAX77686_CLK_AP = 0,
> -	MAX77686_CLK_CP,
> -	MAX77686_CLK_PMIC,
> -	MAX77686_CLKS_NUM,
> -};
> +#include <dt-bindings/clock/maxim,max77686.h>
>  
>  struct max77686_clk {
>  	struct max77686_dev *iodev;
> diff --git a/include/dt-bindings/clock/maxim,max77686.h b/include/dt-bindings/clock/maxim,max77686.h
> new file mode 100644
> index 0000000..7b28b09
> --- /dev/null
> +++ b/include/dt-bindings/clock/maxim,max77686.h
> @@ -0,0 +1,23 @@
> +/*
> + * Copyright (C) 2014 Google, Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Device Tree binding constants clocks for the Maxim 77686 PMIC.
> + */
> +
> +#ifndef _DT_BINDINGS_CLOCK_MAXIM_MAX77686_CLOCK_H
> +#define _DT_BINDINGS_CLOCK_MAXIM_MAX77686_CLOCK_H
> +
> +/* Fixed rate clocks. */
> +
> +#define MAX77686_CLK_AP		0
> +#define MAX77686_CLK_CP		1
> +#define MAX77686_CLK_PMIC	2
> +
> +/* Total number of clocks. */
> +#define MAX77686_CLKS_NUM		(MAX77686_CLK_PMIC + 1)
> +
> +#endif /* _DT_BINDINGS_CLOCK_MAXIM_MAX77686_CLOCK_H */

