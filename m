Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaGJTC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:02:58 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:65532 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaGJTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <53BEE172.4050208@infradead.org>
References: <1405017830-31194-1-git-send-email-standby24x7@gmail.com>
	<53BEE172.4050208@infradead.org>
Date: Fri, 11 Jul 2014 04:02:55 +0900
Message-ID: <CALLJCT1scGgj_1m7WCAO_RUb-TD5hhFWadNFAr6bfJ1YPXusBg@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Docbook: Fix files location change of
 kernel/[hr]timer.c in device-drivers.tmpl
From: Masanari Iida <standby24x7@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: tglx@linutronix.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        john.stultz@linaro.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am testing on linux-next 10th/july version.


On Fri, Jul 11, 2014 at 3:54 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 07/10/2014 11:43 AM, Masanari Iida wrote:
>> make xmldocs failed because of file location change
>> from kernel/[hr]timer.c to kernel/time/[hr]timer.c.
>
> When does this change happen?  I don't see it in Linus's current git tree.
>

I am testing on linux-next 20140710
I believe 5cee964597260237dd2cabb3ec22bba0da24b25d is the
commit which moves the files in linux-next tree.

Thanks

> Thanks.
>
>> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
>> ---
>>  Documentation/DocBook/device-drivers.tmpl | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
>> index dd3f278..f213058 100644
>> --- a/Documentation/DocBook/device-drivers.tmpl
>> +++ b/Documentation/DocBook/device-drivers.tmpl
>> @@ -54,7 +54,7 @@
>>  !Ikernel/sched/cpupri.c
>>  !Ikernel/sched/fair.c
>>  !Iinclude/linux/completion.h
>> -!Ekernel/timer.c
>> +!Ekernel/time/timer.c
>>       </sect1>
>>       <sect1><title>Wait queues and Wake events</title>
>>  !Iinclude/linux/wait.h
>> @@ -63,7 +63,7 @@
>>       <sect1><title>High-resolution timers</title>
>>  !Iinclude/linux/ktime.h
>>  !Iinclude/linux/hrtimer.h
>> -!Ekernel/hrtimer.c
>> +!Ekernel/time/hrtimer.c
>>       </sect1>
>>       <sect1><title>Workqueues and Kevents</title>
>>  !Ekernel/workqueue.c
>>
>
>
> --
> ~Randy
