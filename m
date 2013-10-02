Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3JBKXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:23:46 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48050 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3JBKXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:23:43 -0400
Message-ID: <524BF42A.7020509@linaro.org>
Date: Wed, 02 Oct 2013 12:23:38 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] clocksource: arm_arch_timer: Use clocksource for suspend
 timekeeping
References: <1380312792-7275-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1380312792-7275-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 10:13 PM, Stephen Boyd wrote:
> The ARM architected timers keep counting during suspend so we can
> mark this clocksource with the CLOCK_SOURCE_SUSPEND_NONSTOP flag.
> This flag will indicate that this clocksource can be used for
> calculating suspend time and injecting sleep time into the
> timekeeping core. This should be more accurate than using an
> external RTC or architecture specific persistent clock.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Applied to my tree for 3.13

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

