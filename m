Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaI3RWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:22:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60560 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbaI3RWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:22:23 -0400
Message-ID: <542AE6C2.6050703@ti.com>
Date: Tue, 30 Sep 2014 20:22:10 +0300
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <kernel-build-reports@lists.linaro.org>,
        <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH] clk: gpio-gate: Ensure gpiod_ APIs are prototyped
References: <1412097382-8351-1-git-send-email-broonie@kernel.org>
In-Reply-To: <1412097382-8351-1-git-send-email-broonie@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 08:16 PM, Mark Brown wrote:
> The gpio-gate clock uses the gpiod_ APIs but does not directly include the
> header for them causing build failures in some configurations including ARM
> allnoconfig. Include the header directly.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Jyri Sarha <jsarha@ti.com>

Thanks.
Jyri

> ---
>   drivers/clk/clk-gpio-gate.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clk/clk-gpio-gate.c b/drivers/clk/clk-gpio-gate.c
> index 9dde88533684..08e43224fd52 100644
> --- a/drivers/clk/clk-gpio-gate.c
> +++ b/drivers/clk/clk-gpio-gate.c
> @@ -13,6 +13,7 @@
>   #include <linux/module.h>
>   #include <linux/slab.h>
>   #include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>   #include <linux/of_gpio.h>
>   #include <linux/err.h>
>   #include <linux/device.h>
>

