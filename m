Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3KEXiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:38:24 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:47980 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3KEXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:38:22 -0500
Message-ID: <5279816B.90808@linaro.org>
Date: Wed, 06 Nov 2013 00:38:19 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org
Subject: Re: [PATCH 0/2] More Allwinner SoC timer fixes
References: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 01:16 PM, Maxime Ripard wrote:
> Hi,
>
> Here are more fixes to the sun4i timer that we spotted during the review of the
> High Speed timers patches, and that we hunted down during the Kernel Summit.
>
> Since they are not critical fixes for the current code we have, it doesn't have
> to be merged in 3.12 and can wait.
>
> Thanks!
> Maxime
>
> Maxime Ripard (2):
>    clockevent: sun4i: Fill the irq field in the clockevent structure
>    clocksource: sun4i: change CPU mask to cpu_possible_mask
>
>   drivers/clocksource/sun4i_timer.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>

Hi Maxime,

just a head up to tell I have been very busy last week for the Linaro 
connect. I will take care of the patches tomorrow.

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

