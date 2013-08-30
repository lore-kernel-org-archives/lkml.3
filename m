Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3H3J7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:59:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60927 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3H3J7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:59:46 -0400
Message-ID: <52206D25.6080808@arm.com>
Date: Fri, 30 Aug 2013 11:00:05 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Kevin Hilman <kevin.hilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [GIT PULL] ARM/ARM64 architected timer updates for v3.12
References: <521F8157.20203@arm.com> <521FCC0A.80302@linaro.org>
In-Reply-To: <521FCC0A.80302@linaro.org>
X-OriginalArrivalTime: 30 Aug 2013 09:59:41.0822 (UTC) FILETIME=[A59011E0:01CEA567]
X-MC-Unique: 113083010594401901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Catalin,Russell

On 29/08/13 23:32, Daniel Lezcano wrote:
> On 08/29/2013 07:13 PM, Sudeep KarkadaNagesha wrote:
>> Hi Daniel,
>>
>> These are the ARM/ARM64 arch timer updates for v3.12.
>> I have re-based the changes on tip/timers/core as there are conflicts
>> with memory mapped arch_timers support queued recently.
>> Since this series adds CPU PM notifiers for arch_timers, it is required
>> to enable ARM bL cpuidle drivers(already queued for v3.12)
>>
>> Regards,
>> Sudeep
>>
>> The following changes since commit cfb6d656d569510ac9239583ce09e4c92ad54719:
>>
>>   Merge branch 'timers/clockevents-next' of
>> git://git.linaro.org/people/dlezcano/clockevents into timers/core
>> (2013-08-21 14:59:23 +0200)
>>
>> are available in the git repository at:
>>
>>
>>   git://linux-arm.org/linux-skn.git timer_evtstrm
>>
>> for you to fetch changes up to f74f198e540c160b1db9470b679dbeb72339829b:
>>
>>   drivers: clocksource: add CPU PM notifier for ARM architected timer
>> (2013-08-29 17:43:08 +0100)
> 
> 
> Hi Sudeep,
> 
> I need the acked-by from Olof or Kevin for the arch/arm[64] changes.
> 
Hi Daniel,

I think the changes are more generic to arm/arm64, rather not SoC
specific. Catalin has reviewed the series. I can check with Russell(for
arm) and Catalin(for arm64) for Acks.
I do understand that it may be late for v3.12

Regards,
Sudeep

> Thanks
>   -- Daniel
> 
>> ----------------------------------------------------------------
>> Sudeep KarkadaNagesha (4):
>>    ARM/ARM64: arch_timer: add macros for bits in control register
>>    ARM: arch_timer: add support to configure and enable event stream
>>    ARM64: arch_timer: add support to configure and enable event stream
>>    drivers: clocksource: add CPU PM notifier for ARM architected timer
>>
>> Will Deacon (1):
>>    drivers: clocksource: add support for ARM architected timer event stream
>> q
>>  arch/arm/include/asm/arch_timer.h    | 36 ++++++++++++++++---
>>  arch/arm/include/uapi/asm/hwcap.h    |  1 +
>>  arch/arm/kernel/setup.c              |  1 +
>>  arch/arm64/include/asm/arch_timer.h  | 42 ++++++++++++++++++---
>>  arch/arm64/include/asm/hwcap.h       | 11 +++---
>>  arch/arm64/include/uapi/asm/hwcap.h  |  1 +
>>  arch/arm64/kernel/setup.c            | 11 ++++++
>>  drivers/clocksource/Kconfig          | 15 ++++++++
>>  drivers/clocksource/arm_arch_timer.c | 49 +++++++++++++++++++++++++
>>  include/clocksource/arm_arch_timer.h | 10 +++++
>>  10 files changed, 161 insertions(+), 16 deletions(-)
>>
>>
>>
> 
> 


