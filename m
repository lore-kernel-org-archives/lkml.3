Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3BVCXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:23:46 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34951 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab3BVCXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:23:44 -0500
MIME-Version: 1.0
In-Reply-To: <eada017a865d03fe67df39c4672f258fb2d71447.1360568193.git.viresh.kumar@linaro.org>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
	<eada017a865d03fe67df39c4672f258fb2d71447.1360568193.git.viresh.kumar@linaro.org>
Date: Fri, 22 Feb 2013 07:53:43 +0530
Message-ID: <CAKohpon5KSV4ZyijuG9hNqEXxwXzFev1AcygKWL9-scyWxhOyw@mail.gmail.com>
Subject: Re: [PATCH V2 2/4] cpufreq: governor: Implement per policy instances
 of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2013 13:20, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h

>  #define CPUFREQ_PRECHANGE      (0)
> @@ -183,11 +197,10 @@ static inline unsigned long cpufreq_scale(unsigned long old, u_int div, u_int mu
>  #define CPUFREQ_GOV_STOP       2
>  #define CPUFREQ_GOV_LIMITS     3
>  #define CPUFREQ_GOV_POLICY_INIT        4
> -#define CPUFREQ_GOV_POLICY_EXIT        4
> +#define CPUFREQ_GOV_POLICY_EXIT        5

See, i told you i had this change, but got merged to the wrong commit. :)
