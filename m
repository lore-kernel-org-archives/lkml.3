Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaBYCsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:48:09 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:59422 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaBYCsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:48:07 -0500
Message-ID: <530C0461.9030602@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 10:48:01 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com> <20140224071028.GW9987@twins.programming.kicks-ass.net> <530B1B80.4000307@linux.vnet.ibm.com> <20140224121218.GR15586@twins.programming.kicks-ass.net> <530B8DBC.6020105@oracle.com>
In-Reply-To: <530B8DBC.6020105@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022502-8256-0000-0000-00000BA148F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 02:21 AM, Sasha Levin wrote:
[snip]
>>
>> Fixes: 38033c37faab ("sched: Push down pre_schedule() and
>> idle_balance()")
>> Cc: Juri Lelli<juri.lelli@gmail.com>
>> Cc: Ingo Molnar<mingo@kernel.org>
>> Cc: Steven Rostedt<rostedt@goodmis.org>
>> Reported-by: Michael Wang<wangyun@linux.vnet.ibm.com>
>> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
> 
> Sign me up to the fan club of this patch, I love it.
> 
> After running it for a bit I see that all the hangs I've seen before are
> gone, even those that I didn't assume were sched related.

Good to know the problem got solved :)

Regards,
Michael Wang

> 
> 
> Thanks,
> Sasha

