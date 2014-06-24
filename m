Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaFXK05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:26:57 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33174 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaFXK0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:26:54 -0400
Date: Tue, 24 Jun 2014 11:26:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH] gpio: crystalcove: Fix implicit declaration of function
 'seq_printf' error
Message-ID: <20140624102643.GJ13803@lee--X1>
References: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
 <1403265753-25851-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403265753-25851-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm... a leftover patch in my 'send' directory I feel!

Please ignore.

> drivers/gpio/gpio-crystalcove.c: In function 'crystalcove_gpio_dbg_show':
> drivers/gpio/gpio-crystalcove.c:286:3: error: implicit declaration of function 'seq_printf'
>    seq_printf(s, " gpio-%-2d %s %s %s %s ctlo=%2x,%s %s %s\n",
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/gpio/gpio-crystalcove.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
> index 5a98499..934462f 100644
> --- a/drivers/gpio/gpio-crystalcove.c
> +++ b/drivers/gpio/gpio-crystalcove.c
> @@ -18,6 +18,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
>  #include <linux/gpio.h>
> +#include <linux/seq_file.h>
>  #include <linux/bitops.h>
>  #include <linux/regmap.h>
>  #include <linux/mfd/intel_soc_pmic.h>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
