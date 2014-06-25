Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaFYBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:25:56 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62961 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaFYBZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:25:55 -0400
Message-ID: <53AA251D.9070100@gmail.com>
Date: Wed, 25 Jun 2014 09:25:49 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Guenter Roeck <linux@roeck-us.net>
CC: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A9783C.7050206@gmail.com> <53A98F6F.4080503@roeck-us.net> <alpine.DEB.2.02.1406241549430.29176@chino.kir.corp.google.com> <53AA0553.6020909@roeck-us.net> <alpine.DEB.2.02.1406241639310.22030@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406241639310.22030@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/25/2014 07:40 AM, David Rientjes wrote:
> On Tue, 24 Jun 2014, Guenter Roeck wrote:
> 
>> That is another question. But for the time being it might be sufficient to
>> surround the defines with #if !defined(__KERNEL__) without introducing new
>> (and unused) kernel defines.
>>
> 
> On the other hand, if no userspace is referencing these, then you could 
> just rename them and move them out of the uapi header to 
> include/asm/ptrace.h and be done with it.
> 

OK, thanks. And sorry for the subject lost 'a', firstly.  And it is
related with UAPI,  so it is really important enough to let related
maintainer to notice about it.

I guess, only the related maintainer know whether can remove these
macros out of "include/uapi/asm/ptrace.h" (although in current upstream
kernel source, they are really not used).

It is abnormal in uapi headers for same values with different macros
switched by "__KERNEL__", but if we have to remain them still in uapi,
we have to use "__KERNEL__ && __linux__" to carm down kernel and user.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
