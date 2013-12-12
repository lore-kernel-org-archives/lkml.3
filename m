Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3LLXyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:54:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52953 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3LLXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:54:33 -0500
Message-ID: <52AA4CB8.1010008@codeaurora.org>
Date: Thu, 12 Dec 2013 15:54:32 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] xtensa: Switch to sched_clock_register()
References: <1384558303-10731-1-git-send-email-sboyd@codeaurora.org> <CAMo8Bf+kQi7-7FfteB-DpdauSYJn4Ztjuy6oTOnVXk9aVBzUbQ@mail.gmail.com> <528CFEE9.3060108@codeaurora.org>
In-Reply-To: <528CFEE9.3060108@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 10:26, Stephen Boyd wrote:
> On 11/17/13 12:27, Max Filippov wrote:
>> On Sat, Nov 16, 2013 at 3:31 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> The 32 bit sched_clock interface now supports 64 bits. Upgrade
>>> to the 64 bit function to allow us to remove the 32 bit
>>> registration interface.
>>>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>>
>>> Patch is based on Linus' tip. Not event compile tested.
>>>
>>>  arch/xtensa/kernel/time.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> Build and run-tested, appears to work.
>> Acked-by: Max Filippov <jcmvbkbc@gmail.com>
>>
>> Should it go through xtensa tree, or through some other tree as a part
>> of a bigger conversion series?
> If it can go through xtensa that sounds like the best option. Otherwise
> we can send it through the tip/timers tree.
>

Ping? I don't see this patch in linux-next yet so should I send this
through the tip/timers tree?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

