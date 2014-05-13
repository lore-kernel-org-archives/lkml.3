Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaEMSw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:52:27 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43910 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaEMSvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:51:25 -0400
Message-ID: <53725DC4.3090802@gmail.com>
Date: Tue, 13 May 2014 20:00:36 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@gmail.com>
CC: mtk.manpages@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [SCHED_DEADLINE man pages 0/2] Summary
References: <53723235.40101@gmail.com> <20140513175416.765abe5b536257ab72d827bc@gmail.com>
In-Reply-To: <20140513175416.765abe5b536257ab72d827bc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 05:54 PM, Juri Lelli wrote:
> Hi,
> 
> On Tue, 13 May 2014 16:54:45 +0200
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:
> 
>> Peter, at al.
>>
>> The follow ups to this mail contain the changes to man-pages for
>> the new sched_setattr() and sched_getattr() system calls, as well
>> as the changes to the sched(7) man page to document the 
>> SCHED_DEADLINE policy, all new changes in kernel 3.14.
>>
>> I used the text you submitted, but _heavily_ edited it, and added
>> a _lot_ of further details. Therefore, could you (and Juri, and 
>> Dario?) please carefully review the text.
>>
>> The follow-up mails are:
>>
>> [1/2] The sched_setattr.2 page that documents sched_setattr(2) 
>>       and sched_getattr(2).
>>
>> [2/2] The revisions to the sched(7) page.
>>
> 
> Apart from nitpicks in 2/2, this looks great to me.
> 
> Thanks a lot!

Thanks for checking the pages, Juri.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
