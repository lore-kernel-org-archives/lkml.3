Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaAQR4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:56:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42733 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQR4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:56:39 -0500
Message-ID: <52D96ED6.20508@codeaurora.org>
Date: Fri, 17 Jan 2014 09:56:38 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] clocksource: timer-sun5i: Switch to sched_clock_register()
References: <1389922686-6249-1-git-send-email-sboyd@codeaurora.org> <52D90060.5020104@linaro.org>
In-Reply-To: <52D90060.5020104@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/14 02:05, Daniel Lezcano wrote:
> On 01/17/2014 02:38 AM, Stephen Boyd wrote:
>> The 32 bit sched_clock interface supports 64 bits since 3.13-rc1.
>> Upgrade to the 64 bit function to allow us to remove the 32 bit
>> registration interface.
>>
>> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>
>> Cc'in Ingo because this is simple enough to probably just apply to
>> timers/core
>
> Hi Stephen,
>
> I applied your patch in my tree for 3.15.
>

I was hoping we could remove setup_sched_clock() in 3.14-rc1 timeline,
but if we delay this until 3.15 we'll have to wait another 3 months. Is
there any chance we can get this in for 3.14?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

