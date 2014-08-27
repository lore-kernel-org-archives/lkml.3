Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935537AbaH0R2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:28:07 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57425 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935028AbaH0R2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:28:05 -0400
From: Dirk Brandewie <dirk.brandewie@gmail.com>
X-Google-Original-From: Dirk Brandewie <dirk.j.brandewie@intel.com>
Message-ID: <53FE151E.6010708@intel.com>
Date: Wed, 27 Aug 2014 10:27:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, rafael.j.wysocki@intel.com
CC: dirk.j.brandewie@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] intel_pstate: Turn per cpu printk into pr_debug
References: <1409159828-16168-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1409159828-16168-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 10:17 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> On larger systems intel_pstate currently spams the boot up
> log with its "Intel pstate controlling ..." message for each CPU.
> It's the only subsystem that prints a message for each
> CPU.
>
> Turn the message into a pr_debug.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

> ---
>   drivers/cpufreq/intel_pstate.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index c5eac94..17be734 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -688,7 +688,7 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
>
>   	add_timer_on(&cpu->timer, cpunum);
>
> -	pr_info("Intel pstate controlling: cpu %d\n", cpunum);
> +	pr_debug("Intel pstate controlling: cpu %d\n", cpunum);
>
>   	return 0;
>   }
>

