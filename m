Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaHZQcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:32:16 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:56472 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaHZQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:32:15 -0400
Date: Tue, 26 Aug 2014 17:32:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 12/18] backlight: pcf50633: add blank line after
 declarations
Message-ID: <20140826163208.GK26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00b601cfc12d$c5e51ed0$51af5c70$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b601cfc12d$c5e51ed0$51af5c70$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Jingoo Han wrote:

> Fixed the following checkpatch warning.
> 
>   WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/pcf50633-backlight.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
> index b95d3b0aaffe..85bd573b6d15 100644
> --- a/drivers/video/backlight/pcf50633-backlight.c
> +++ b/drivers/video/backlight/pcf50633-backlight.c
> @@ -90,6 +90,7 @@ static int pcf50633_bl_update_status(struct backlight_device *bl)
>  static int pcf50633_bl_get_brightness(struct backlight_device *bl)
>  {
>  	struct pcf50633_bl *pcf_bl = bl_get_data(bl);
> +
>  	return pcf_bl->brightness;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
