Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3LMAAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 19:00:49 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:36650 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3LMAAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 19:00:47 -0500
Message-ID: <52AA4E2C.3070605@zankel.net>
Date: Thu, 12 Dec 2013 16:00:44 -0800
From: czankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Max Filippov <jcmvbkbc@gmail.com>
CC: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] xtensa: Switch to sched_clock_register()
References: <1384558303-10731-1-git-send-email-sboyd@codeaurora.org> <CAMo8Bf+kQi7-7FfteB-DpdauSYJn4Ztjuy6oTOnVXk9aVBzUbQ@mail.gmail.com> <528CFEE9.3060108@codeaurora.org> <52AA4CB8.1010008@codeaurora.org>
In-Reply-To: <52AA4CB8.1010008@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Sorry for the delay. Will add it later today.

Thanks,
-Chris

On 12/12/13 3:54 PM, Stephen Boyd wrote:
> On 11/20/13 10:26, Stephen Boyd wrote:
>> On 11/17/13 12:27, Max Filippov wrote:
>>> On Sat, Nov 16, 2013 at 3:31 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>> The 32 bit sched_clock interface now supports 64 bits. Upgrade
>>>> to the 64 bit function to allow us to remove the 32 bit
>>>> registration interface.
>>>>
>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>> ---
>>>>
>>>> Patch is based on Linus' tip. Not event compile tested.
>>>>
>>>>   arch/xtensa/kernel/time.c | 4 ++--
>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>> Build and run-tested, appears to work.
>>> Acked-by: Max Filippov <jcmvbkbc@gmail.com>
>>>
>>> Should it go through xtensa tree, or through some other tree as a part
>>> of a bigger conversion series?
>> If it can go through xtensa that sounds like the best option. Otherwise
>> we can send it through the tip/timers tree.
>>
> Ping? I don't see this patch in linux-next yet so should I send this
> through the tip/timers tree?
>

