Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaEPRaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:30:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48844 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaEPR37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:29:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpegt4OdpZfaLjRjkLS27y_=kUeUpowHmbb_7TicsLpzYyGg@mail.gmail.com>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-15-git-send-email-miklos@szeredi.hu>
	<CAJfpegt4OdpZfaLjRjkLS27y_=kUeUpowHmbb_7TicsLpzYyGg@mail.gmail.com>
Date: Fri, 16 May 2014 21:29:59 +0400
Message-ID: <CAMo8Bf+0g-PmLqsFeXyrFOvrbxfyVVfX_s1p_U5JqAunHd_9Yw@mail.gmail.com>
Subject: Re: [PATCH 14/15] xtensa: add renameat2 syscall
From: Max Filippov <jcmvbkbc@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chris Zankel <chris@zankel.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On Thu, May 15, 2014 at 4:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> Cc: Chris Zankel <chris@zankel.net>
>
> Chris,
>
> I'll be sending a batch of patches with arch support for the renameat2
> syscall to Linus next week.  If you'd like me to send this as well,
> could you please ACK it?

not Chris, but FWIW, Acked-by: Max Filippov <jcmvbkbc@gmail.com>

>> ---
>>  arch/xtensa/include/uapi/asm/unistd.h | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/xtensa/include/uapi/asm/unistd.h b/arch/xtensa/include/uapi/asm/unistd.h
>> index b9395529f02d..8883fc877c5c 100644
>> --- a/arch/xtensa/include/uapi/asm/unistd.h
>> +++ b/arch/xtensa/include/uapi/asm/unistd.h
>> @@ -739,7 +739,10 @@ __SYSCALL(334, sys_sched_setattr, 2)
>>  #define __NR_sched_getattr                     335
>>  __SYSCALL(335, sys_sched_getattr, 3)
>>
>> -#define __NR_syscall_count                     336
>> +#define __NR_renameat2                         336
>> +__SYSCALL(336, sys_renameat2, 5)
>> +
>> +#define __NR_syscall_count                     337
>>
>>  /*
>>   * sysxtensa syscall handler
>> --
>> 1.8.1.4

-- 
Thanks.
-- Max
