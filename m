Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3JaSjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:39:21 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63791 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3JaSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:39:19 -0400
MIME-Version: 1.0
In-Reply-To: <5272A118.1090908@semaphore.gr>
References: <5272A118.1090908@semaphore.gr>
Date: Fri, 1 Nov 2013 00:09:16 +0530
Message-ID: <CAKohponQ+oRYpdYrpKV3=GMh6ACQr+E+WygLHk0mdC+ivjeP_Q@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Remove redundant return statement
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Henrik Nilsson <Karl.Henrik.Nilsson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 October 2013 23:57, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> After commit dfa5bb622555d9da0df21b50f46ebdeef390041b
> "cpufreq: ondemand: Change the calculation of target frequency",
> this return statement is no longer needed.
>
> Reported-by: Henrik Nilsson <Karl.Henrik.Nilsson@gmail.com>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 32f26f6..18d4091 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -168,7 +168,6 @@ static void od_check_cpu(int cpu, unsigned int load)
>                         dbs_info->rate_mult =
>                                 od_tuners->sampling_down_factor;
>                 dbs_freq_increase(policy, policy->max);
> -               return;
>         } else {
>                 /* Calculate the next frequency proportional to load */
>                 unsigned int freq_next;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
