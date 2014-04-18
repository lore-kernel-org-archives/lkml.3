Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaDRIge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:36:34 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:36766 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaDRIga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:36:30 -0400
Message-ID: <5350E425.6070300@linaro.org>
Date: Fri, 18 Apr 2014 10:36:53 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose
 the idlest cpu
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org> <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr> <534FDCDC.6000806@linaro.org> <20140417144707.GL11096@twins.programming.kicks-ass.net> <534FED53.2030804@linaro.org> <20140418080951.GB14280@gmail.com>
In-Reply-To: <20140418080951.GB14280@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 10:09 AM, Ingo Molnar wrote:
>
> * Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>
>> On 04/17/2014 04:47 PM, Peter Zijlstra wrote:
>>> On Thu, Apr 17, 2014 at 03:53:32PM +0200, Daniel Lezcano wrote:
>>>> Concerning the policy, I would suggest to create an entry in
>>>> /proc/sys/kernel/sched_power, where a couple of values could be performance
>>>> - power saving (0 / 1).
>>>
>>> Ingo wanted a sched_balance_policy file with 3 values:
>>>    "performance, power, auto"
>>>
>>> Where the auto thing switches between them, initially based off of
>>> having AC or not.
>>
>> oh, good. Thanks !
>
> Also, 'auto' should be the default, because the kernel doing TRT is
> really what users want.
>
> Userspace can sill tweak it all and make it all user-space controlled,
> by flipping between 'performance' and 'power'. (and those modes are
> also helpful for development and debugging.)

Copy that.

   Thanks !

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

