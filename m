Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaHZQgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:36:40 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:38565 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaHZQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:36:39 -0400
Date: Tue, 26 Aug 2014 17:36:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 04/18] backlight: ams369fg06: remove 'else' after a return
Message-ID: <20140826163633.GT26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00ae01cfc12d$66967820$33c36860$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00ae01cfc12d$66967820$33c36860$%han@samsung.com>
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
>  drivers/video/backlight/ams369fg06.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
> index 4726c8be626f..5f897f99cc9b 100644
> --- a/drivers/video/backlight/ams369fg06.c
> +++ b/drivers/video/backlight/ams369fg06.c
> @@ -325,11 +325,11 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
>  	if (!pd->reset) {
>  		dev_err(lcd->dev, "reset is NULL.\n");
>  		return -EINVAL;
> -	} else {
> -		pd->reset(lcd->ld);
> -		msleep(pd->reset_delay);
>  	}
>  
> +	pd->reset(lcd->ld);
> +	msleep(pd->reset_delay);
> +
>  	ret = ams369fg06_ldi_init(lcd);
>  	if (ret) {
>  		dev_err(lcd->dev, "failed to initialize ldi.\n");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
