Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab3EZA6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:58:39 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44884 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448Ab3EZA6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:58:38 -0400
Message-ID: <51A15E2F.7010308@gmail.com>
Date: Sun, 26 May 2013 08:58:23 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davej@redhat.com
Subject: Re: [PATCH 2/7] Documentation/devices.txt: Remove /dev/oldmem description
References: <51A02E50.5020507@gmail.com> <51A02F59.8000103@gmail.com> <87vc668x4w.fsf@xmission.com>
In-Reply-To: <87vc668x4w.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月26日 07:20, Eric W. Biederman 写道:
> Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:
> 
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> Won't we want to keep this reservation around to so that this number
> doesn't get reused, and cause people confusion when
> upgrading/downgrading kernels?

Ah, yes. I will just keep this and add a note to make people know that
it is removed in the next version.

Thanks
Zhang

> 
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> Cc: Dave Jones <davej@redhat.com>
>> ---
>>  Documentation/devices.txt |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
>> index 08f01e7..4f85739 100644
>> --- a/Documentation/devices.txt
>> +++ b/Documentation/devices.txt
>> @@ -100,8 +100,6 @@ Your cooperation is appreciated.
>>  		 10 = /dev/aio		Asynchronous I/O notification interface
>>  		 11 = /dev/kmsg		Writes to this come out as printk's, reads
>>  					export the buffered printk records.
>> -		 12 = /dev/oldmem	Used by crashdump kernels to access
>> -					the memory of the kernel that crashed.
>>  
>>    1 block	RAM disk
>>  		  0 = /dev/ram0		First RAM disk

