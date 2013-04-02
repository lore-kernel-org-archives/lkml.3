Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3DBNLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:11:23 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:55457 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760526Ab3DBNLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <1364905575-10234-1-git-send-email-bp@alien8.de>
References: <1364905575-10234-1-git-send-email-bp@alien8.de>
Date: Tue, 2 Apr 2013 18:41:20 +0530
X-Google-Sender-Auth: -Qk0ZLNKPxklefTerzk7Q-cx2KI
Message-ID: <CAOh2x=nJTcaEAe5eS4JzHLY_vUx0HJo9pDD7exoq0OffMqzJDQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Correct header guards typo
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 5:56 PM, Borislav Petkov <bp@alien8.de> wrote:
> From: Borislav Petkov <bp@suse.de>
>
> It should be "governor".
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/cpufreq/cpufreq_governor.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index 513cc8234e5e..65937697cab3 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -14,8 +14,8 @@
>   * published by the Free Software Foundation.
>   */
>
> -#ifndef _CPUFREQ_GOVERNER_H
> -#define _CPUFREQ_GOVERNER_H
> +#ifndef _CPUFREQ_GOVERNOR_H
> +#define _CPUFREQ_GOVERNOR_H
>
>  #include <linux/cpufreq.h>
>  #include <linux/kobject.h>
> @@ -263,4 +263,4 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>                 struct common_dbs_data *cdata, unsigned int event);
>  void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>                 unsigned int delay, bool all_cpus);
> -#endif /* _CPUFREQ_GOVERNER_H */
> +#endif /* _CPUFREQ_GOVERNOR_H */

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
