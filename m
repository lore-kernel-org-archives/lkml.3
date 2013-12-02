Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3LBS0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:26:10 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:36903 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3LBS0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:26:06 -0500
Message-ID: <529CD0B5.600@atmel.com>
Date: Mon, 2 Dec 2013 19:25:57 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>, <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] atmel_lcdfb: fix module autoload
References: <1382459817-26990-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1382459817-26990-1-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/2013 18:36, Johan Hovold :
> Add missing module device table which is needed for module autoloading.
>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Jean-Christophe, Tomi,

Can you please take this patch?

Best regards,


> ---
>   drivers/video/atmel_lcdfb.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> index 088511a..67b339c 100644
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -94,6 +94,7 @@ static const struct platform_device_id atmel_lcdfb_devtypes[] = {
>   		/* terminator */
>   	}
>   };
> +MODULE_DEVICE_TABLE(platform, atmel_lcdfb_devtypes);
>
>   static struct atmel_lcdfb_config *
>   atmel_lcdfb_get_config(struct platform_device *pdev)
>


-- 
Nicolas Ferre
