Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaI3S6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:58:55 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43485 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaI3S6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:58:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mark Brown <broonie@kernel.org>, "Jyri Sarha" <jsarha@ti.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1412097382-8351-1-git-send-email-broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, "Mark Brown" <broonie@kernel.org>
References: <1412097382-8351-1-git-send-email-broonie@kernel.org>
Message-ID: <20140930185828.19023.40412@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: gpio-gate: Ensure gpiod_ APIs are prototyped
Date: Tue, 30 Sep 2014 11:58:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark Brown (2014-09-30 10:16:22)
> The gpio-gate clock uses the gpiod_ APIs but does not directly include the
> header for them causing build failures in some configurations including ARM
> allnoconfig. Include the header directly.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Thanks Mark. Applied.

Regards,
Mike

> ---
>  drivers/clk/clk-gpio-gate.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/clk-gpio-gate.c b/drivers/clk/clk-gpio-gate.c
> index 9dde88533684..08e43224fd52 100644
> --- a/drivers/clk/clk-gpio-gate.c
> +++ b/drivers/clk/clk-gpio-gate.c
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/of_gpio.h>
>  #include <linux/err.h>
>  #include <linux/device.h>
> -- 
> 2.1.1
> 
