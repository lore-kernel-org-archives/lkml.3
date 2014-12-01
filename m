Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaLALek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:34:40 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:51061 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaLALeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:34:37 -0500
Date: Mon, 1 Dec 2014 11:34:30 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v8 09/14] mfd: max77693: adjust
 max77693_led_platform_data
Message-ID: <20141201113430.GC15845@x1>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-10-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417166286-27685-10-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014, Jacek Anaszewski wrote:

> Add "label" array for Device Tree strings with
> the name of a LED device and make flash_timeout
> a two element array, for caching the sub-led
> related flash timeout.

<------------------------------------------------------------------------->

Please use all of the 75 char buffer.

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: SangYoung Son <hello.son@smasung.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  include/linux/mfd/max77693.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
> index f0b6585..30fa19ea 100644
> --- a/include/linux/mfd/max77693.h
> +++ b/include/linux/mfd/max77693.h
> @@ -88,14 +88,15 @@ enum max77693_led_boost_mode {
>  };
>  
>  struct max77693_led_platform_data {
> +	const char *label[2];
>  	u32 fleds[2];
>  	u32 iout_torch[2];
>  	u32 iout_flash[2];
>  	u32 trigger[2];
>  	u32 trigger_type[2];
> +	u32 flash_timeout[2];
>  	u32 num_leds;
>  	u32 boost_mode;
> -	u32 flash_timeout;
>  	u32 boost_vout;
>  	u32 low_vsys;
>  };

I'm guessing this will effect the other patches in the set?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
