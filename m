Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaHZQ36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:29:58 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36751 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaHZQ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:29:57 -0400
Date: Tue, 26 Aug 2014 17:29:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 16/18] backlight: jornada720: remove 'else' after a return
Message-ID: <20140826162951.GF26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00ba01cfc12d$f0202000$d0606000$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00ba01cfc12d$f0202000$d0606000$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Jingoo Han wrote:

> Fixed the following checkpatch warning.
> 
>   WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/jornada720_bl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
> index 6ce96b4a8796..7e6ff5346892 100644
> --- a/drivers/video/backlight/jornada720_bl.c
> +++ b/drivers/video/backlight/jornada720_bl.c
> @@ -41,11 +41,11 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
>  		dev_err(&bd->dev, "get brightness timeout\n");
>  		jornada_ssp_end();
>  		return -ETIMEDOUT;
> -	} else {
> -		/* exchange txdummy for value */
> -		ret = jornada_ssp_byte(TXDUMMY);
>  	}
>  
> +	/* exchange txdummy for value */
> +	ret = jornada_ssp_byte(TXDUMMY);
> +
>  	jornada_ssp_end();
>  
>  	return BL_MAX_BRIGHT - ret;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
