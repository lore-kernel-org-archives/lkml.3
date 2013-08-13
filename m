Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab3HMMaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:30:23 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33618 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3HMMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:30:22 -0400
Message-ID: <520A26DC.9020005@linaro.org>
Date: Tue, 13 Aug 2013 14:30:20 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jonas Jensen <jonas.jensen@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clocksource/clockevents : arch_timer memory mapped
 support
References: <51FB7196.6060809@linaro.org>
In-Reply-To: <51FB7196.6060809@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 10:45 AM, Daniel Lezcano wrote:
> The following changes since commit 07862c1cd6675cde2dd4bd64e64d704ea2185b79:
> 
>   ARM: clocksource: Add support for MOXA ART SoCs (2013-07-18 15:27:47
> +0200)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/dlezcano/clockevents.git
> timers/clockevents-next
> 
> for you to fetch changes up to 220069945b298d3998c6598b081c466dca259929:
> 
>   clocksource: arch_timer: Add support for memory mapped timers
> (2013-08-01 01:13:37 +0200)
> ----------------------------------------------------------------
> 
> This series contains some trivial fixes for the moxart driver:
> documentation updates and a missing header file.
> 
> It also provides the arch_timer memory mapped support.

ping ?

> ----------------------------------------------------------------
> Jonas Jensen (3):
>       ARM: clocksource: moxart: documentation: Fix device tree bindings
> document
>       ARM: clocksource: moxart: Add bitops.h include
>       ARM: clocksource: moxart: documentation: Update device tree
> bindings document
> 
> Stephen Boyd (5):
>       clocksource: arch_timer: Make register accessors less error-prone
>       clocksource: arch_timer: Pass clock event to set_mode callback
>       Documentation: Add memory mapped ARM architected timer binding
>       clocksource: arch_timer: Push the read/write wrappers deeper
>       clocksource: arch_timer: Add support for memory mapped timers
> 
>  .../devicetree/bindings/arm/arch_timer.txt         |   59 ++-
>  .../bindings/timer/moxa,moxart-timer.txt           |    6 +-
>  arch/arm/include/asm/arch_timer.h                  |   14 +-
>  arch/arm64/include/asm/arch_timer.h                |   23 +-
>  drivers/clocksource/arm_arch_timer.c               |  446
> +++++++++++++++++---
>  drivers/clocksource/moxart_timer.c                 |    1 +
>  include/clocksource/arm_arch_timer.h               |   10 +-
>  7 files changed, 459 insertions(+), 100 deletions(-)
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

