Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaE1E2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:28:18 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57880 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaE1E2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <53831795.9070006@gmail.com>
References: <CANuQgHGSA+R__raSa_tzrgpceqLD2SZw+s0XQUHGF4wscgh6Kg@mail.gmail.com>
	<1400227438-27155-1-git-send-email-chander.kashyap@linaro.org>
	<53831795.9070006@gmail.com>
Date: Wed, 28 May 2014 09:58:15 +0530
Message-ID: <CANuQgHH284A9QY7M5zGbSE-mXjm2KDqr54VWmtKVkbma3zZvvw@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] add cpuidle support for Exynos5420
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 May 2014 15:59, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Chander,
>
> On 16.05.2014 10:03, Chander Kashyap wrote:
>> Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7 cores.
>>
>> This patchset adds cpuidle support for Exynos5420 SoC based on
>> generic big.little cpuidle driver.
>>
>> Tested on SMDK5420.
>>
>> This patch set depends on:
>>       1. [PATCH 0/5] MCPM backend for Exynos5420
>>          http://www.spinics.net/lists/arm-kernel/msg331100.html
>> Changelog is in respective patches.
>> Chander Kashyap (5):
>>   driver: cpuidle-big-little: add of_device_id structure
>>   arm: exynos: add generic function to calculate cpu number
>>   cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little
>>     driver
>>   driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
>>   exynos: cpuidle: do not allow cpuidle registration for Exynos5420
>>   mcpm: exynos: populate suspend and powered_up callbacks
>>
>>  arch/arm/mach-exynos/exynos.c        |    4 +++-
>>  arch/arm/mach-exynos/mcpm-exynos.c   |   36 ++++++++++++++++++++++++++++++++++
>>  arch/arm/mach-exynos/regs-pmu.h      |    9 +++++++++
>>  drivers/cpuidle/Kconfig.arm          |    2 +-
>>  drivers/cpuidle/cpuidle-big_little.c |   12 +++++++++++-
>>  5 files changed, 60 insertions(+), 3 deletions(-)
>>
>
> For the whole series,
>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Thanks Tomasz.

Dear Kukjin,
Can you take these patches.
>
> Best regards,
> Tomasz



-- 
with warm regards,
Chander Kashyap
