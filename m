Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaBMKWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:22:39 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49521 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaBMKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:22:35 -0500
Message-ID: <52FC9CE9.8000700@linaro.org>
Date: Thu, 13 Feb 2014 11:22:33 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Alex Shi <alex.shi@linaro.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH V2 2/3] sched: Fix race in idle_balance()
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org> <1391728237-4441-3-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pMEFTe6pQVDFzaXmqt_A3vw3tyj7Ewqib6zbzH++YzY3w@mail.gmail.com> <52FA0577.6080607@linaro.org> <52FC7835.1090509@linaro.org> <52FC99F8.4020002@linux.vnet.ibm.com>
In-Reply-To: <52FC99F8.4020002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 11:10 AM, Preeti U Murthy wrote:
> Hi,
>
> On 02/13/2014 01:15 PM, Alex Shi wrote:
>> On 02/11/2014 07:11 PM, Daniel Lezcano wrote:
>>> On 02/10/2014 10:24 AM, Preeti Murthy wrote:
>>>> HI Daniel,
>>>>
>>>> Isn't the only scenario where another cpu can put an idle task on
>>>> our runqueue,
>>>
>>> Well, I am not sure to understand what you meant, but I assume you are
>>> asking if it is possible to have a task to be pulled when we are idle,
>>> right ?
>>>
>>> This patch fixes the race when the current cpu is *about* to enter idle
>>> when calling schedule().
>>
>> Preeti said the she didn't see a possible to insert a task on the cpu.
>>
>> I also did a quick check, maybe task come from wakeup path?
>
> Yes this is possible. Thanks for pointing this :)
>
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Thanks for the review !

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

