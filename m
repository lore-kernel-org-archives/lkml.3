Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbaFYPRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:17:02 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:62492 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbaFYPRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:17:00 -0400
MIME-Version: 1.0
In-Reply-To: <53AA251D.9070100@gmail.com>
References: <53A9783C.7050206@gmail.com>
	<53A98F6F.4080503@roeck-us.net>
	<alpine.DEB.2.02.1406241549430.29176@chino.kir.corp.google.com>
	<53AA0553.6020909@roeck-us.net>
	<alpine.DEB.2.02.1406241639310.22030@chino.kir.corp.google.com>
	<53AA251D.9070100@gmail.com>
Date: Wed, 25 Jun 2014 23:16:59 +0800
Message-ID: <CAF0htA5VjUy52OKod6kxA43kjyZPj+CHcSrFmhNEn-bD0GvtgA@mail.gmail.com>
Subject: Re: [PATCH v2] rch/score/include/uapi/asm/ptrace.h: Add prefix
 'SCORE_' for related macros
From: Lennox Wu <lennox.wu@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These marcos are listed in advance.
Indeed, they have not been used, and the functions use them have not
be released.
I would like to keep the status even if the configure should not be used.
However, if guys think it is dirty, maybe we can remove or comment them first.

Best,
Lennox


2014-06-25 9:25 GMT+08:00 Chen Gang <gang.chen.5i5j@gmail.com>:
>
>
> On 06/25/2014 07:40 AM, David Rientjes wrote:
>> On Tue, 24 Jun 2014, Guenter Roeck wrote:
>>
>>> That is another question. But for the time being it might be sufficient to
>>> surround the defines with #if !defined(__KERNEL__) without introducing new
>>> (and unused) kernel defines.
>>>
>>
>> On the other hand, if no userspace is referencing these, then you could
>> just rename them and move them out of the uapi header to
>> include/asm/ptrace.h and be done with it.
>>
>
> OK, thanks. And sorry for the subject lost 'a', firstly.  And it is
> related with UAPI,  so it is really important enough to let related
> maintainer to notice about it.
>
> I guess, only the related maintainer know whether can remove these
> macros out of "include/uapi/asm/ptrace.h" (although in current upstream
> kernel source, they are really not used).
>
> It is abnormal in uapi headers for same values with different macros
> switched by "__KERNEL__", but if we have to remain them still in uapi,
> we have to use "__KERNEL__ && __linux__" to carm down kernel and user.
>
>
> Thanks.
> --
> Chen Gang
>
> Open, share, and attitude like air, water, and life which God blessed
