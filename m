Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3K1IY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:24:27 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54485 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3K1IYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:24:11 -0500
Message-ID: <5296FDB1.70501@linaro.org>
Date: Thu, 28 Nov 2013 09:24:17 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Christian Daudt <bcm@fixthebug.org>, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: bcm_kona_timer: Remove unused bcm_timer_ids
References: <1385344485.2241.2.camel@phoenix>
In-Reply-To: <1385344485.2241.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 02:54 AM, Axel Lin wrote:
> bcm_timer_ids is no longer used after converting to CLOCKSOURCE_OF_DECLARE.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/clocksource/bcm_kona_timer.c | 6 ------
>   1 file changed, 6 deletions(-)
>
> diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
> index 0d7d8c3..5176e76 100644
> --- a/drivers/clocksource/bcm_kona_timer.c
> +++ b/drivers/clocksource/bcm_kona_timer.c
> @@ -98,12 +98,6 @@ kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
>   	return;
>   }
>
> -static const struct of_device_id bcm_timer_ids[] __initconst = {
> -	{.compatible = "brcm,kona-timer"},
> -	{.compatible = "bcm,kona-timer"}, /* deprecated name */
> -	{},
> -};
> -
>   static void __init kona_timers_init(struct device_node *node)
>   {
>   	u32 freq;
>

Applied to my tree for 3.13 fixes.

Thanks !
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

