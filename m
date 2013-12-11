Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3LKOCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:02:33 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55996 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3LKOCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:02:32 -0500
Message-ID: <52A87077.1030800@linaro.org>
Date: Wed, 11 Dec 2013 15:02:31 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL RESEND2] clocksource/clockevents fixes for 3.13
References: <52A767CB.3010501@linaro.org> <20131210194852.GB21814@gmail.com>
In-Reply-To: <20131210194852.GB21814@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 08:48 PM, Ingo Molnar wrote:

[ ... ]

>>
>>   drivers/clocksource/Kconfig              |    1 +
>>   drivers/clocksource/clksrc-of.c          |    1 -
>>   drivers/clocksource/dw_apb_timer_of.c    |    7 ++++---
>>   drivers/clocksource/sun4i_timer.c        |    3 +++
>>   drivers/clocksource/time-armada-370-xp.c |   10 +++++-----
>>   5 files changed, 13 insertions(+), 9 deletions(-)
>
> Pulled into tip:timers/urgent, thanks a lot Daniel!

Thanks to you for helping me to be a better maintainer. All you comments 
and advices were very valuable.

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

