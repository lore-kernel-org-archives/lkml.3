Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaF0CLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 22:11:44 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:44402 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaF0CLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 22:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <53ACACB6.6000505@gmail.com>
References: <53AC10CB.3000007@gmail.com>
	<alpine.DEB.2.02.1406261456150.12443@chino.kir.corp.google.com>
	<53ACACB6.6000505@gmail.com>
Date: Fri, 27 Jun 2014 10:11:42 +0800
Message-ID: <CAF0htA6=16TDoO0kDDmGipAx17rQZpo7essy5K1sO0=mX--8Lg@mail.gmail.com>
Subject: Re: [PATCH v3] arch/score/include/uapi/asm/ptrace.h: Remove the
 macros which not be used currently
From: Lennox Wu <lennox.wu@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Lennox Wu <lennox.wu@gmail.com>

2014-06-27 7:28 GMT+08:00 Chen Gang <gang.chen.5i5j@gmail.com>:
>
>
> On 06/27/2014 05:56 AM, David Rientjes wrote:
>> On Thu, 26 Jun 2014, Chen Gang wrote:
>>
>>> 'COUNTER' and other same kind macros are too common to use, and easy to
>>> get conflict with other modules.
>>>
>>> At present, they are not used, so it is OK to simply remove them. And the
>>> related warning (allmodconfig with score):
>>>
>>>     CC [M]  drivers/md/raid1.o
>>>   In file included from drivers/md/raid1.c:42:0:
>>>   drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
>>>    #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
>>>    ^
>>>   In file included from ./arch/score/include/asm/ptrace.h:4:0,
>>>                    from include/linux/sched.h:31,
>>>                    from include/linux/blkdev.h:4,
>>>                    from drivers/md/raid1.c:36:
>>>   ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the location of the previous definition
>>>    #define COUNTER  38
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>
>> Acked-by: David Rientjes <rientjes@google.com>
>>
>
> OK, thanks. And also thank all of you for your discussions.
>
> Thanks.
> --
> Chen Gang
>
> Open, share, and attitude like air, water, and life which God blessed
