Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab3IYAyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:54:39 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44550 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3IYAyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:54:38 -0400
Message-ID: <5242344B.8020002@linaro.org>
Date: Tue, 24 Sep 2013 17:54:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] drivers/clocksource: sched_clock_register() conversion
 for 3.13 (via tip/timers/core)
References: <52422732.5000501@linaro.org>
In-Reply-To: <52422732.5000501@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 04:58 PM, John Stultz wrote:
> Hey Daniel,
>     Here's the sched_clock_register conversion that Stephen did earlier
> this summer, as part of extending the generic sched_clock code to
> support 64bit counters. Unfortunately the prereqs for this series missed
> getting into tip/timers/core for 3.12, so I never sent out this pull
> request. But now that the prereqs are in tip/timers/core for 3.13, I've
> merge it up and I wanted to go ahead and send this out.
>
> Let me know if you have any issues or concerns.
Hey Daniel,
    Maybe hold off on this one. The kbuild test robot is has some
complaints aobut the deprecation of setup_sched_clock() while there are
still users in arch/arm.

I'll likely rework a new branch for you to pull that will be all but the
"Deprecate setup_sched_clock()" patch.


thanks
-john

