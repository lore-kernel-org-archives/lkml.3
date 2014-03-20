Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaCTAGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 20:06:38 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:39024 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133AbaCTAGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 20:06:36 -0400
MIME-Version: 1.0
In-Reply-To: <532A2759.1000708@semaphore.gr>
References: <532A0D0C.50507@semaphore.gr>
	<93042283.W9rbzHbJB2@vostro.rjw.lan>
	<532A2759.1000708@semaphore.gr>
Date: Thu, 20 Mar 2014 05:36:36 +0530
Message-ID: <CAKohpomLRH7QT71+N7_7AveKPU3rgQv37Ye6d=pUcKjC6shtEg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Remove unnecessary braces
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2014 04:55, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> I'm sorry for the inconvenience. I read again the CodingStyle (more carefully :) ).
> I'm sending the corrected patch with the single case of unnecessary braces.
>
> Thanks,
> Stratos
>
> ------------------------8<-----------------------
> Remove unnecessary braces from a single statement.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index e3aa9de..220c4a9 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1330,10 +1330,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>                 if (new_cpu >= 0) {
>                         update_policy_cpu(policy, new_cpu);
>
> -                       if (!cpufreq_suspended) {
> +                       if (!cpufreq_suspended)
>                                 pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
>                                          __func__, new_cpu, cpu);
> -                       }
>                 }
>         }

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
