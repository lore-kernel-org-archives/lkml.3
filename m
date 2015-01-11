Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbAKUvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:51:17 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51178 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbbAKUvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:51:15 -0500
Message-ID: <54B2E240.8030701@linaro.org>
Date: Sun, 11 Jan 2015 21:51:12 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Barry Song <baohua@kernel.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Subject: Re: [PATCH] clocksource: sirf: Remove unused variable
References: <1418659160-2115-1-git-send-email-thierry.reding@gmail.com> <548F09B6.6010202@linaro.org> <CAGsJ_4zQqwNdu3z1hzuLd4gvxY8iA+9HfdoTE8_U2tDmRUBNYQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zQqwNdu3z1hzuLd4gvxY8iA+9HfdoTE8_U2tDmRUBNYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 04:58 PM, Barry Song wrote:
> 2014-12-16 0:17 GMT+08:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
>> On 12/15/2014 04:59 PM, Thierry Reding wrote:
>>>
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> Commit ef89af1f4380 ("clocksource: sirf: Remove hard-coded clock rate")
>>> removes all uses of the timer_div variable. Since the variable is no
>>> longer used it should be removed.
>>>
>>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>>> ---
>>
>>
>> Applied to my tree. Thanks!
>
> Daniel,
>
> i didn't find this commit in any tree in kernel.org. am i missing something?

Nope, I did probably something wrong.

> so i manually rebased "clocksource: marco: rename marco to atlas7"
> against this commit.
>
> can you help to apply the attached patch to your tree? i guess pulling
> by arm-soc will cause conflicts.

Ok, done. Both patches are in my tree [1].

Thanks
   -- Daniel

[1] 
https://git.linaro.org/people/daniel.lezcano/linux.git/shortlog/refs/heads/clockevents/3.20


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

