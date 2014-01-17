Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaAQSET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:04:19 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:39446 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaAQSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:04:16 -0500
Message-ID: <52D9709E.4000804@linaro.org>
Date: Fri, 17 Jan 2014 19:04:14 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] clocksource: timer-sun5i: Switch to sched_clock_register()
References: <1389922686-6249-1-git-send-email-sboyd@codeaurora.org> <52D90060.5020104@linaro.org> <52D96ED6.20508@codeaurora.org>
In-Reply-To: <52D96ED6.20508@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 06:56 PM, Stephen Boyd wrote:
> On 01/17/14 02:05, Daniel Lezcano wrote:
>> On 01/17/2014 02:38 AM, Stephen Boyd wrote:
>>> The 32 bit sched_clock interface supports 64 bits since 3.13-rc1.
>>> Upgrade to the 64 bit function to allow us to remove the 32 bit
>>> registration interface.
>>>
>>> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>>
>>> Cc'in Ingo because this is simple enough to probably just apply to
>>> timers/core
>>
>> Hi Stephen,
>>
>> I applied your patch in my tree for 3.15.
>>
>
> I was hoping we could remove setup_sched_clock() in 3.14-rc1 timeline,
> but if we delay this until 3.15 we'll have to wait another 3 months. Is
> there any chance we can get this in for 3.14?

I am ok with that. It is up to Ingo.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

