Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3ALNWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 08:22:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38761 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab3ALNWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 08:22:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: SPEAr: Fix sparse warning for cpufreq driver
Date: Sat, 12 Jan 2013 14:27:54 +0100
Message-ID: <2860847.JDCmaU39LZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <6d76f8457b4eb42bcbab8e0221f90168a8fbc328.1357967480.git.viresh.kumar@linaro.org>
References: <6d76f8457b4eb42bcbab8e0221f90168a8fbc328.1357967480.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 12, 2013 10:42:09 AM Viresh Kumar wrote:
> This patch fixes following sparse warning:
> 
> drivers/cpufreq/spear-cpufreq.c:33:5: warning: symbol 'spear_cpufreq_verify' was
> not declared. Should it be static?

Applied to the linux-next branch of the linux-pm.git tree as v3.9 material.

Thanks,
Rafael


> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/spear-cpufreq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
> index 4575cfe..8ff26af 100644
> --- a/drivers/cpufreq/spear-cpufreq.c
> +++ b/drivers/cpufreq/spear-cpufreq.c
> @@ -30,7 +30,7 @@ static struct {
>  	u32 cnt;
>  } spear_cpufreq;
>  
> -int spear_cpufreq_verify(struct cpufreq_policy *policy)
> +static int spear_cpufreq_verify(struct cpufreq_policy *policy)
>  {
>  	return cpufreq_frequency_table_verify(policy, spear_cpufreq.freq_tbl);
>  }
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
