Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaFJMib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:38:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52444 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFJMi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <CANuQgHGM_PsDO0RmEKDVXSs1u50VMuLrx-=0sYhDut1gSjspcg@mail.gmail.com>
References: <CANuQgHGSA+R__raSa_tzrgpceqLD2SZw+s0XQUHGF4wscgh6Kg@mail.gmail.com>
	<1400227438-27155-1-git-send-email-chander.kashyap@linaro.org>
	<53831795.9070006@gmail.com>
	<CANuQgHH284A9QY7M5zGbSE-mXjm2KDqr54VWmtKVkbma3zZvvw@mail.gmail.com>
	<015f01cf7a2e$3b141590$b13c40b0$@samsung.com>
	<5385A638.2000001@linaro.org>
	<CANuQgHGM_PsDO0RmEKDVXSs1u50VMuLrx-=0sYhDut1gSjspcg@mail.gmail.com>
Date: Tue, 10 Jun 2014 18:08:28 +0530
Message-ID: <CADWw7OiQs7H_EeRBVTNEWP-5fRjCgEWQmy=MAmePBday9PQ5Dw@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] add cpuidle support for Exynos5420
From: "Chander M. Kashyap" <chander.kashyap@gmail.com>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:07 AM, Chander Kashyap
<chander.kashyap@linaro.org> wrote:
> On 28 May 2014 14:32, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> On 05/28/2014 06:35 AM, Kukjin Kim wrote:
>>>
>>> Chander Kashyap wrote:
>>>>
>>>>
>>>> On 26 May 2014 15:59, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>>>>
>>>>> Hi Chander,
>>>>>
>>>>> On 16.05.2014 10:03, Chander Kashyap wrote:
>>>>>>
>>>>>> Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7
>>>>
>>>> cores.
>>>>>>
>>>>>>
>>>>>> This patchset adds cpuidle support for Exynos5420 SoC based on
>>>>>> generic big.little cpuidle driver.
>>>>>>
>>>>>> Tested on SMDK5420.
>>>>>>
>>>>>> This patch set depends on:
>>>>>>        1. [PATCH 0/5] MCPM backend for Exynos5420
>>>>>>           http://www.spinics.net/lists/arm-kernel/msg331100.html
>>>>>> Changelog is in respective patches.
>>>>>> Chander Kashyap (5):
>>>>>>    driver: cpuidle-big-little: add of_device_id structure
>>>>>>    arm: exynos: add generic function to calculate cpu number
>>>>>>    cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little
>>>>>>      driver
>>>>>>    driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
>>>>>>    exynos: cpuidle: do not allow cpuidle registration for Exynos5420
>>>>>>    mcpm: exynos: populate suspend and powered_up callbacks
>>>>>>
>>>>>>   arch/arm/mach-exynos/exynos.c        |    4 +++-
>>>>>>   arch/arm/mach-exynos/mcpm-exynos.c   |   36
>>>>
>>>> ++++++++++++++++++++++++++++++++++
>>>>>>
>>>>>>   arch/arm/mach-exynos/regs-pmu.h      |    9 +++++++++
>>>>>>   drivers/cpuidle/Kconfig.arm          |    2 +-
>>>>>>   drivers/cpuidle/cpuidle-big_little.c |   12 +++++++++++-
>>>>>>   5 files changed, 60 insertions(+), 3 deletions(-)
>>>>>>
>>>>>
>>>>> For the whole series,
>>>>>
>>>>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>>>>
>>>>
>>>> Thanks Tomasz.
>>>>
>>>> Dear Kukjin,
>>>> Can you take these patches.
>>>>>
>>>>>
>>> When I looked at this series quickly, looks good to me but I need to get
>>> ack from cpuidle maintainer Rafael or Daniel.
>>
>>
>> Acked the different cpuidle bits.
>
> Hi Kukjin,
> Can you take it now?

ping
Sorry for previous html messages.

>
>
>>
>> Thanks
>>   -- Daniel
>>
>>
>> --
>>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog
>>
>
>
>
> --
> with warm regards,
> Chander Kashyap



-- 
thanks and regards,
Chander M. Kashyap
Contact Number: +918123738320
------- TENSION LENE KA NAHI, DENE KE-----
