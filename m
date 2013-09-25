Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3IYWDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:03:21 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47791 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3IYWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:03:19 -0400
Message-ID: <52435DA4.3080204@linaro.org>
Date: Thu, 26 Sep 2013 00:03:16 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/21] cpuidle: replace multiline statements with single
 line in cpuidle_idle_call()
References: <cover.1379779777.git.viresh.kumar@linaro.org> <c79ae2ab0a5a3946fcd0e68c855742f06f695f0f.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <c79ae2ab0a5a3946fcd0e68c855742f06f695f0f.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> Few statements in cpuidle_idle_call() are broken into multiple lines, whereas
> they can actually come in a single line. Convert those to single line.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

I splitted these lines because they have 81 cols.

> ---
>  drivers/cpuidle/cpuidle.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index ed67e3c..43d5836 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -145,8 +145,7 @@ int cpuidle_idle_call(void)
>  	broadcast = drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP;
>  
>  	if (broadcast)
> -		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
> -				   &dev->cpu);
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
>  
>  	if (cpuidle_state_is_coupled(dev, drv, next_state))
>  		entered_state = cpuidle_enter_state_coupled(dev, drv,
> @@ -155,8 +154,7 @@ int cpuidle_idle_call(void)
>  		entered_state = cpuidle_enter_state(dev, drv, next_state);
>  
>  	if (broadcast)
> -		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
> -				   &dev->cpu);
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
>  
>  	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
>  
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

