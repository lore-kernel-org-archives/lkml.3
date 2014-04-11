Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbaDKOc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:32:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33534 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaDKOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:32:58 -0400
Message-ID: <5347FCED.8040706@oracle.com>
Date: Fri, 11 Apr 2014 10:32:13 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>, Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com> <20140224071028.GW9987@twins.programming.kicks-ass.net> <530B1B80.4000307@linux.vnet.ibm.com> <20140224121218.GR15586@twins.programming.kicks-ass.net> <534610A4.5000302@oracle.com> <53464164.5030701@linux.vnet.ibm.com> <336561397137116@web27h.yandex.ru>
In-Reply-To: <336561397137116@web27h.yandex.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 09:38 AM, Kirill Tkhai wrote:
> 10.04.2014, 11:00, "Michael wang" <wangyun@linux.vnet.ibm.com>:
>> > On 04/10/2014 11:31 AM, Sasha Levin wrote:
>> > [snip]
>> >
>>> >>  I'd like to re-open this issue. It seems that something broke and I'm
>>> >>  now seeing the same issues that have gone away 2 months with this patch
>>> >>  again.
>> >
>> > A new mechanism has been designed to move the priority checking inside
>> > idle_balance(), including Kirill who is the designer ;-)
> Not sure, it's connected with my patch. But looks like, we forgot
> exactly stop class. Maybe this will help?
> 
> [PATCH] sched: Checking for stop task appearance when balancing happens
> 
> Just do it, like we do for other higher priority classes...
> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>

I've been running with this patch for the last two days and the hang
seems to be gone.

I'll leave it running on the weekend and will update again on Monday.


Thanks,
Sasha
