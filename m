Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaGQCaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:30:19 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62243 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaGQCaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:30:15 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C73534.1090502@roeck-us.net>
Date: Wed, 16 Jul 2014 19:30:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>, David Rientjes <rientjes@google.com>
CC: Liqin Chen <liqin.linux@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arch/score/include/uapi/asm/ptrace.h: Remove the macros
 which not be used currently
References: <53AC10CB.3000007@gmail.com>	<alpine.DEB.2.02.1406261456150.12443@chino.kir.corp.google.com>	<alpine.DEB.2.02.1407161849090.19429@chino.kir.corp.google.com> <CAF0htA5eVTPQC0c1XfzU=RHnNWLtRgtYbN+se5HPLYkJ9_E=5w@mail.gmail.com>
In-Reply-To: <CAF0htA5eVTPQC0c1XfzU=RHnNWLtRgtYbN+se5HPLYkJ9_E=5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 07:14 PM, Lennox Wu wrote:
> Actually, I don't know the rule for merging patches. Some patches will
> be merge,and some will be miss. If the patch is missed, we will merge
> it into our git.
>
Unless I am missing something, this patch is in arch/score, so the
expectation would be for you to pick it up and send it to Linus.

Guenter

> Best,
> Lennox
>
> 2014-07-17 9:49 GMT+08:00 David Rientjes <rientjes@google.com>:
>> On Thu, 26 Jun 2014, David Rientjes wrote:
>>
>>> On Thu, 26 Jun 2014, Chen Gang wrote:
>>>
>>>> 'COUNTER' and other same kind macros are too common to use, and easy to
>>>> get conflict with other modules.
>>>>
>>>> At present, they are not used, so it is OK to simply remove them. And the
>>>> related warning (allmodconfig with score):
>>>>
>>>>      CC [M]  drivers/md/raid1.o
>>>>    In file included from drivers/md/raid1.c:42:0:
>>>>    drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
>>>>     #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
>>>>     ^
>>>>    In file included from ./arch/score/include/asm/ptrace.h:4:0,
>>>>                     from include/linux/sched.h:31,
>>>>                     from include/linux/blkdev.h:4,
>>>>                     from drivers/md/raid1.c:36:
>>>>    ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the location of the previous definition
>>>>     #define COUNTER  38
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>
>>> Acked-by: David Rientjes <rientjes@google.com>
>>>
>>
>> Lennox or Liqin, could you please queue this patch for 3.17?
>
>

