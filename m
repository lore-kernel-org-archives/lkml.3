Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3I3O3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:29:19 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:60241 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab3I3O3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:29:15 -0400
Message-ID: <52498AB8.7090209@linaro.org>
Date: Mon, 30 Sep 2013 16:29:12 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL v2] drivers/clocksource: sched_clock_register() conversion
 for 3.13 (via tip/timers/core)
References: <52448A46.9020207@linaro.org>
In-Reply-To: <52448A46.9020207@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 09:25 PM, John Stultz wrote:
> Hey Daniel,
>      Here's the sched_clock_register conversion that Stephen did earlier
> this summer, as part of extending the generic sched_clock code to
> support 64bit counters. Unfortunately the prereqs for this series missed
> getting into tip/timers/core for 3.12, so I never sent out this pull
> request. But now that the prereqs are in tip/timers/core for 3.13, I've
> merge it up and I wanted to go ahead and send this out.
>
> This v2 pull request removes the setup_sched_clock deprecation, as that
> causes lots of warnings since there's still users in the arch/arm tree.
>
> Let me know if you have any issues or concerns.

Thanks John,

pulled in my tree as 3.13 material.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

