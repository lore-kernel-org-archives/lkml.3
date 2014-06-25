Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaFYAwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:52:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46496 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaFYAwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:52:37 -0400
Message-ID: <53AA1D53.3050207@codeaurora.org>
Date: Tue, 24 Jun 2014 17:52:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-arm-msm@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [RFC/PATCH 10/12] cpufreq: Add a cpufreq-krait based on cpufreq-cpu0
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org> <1403654783-7176-11-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1403654783-7176-11-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/14 17:06, Stephen Boyd wrote:
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 738c8b7b17dc..f5c9f68dcc0f 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
>  obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
>  
>  obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
> +obj-$(CONFIG_CPUFREQ_KRAIT)		+= cpufreq-krait.o
>

Hmph, last minute name changes are bad. This should be
CONFIG_GENERIC_CPUFREQ_KRAIT.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

