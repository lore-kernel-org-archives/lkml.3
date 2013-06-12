Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3FLREx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:04:53 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:56804 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab3FLREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:04:52 -0400
Message-ID: <51B8AA31.30501@calxeda.com>
Date: Wed, 12 Jun 2013 12:04:49 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robin.randhawa@arm.com" <robin.randhawa@arm.com>,
        "Steve.Bannister@arm.com" <Steve.Bannister@arm.com>,
        "Liviu.Dudau@arm.com" <Liviu.Dudau@arm.com>,
        "charles.garcia-tobin@arm.com" <charles.garcia-tobin@arm.com>,
        "arvind.chauhan@arm.com" <arvind.chauhan@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 05/11] cpufreq: highbank: remove select CPU_FREQ_TABLE
References: <cover.1371022830.git.viresh.kumar@linaro.org> <7e4ee3926630a243a8e69835011cf9c6c4673eb9.1371022830.git.viresh.kumar@linaro.org>
In-Reply-To: <7e4ee3926630a243a8e69835011cf9c6c4673eb9.1371022830.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 03:15 AM, Viresh Kumar wrote:
> Highbank cpufreq driver doesn't use any APIs from freq_table.c and so must not
> select CPU_FREQ_TABLE.
> 
> Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks for catching this.

Acked-by: Mark Langsdorf <mark.langsdorf@calxeda.com>

> ---
>  drivers/cpufreq/Kconfig.arm | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 9d7e209..891dd1c 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -57,7 +57,6 @@ config ARM_EXYNOS5440_CPUFREQ
>  config ARM_HIGHBANK_CPUFREQ
>  	tristate "Calxeda Highbank-based"
>  	depends on ARCH_HIGHBANK
> -	select CPU_FREQ_TABLE
>  	select GENERIC_CPUFREQ_CPU0
>  	select PM_OPP
>  	select REGULATOR
> 

