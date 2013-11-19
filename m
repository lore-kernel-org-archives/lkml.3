Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3KSXwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:52:13 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42260 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3KSXwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:52:10 -0500
Message-ID: <528BF9AC.40608@linaro.org>
Date: Wed, 20 Nov 2013 00:52:12 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, Stuart Menefy <stuart.menefy@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <monstr@monstr.eu>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/4] Convert setup_sched_clock() users in drivers/clocksource
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 12:48 AM, Stephen Boyd wrote:
> Daniel,
>
> These patches convert the remaining few users in drivers/clocksource
> to the new sched_clock_register() API. These were new drivers to
> this directory after I sent out the sched_clock conversion patches
> a few months back. Patches are based on Linus' tip, compile tested only.
>
> Cc: Stuart Menefy <stuart.menefy@st.com>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> Stephen Boyd (4):
>    clocksource: arm_global_timer: Switch to sched_clock_register()
>    clocksource: cadence_ttc_timer: Switch to sched_clock_register()
>    clocksource: sun4i: Switch to sched_clock_register()
>    clocksource: orion: Switch to sched_clock_register()
>
>   drivers/clocksource/arm_global_timer.c  | 4 ++--
>   drivers/clocksource/cadence_ttc_timer.c | 4 ++--
>   drivers/clocksource/sun4i_timer.c       | 4 ++--
>   drivers/clocksource/time-orion.c        | 4 ++--
>   4 files changed, 8 insertions(+), 8 deletions(-)

Hi Stephen,

applied to my tree for 3.14.

Thanks !


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

