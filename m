Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3H2V4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:56:25 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64334 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3H2V4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:56:24 -0400
Message-ID: <521FC385.90903@linaro.org>
Date: Thu, 29 Aug 2013 14:56:21 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 64bit friendly generic sched_clock() base for 3.12
References: <51F80B09.8060509@linaro.org>
In-Reply-To: <51F80B09.8060509@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 11:50 AM, John Stultz wrote:
> Hey Thomas, Olof,
>     Here is the common base changes in Stephen's "64bit friendly
> generic sched_clock()" patch series. This common base will be needed
> so that following patch series can be merged via both the
> tip/timers/core and arm-soc trees independently.
>
> Please let me know if you have any issues or objections with this set.
>
> thanks
> -john
>
>
> The following changes since commit
> ad81f0545ef01ea651886dddac4bef6cec930092:
>
>   Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)
>
> are available in the git repository at:
>
>   git://git.linaro.org/people/jstultz/linux.git
> fortglx/3.12/sched-clock64-base
>
> for you to fetch changes up to e7e3ff1bfe9c42ee31172e9afdc0383a9e595e29:
>
>   sched_clock: Add support for >32 bit sched_clock (2013-07-30
> 11:24:21 -0700)
>
> ----------------------------------------------------------------
> Stephen Boyd (4):
>       clocksource: Extract max nsec calculation into separate function
>       sched_clock: Use seqcount instead of rolling our own
>       sched_clock: Use an hrtimer instead of timer
>       sched_clock: Add support for >32 bit sched_clock
>
>  include/linux/clocksource.h |   2 +
>  include/linux/sched_clock.h |   2 +
>  kernel/time/clocksource.c   |  45 ++++++++++++------
>  kernel/time/sched_clock.c   | 111
> ++++++++++++++++++++++++--------------------
>  4 files changed, 95 insertions(+), 65 deletions(-)

Ping? Thomas?

thanks
-john

