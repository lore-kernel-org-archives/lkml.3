Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3DZMns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:43:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45019 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656Ab3DZMnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:43:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] cpufreq: MAINTAINERS: Add co-maintainer
Date: Fri, 26 Apr 2013 14:51:25 +0200
Message-ID: <2436012.5TjnMtdzaD@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <19a42d164b0e68a3ac16cd8865f0587ce383f5bf.1366979508.git.viresh.kumar@linaro.org>
References: <19a42d164b0e68a3ac16cd8865f0587ce383f5bf.1366979508.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 26, 2013 06:06:00 PM Viresh Kumar wrote:
> With prior discussions (Over private emails) with current Maintainer of cpufreq
> framework (Rafael), I am adding myself as a co-maintainer of cpufreq framework.
> 
> This would mostly be for cpufreq core and ARM drivers but not restricted to
> them.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

OK, but can you please add the git tree information in analogy with the recent
cpuidle patch while you're at it?

Also it would be good to send CCs of that to the ARM-SoC maintainers I suppose.

Thanks,
Rafael


> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 68d376e..bcef513 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2211,6 +2211,7 @@ F:	drivers/net/ethernet/ti/cpmac.c
>  
>  CPU FREQUENCY DRIVERS
>  M:	Rafael J. Wysocki <rjw@sisk.pl>
> +M:	Viresh Kumar <viresh.kumar@linaro.org>
>  L:	cpufreq@vger.kernel.org
>  L:	linux-pm@vger.kernel.org
>  S:	Maintained
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
