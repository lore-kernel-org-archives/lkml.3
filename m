Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3GYDmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:42:06 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49651 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3GYDmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:42:04 -0400
Message-ID: <51F09E86.1010401@linaro.org>
Date: Thu, 25 Jul 2013 09:11:58 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] gpio_msm: Fix build error due to missing err.h
References: <1374697248-23401-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1374697248-23401-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 01:50 AM, Stephen Boyd wrote:
> drivers/gpio/gpio-msm-v1.c: In function 'gpio_msm_v1_probe':
> drivers/gpio/gpio-msm-v1.c:656:2:
> error: implicit declaration of function 'IS_ERR'
> [-Werror=implicit-function-declaration]
> drivers/gpio/gpio-msm-v1.c:657:3:
> error: implicit declaration of function 'PTR_ERR'
> [-Werror=implicit-function-declaration]
> 
> This driver failed to compile after commit 68515bb
> (gpio_msm: Convert to use devm_ioremap_resource,
> 2013-06-10).
> 
> Cc: Tushar Behera <tushar.behera@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Sorry for this. I must have messed up while testing this patchset.

Acked-by: Tushar Behera <tushar.behera@linaro.org>


> ---
>  drivers/gpio/gpio-msm-v1.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
> index e3ceaac..73b7396 100644
> --- a/drivers/gpio/gpio-msm-v1.c
> +++ b/drivers/gpio/gpio-msm-v1.c
> @@ -21,6 +21,7 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/platform_device.h>
> +#include <linux/err.h>
>  
>  #include <mach/msm_gpiomux.h>
>  
> 


-- 
Tushar Behera
