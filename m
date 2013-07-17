Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3GQPaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:30:30 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:34553 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab3GQPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:30:29 -0400
Message-ID: <51E6B892.1090406@linaro.org>
Date: Wed, 17 Jul 2013 17:30:26 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        joe@perches.com
Subject: Re: [PATCH] MAINTAINERS: Add Daniel as maintainer for CLOCKSOURCE
 and CLOCKEVENT Drivers
References: <1373485914-16398-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1373485914-16398-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 09:51 PM, John Stultz wrote:
> I've been doing a bad job at managing the drivers/clocksource directory,
> so Daniel has been helping with review and patch queuing for the clocksource
> and clockevent drivers, so add him formally to the MAINTAINERS list.

Shall I add this patch in the next PR for clocksource I will send to
Thomas ?

Thanks
  -- Daniel

> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Joe Perches <joe@perches.com>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: Olof Johansson <olof@lixom.net>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  MAINTAINERS | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e626794..5964b68 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2090,6 +2090,13 @@ M:	Russell King <linux@arm.linux.org.uk>
>  S:	Maintained
>  F:	include/linux/clk.h
>  
> +CLOCKSOURCE, CLOCKEVENT DRIVERS
> +M:	Daniel Lezcano <daniel.lezcano@linaro.org>
> +M:	Thomas Gleixner <tglx@linutronix.de>
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> +S:	Supported
> +F:	drivers/clocksource
> +
>  CISCO FCOE HBA DRIVER
>  M:	Hiral Patel <hiralpat@cisco.com>
>  M:	Suma Ramars <sramars@cisco.com>
> @@ -7021,7 +7028,7 @@ S:	Maintained
>  F:	include/linux/mmc/dw_mmc.h
>  F:	drivers/mmc/host/dw_mmc*
>  
> -TIMEKEEPING, NTP
> +TIMEKEEPING, CLOCKSOURCE CORE, NTP
>  M:	John Stultz <john.stultz@linaro.org>
>  M:	Thomas Gleixner <tglx@linutronix.de>
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> @@ -7034,7 +7041,6 @@ F:	include/uapi/linux/timex.h
>  F:	kernel/time/clocksource.c
>  F:	kernel/time/time*.c
>  F:	kernel/time/ntp.c
> -F:	drivers/clocksource
>  
>  TLG2300 VIDEO4LINUX-2 DRIVER
>  M:	Huang Shijie <shijie8@gmail.com>
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

