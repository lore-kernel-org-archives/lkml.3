Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaIBEo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 00:44:59 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37249 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaIBEo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 00:44:58 -0400
MIME-Version: 1.0
In-Reply-To: <1409574225-5618-1-git-send-email-gabriele.mzt@gmail.com>
References: <1409574225-5618-1-git-send-email-gabriele.mzt@gmail.com>
Date: Tue, 2 Sep 2014 10:14:57 +0530
Message-ID: <CAKohpomMPiMALaamoio_+aBRaJfiONXanFMzFx+iuOKYjDfwFg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: intel_pstate: Remove unneeded variable
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 September 2014 17:53, Gabriele Mazzotta <gabriele.mzt@gmail.com> wrote:
> It should have been removed with commit d1b6848590af
> ("cpufreq / intel_pstate: Optimize intel_pstate_set_policy")
>
> Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> ---
>  drivers/cpufreq/intel_pstate.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index e396ad3..0668b38 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -708,10 +708,6 @@ static unsigned int intel_pstate_get(unsigned int cpu_num)
>
>  static int intel_pstate_set_policy(struct cpufreq_policy *policy)
>  {
> -       struct cpudata *cpu;
> -
> -       cpu = all_cpu_data[policy->cpu];
> -
>         if (!policy->cpuinfo.max_freq)
>                 return -ENODEV;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
