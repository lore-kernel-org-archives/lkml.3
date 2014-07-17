Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaGQJI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:08:57 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60493 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbaGQJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:08:53 -0400
Message-ID: <53C792A2.300@gmail.com>
Date: Thu, 17 Jul 2014 17:08:50 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>, Guenter Roeck <linux@roeck-us.net>
CC: David Rientjes <rientjes@google.com>, Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v3] arch/score/include/uapi/asm/ptrace.h: Remove the macros
 which not be used currently
References: <53AC10CB.3000007@gmail.com>	<alpine.DEB.2.02.1406261456150.12443@chino.kir.corp.google.com>	<alpine.DEB.2.02.1407161849090.19429@chino.kir.corp.google.com>	<CAF0htA5eVTPQC0c1XfzU=RHnNWLtRgtYbN+se5HPLYkJ9_E=5w@mail.gmail.com>	<53C73534.1090502@roeck-us.net> <CAF0htA6awFMsfPRRr9=s4Hcxcu586WHWRwyg=C0zc2Yr7CyvKQ@mail.gmail.com>
In-Reply-To: <CAF0htA6awFMsfPRRr9=s4Hcxcu586WHWRwyg=C0zc2Yr7CyvKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 10:52 AM, Lennox Wu wrote:
> Yes, you might miss something. Some patches were merged once I
> acknowledged them,and some were missed.
> So I am not sure the rule, if someone will merge these patches once
> them are acknowledged, it is redundant that I issue a
> PULL request again.
> 

I guess, we need consult another version merging members (e.g Stephen
Rothwell), they may provide more useful suggestions or ideas.

For me, if the patch is mainly under "arch/*/*", it need be applied by
related architecture members. And these architecture related patches can
be merged into linux-next tree firstly, then to upstream main line.


Thanks.

> 
> 
> 2014-07-17 10:30 GMT+08:00 Guenter Roeck <linux@roeck-us.net>:
>> On 07/16/2014 07:14 PM, Lennox Wu wrote:
>>>
>>> Actually, I don't know the rule for merging patches. Some patches will
>>> be merge,and some will be miss. If the patch is missed, we will merge
>>> it into our git.
>>>
>> Unless I am missing something, this patch is in arch/score, so the
>> expectation would be for you to pick it up and send it to Linus.
>>
>> Guenter
>>
>>
>>> Best,
>>> Lennox
>>>
>>> 2014-07-17 9:49 GMT+08:00 David Rientjes <rientjes@google.com>:
>>>>
>>>> On Thu, 26 Jun 2014, David Rientjes wrote:
>>>>
>>>>> On Thu, 26 Jun 2014, Chen Gang wrote:
>>>>>
>>>>>> 'COUNTER' and other same kind macros are too common to use, and easy to
>>>>>> get conflict with other modules.
>>>>>>
>>>>>> At present, they are not used, so it is OK to simply remove them. And
>>>>>> the
>>>>>> related warning (allmodconfig with score):
>>>>>>
>>>>>>      CC [M]  drivers/md/raid1.o
>>>>>>    In file included from drivers/md/raid1.c:42:0:
>>>>>>    drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
>>>>>>     #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
>>>>>>     ^
>>>>>>    In file included from ./arch/score/include/asm/ptrace.h:4:0,
>>>>>>                     from include/linux/sched.h:31,
>>>>>>                     from include/linux/blkdev.h:4,
>>>>>>                     from drivers/md/raid1.c:36:
>>>>>>    ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the
>>>>>> location of the previous definition
>>>>>>     #define COUNTER  38
>>>>>>
>>>>>>
>>>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>>>
>>>>>
>>>>> Acked-by: David Rientjes <rientjes@google.com>
>>>>>
>>>>
>>>> Lennox or Liqin, could you please queue this patch for 3.17?
>>>
>>>
>>>
>>

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
