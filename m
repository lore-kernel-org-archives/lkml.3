Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3AOCVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:21:51 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:38402 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3AOCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:21:50 -0500
Message-ID: <50F4BD08.4000101@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 10:20:56 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <50EFCA29.8020801@linux.vnet.ibm.com> <87hamo2fj8.fsf@linux.vnet.ibm.com>
In-Reply-To: <87hamo2fj8.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011502-8256-0000-0000-000005D31A6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 06:13 PM, Nikunj A Dadhania wrote:
> Hi Michael,
> 
> Michael Wang <wangyun@linux.vnet.ibm.com> writes:
>> 	Prev:
>> 		+---------+---------+-------+
>> 		| 7484 MB |      32 | 42463 |
>> 	Post:
>> 		| 7483 MB |      32 | 44185 |		+0.18%
> That should be +4.05%

Hi, Nikunj

Thanks for your notify, that's my mistake on the calculation, will
correct it.

Regards,
Michael Wang

> 
> Regards
> Nikunj
> 

