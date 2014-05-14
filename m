Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaENJ4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:56:19 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:40093 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbaENJ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:56:16 -0400
Message-ID: <53733DC8.1020608@linaro.org>
Date: Wed, 14 May 2014 11:56:24 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: lorenzo.pieralisi@arm.com, rjw@rjwysocki.net, kgene.kim@samsung.com,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH v5 0/6] add cpuidle support for Exynos5420
References: <ANuQgHGSPJ45tbrVppAVpOqF0OfHacPWfX=S5mOVxTPr66f7vg@mail.gmail.com> <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 10:03 AM, Chander Kashyap wrote:
> Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7 cores.
>
> This patchset adds cpuidle support for Exynos5420 SoC based on
> generic big.little cpuidle driver.

Hi Chander,

just a side question. I am not succeeding to have both cluster A7/A15 
with the upstream kernel.

How can I test your driver ?

Did I miss something ?

Thanks
   -- Daniel

> Tested on SMDK5420.
>
> This patch set depends on:
> 	1. [PATCH 0/5] MCPM backend for Exynos5420
> 	   http://www.spinics.net/lists/arm-kernel/msg331100.html
> Changelog is in respective patches.
> Chander Kashyap (5):
>    driver: cpuidle-big-little: add of_device_id structure
>    arm: exynos: add generic function to calculate cpu number
>    cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little
>      driver
>    driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
>    exynos: cpuidle: do not allow cpuidle registration for Exynos5420
>    mcpm: exynos: populate suspend and powered_up callbacks
>
>   arch/arm/mach-exynos/cpuidle.c       |    3 +++
>   arch/arm/mach-exynos/mcpm-exynos.c   |   36 ++++++++++++++++++++++++++++++++++
>   arch/arm/mach-exynos/regs-pmu.h      |    9 +++++++++
>   drivers/cpuidle/Kconfig.arm          |    2 +-
>   drivers/cpuidle/cpuidle-big_little.c |   12 +++++++++++-
>   5 files changed, 60 insertions(+), 2 deletions(-)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

