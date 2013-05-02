Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab3EBVbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:31:14 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:34824 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857Ab3EBVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:31:11 -0400
Message-ID: <5182DB15.2060006@linaro.org>
Date: Thu, 02 May 2013 23:31:01 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org
Subject: Re: [PATCH, RFC 03/22] cpuidle: calxeda: select ARM_CPU_SUSPEND
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1367507786-505303-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 05:16 PM, Arnd Bergmann wrote:
> Like other ARM specific drivers, this one requires ARM_CPU_SUSPEND,
> as shown by this linker error:
> 
> drivers/built-in.o: In function `calxeda_pwrdown_idle':
> drivers/cpuidle/cpuidle-calxeda.c:84: undefined reference to `cpu_suspend'
> drivers/cpuidle/cpuidle-calxeda.c:86: undefined reference to `cpu_resume'
> 
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  drivers/cpuidle/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
> index c4cc27e..e21cdfa 100644
> --- a/drivers/cpuidle/Kconfig
> +++ b/drivers/cpuidle/Kconfig
> @@ -36,6 +36,7 @@ if CPU_IDLE
>  config CPU_IDLE_CALXEDA
>  	bool "CPU Idle Driver for Calxeda processors"
>  	depends on ARCH_HIGHBANK
> +	select ARM_CPU_SUSPEND
>  	help
>  	  Select this to enable cpuidle on Calxeda processors.
>  
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

