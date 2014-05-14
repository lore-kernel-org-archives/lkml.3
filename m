Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaENKnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:43:23 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:58293 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaENKnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:43:21 -0400
MIME-Version: 1.0
In-Reply-To: <53733DC8.1020608@linaro.org>
References: <ANuQgHGSPJ45tbrVppAVpOqF0OfHacPWfX=S5mOVxTPr66f7vg@mail.gmail.com>
	<1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
	<53733DC8.1020608@linaro.org>
Date: Wed, 14 May 2014 16:13:21 +0530
Message-ID: <CANuQgHErThcauKun624kibia70wDa2Tyhj0kDwpWV92zpUrJ0w@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] add cpuidle support for Exynos5420
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 14 May 2014 15:26, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> On 05/14/2014 10:03 AM, Chander Kashyap wrote:
>>
>> Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7 cores.
>>
>> This patchset adds cpuidle support for Exynos5420 SoC based on
>> generic big.little cpuidle driver.
>
>
> Hi Chander,
>
> just a side question. I am not succeeding to have both cluster A7/A15 with
> the upstream kernel.
>
> How can I test your driver ?

Hmm on octa can be tested only for 4 cores. as cci is disabled.

>
> Did I miss something ?
>
> Thanks
>   -- Daniel
>
>
>> Tested on SMDK5420.
>>
>> This patch set depends on:
>>         1. [PATCH 0/5] MCPM backend for Exynos5420
>>            http://www.spinics.net/lists/arm-kernel/msg331100.html
>> Changelog is in respective patches.
>> Chander Kashyap (5):
>>    driver: cpuidle-big-little: add of_device_id structure
>>    arm: exynos: add generic function to calculate cpu number
>>    cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little
>>      driver
>>    driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
>>    exynos: cpuidle: do not allow cpuidle registration for Exynos5420
>>    mcpm: exynos: populate suspend and powered_up callbacks
>>
>>   arch/arm/mach-exynos/cpuidle.c       |    3 +++
>>   arch/arm/mach-exynos/mcpm-exynos.c   |   36
>> ++++++++++++++++++++++++++++++++++
>>   arch/arm/mach-exynos/regs-pmu.h      |    9 +++++++++
>>   drivers/cpuidle/Kconfig.arm          |    2 +-
>>   drivers/cpuidle/cpuidle-big_little.c |   12 +++++++++++-
>>   5 files changed, 60 insertions(+), 2 deletions(-)
>>
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>



-- 
with warm regards,
Chander Kashyap
