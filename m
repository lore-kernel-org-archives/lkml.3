Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3H2Wcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:32:47 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57701 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab3H2Wcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:32:46 -0400
Message-ID: <521FCC0A.80302@linaro.org>
Date: Fri, 30 Aug 2013 00:32:42 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Kevin Hilman <kevin.hilman@linaro.org>
Subject: Re: [GIT PULL] ARM/ARM64 architected timer updates for v3.12
References: <521F8157.20203@arm.com>
In-Reply-To: <521F8157.20203@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 07:13 PM, Sudeep KarkadaNagesha wrote:
> Hi Daniel,
> 
> These are the ARM/ARM64 arch timer updates for v3.12.
> I have re-based the changes on tip/timers/core as there are conflicts
> with memory mapped arch_timers support queued recently.
> Since this series adds CPU PM notifiers for arch_timers, it is required
> to enable ARM bL cpuidle drivers(already queued for v3.12)
> 
> Regards,
> Sudeep
> 
> The following changes since commit cfb6d656d569510ac9239583ce09e4c92ad54719:
> 
>   Merge branch 'timers/clockevents-next' of
> git://git.linaro.org/people/dlezcano/clockevents into timers/core
> (2013-08-21 14:59:23 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://linux-arm.org/linux-skn.git timer_evtstrm
> 
> for you to fetch changes up to f74f198e540c160b1db9470b679dbeb72339829b:
> 
>   drivers: clocksource: add CPU PM notifier for ARM architected timer
> (2013-08-29 17:43:08 +0100)


Hi Sudeep,

I need the acked-by from Olof or Kevin for the arch/arm[64] changes.

Thanks
  -- Daniel

> ----------------------------------------------------------------
> Sudeep KarkadaNagesha (4):
>    ARM/ARM64: arch_timer: add macros for bits in control register
>    ARM: arch_timer: add support to configure and enable event stream
>    ARM64: arch_timer: add support to configure and enable event stream
>    drivers: clocksource: add CPU PM notifier for ARM architected timer
> 
> Will Deacon (1):
>    drivers: clocksource: add support for ARM architected timer event stream
> q
>  arch/arm/include/asm/arch_timer.h    | 36 ++++++++++++++++---
>  arch/arm/include/uapi/asm/hwcap.h    |  1 +
>  arch/arm/kernel/setup.c              |  1 +
>  arch/arm64/include/asm/arch_timer.h  | 42 ++++++++++++++++++---
>  arch/arm64/include/asm/hwcap.h       | 11 +++---
>  arch/arm64/include/uapi/asm/hwcap.h  |  1 +
>  arch/arm64/kernel/setup.c            | 11 ++++++
>  drivers/clocksource/Kconfig          | 15 ++++++++
>  drivers/clocksource/arm_arch_timer.c | 49 +++++++++++++++++++++++++
>  include/clocksource/arm_arch_timer.h | 10 +++++
>  10 files changed, 161 insertions(+), 16 deletions(-)
> 
> 
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

