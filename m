Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaJ0JX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:23:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57141 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaJ0JX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:23:28 -0400
Date: Mon, 27 Oct 2014 14:53:17 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched:skip loop non-idle cpus after find an idle cpu
 while find_idlest_cpu
Message-ID: <20141027092317.GC10867@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <544DB84D.1030504@huawei.com>
 <20141027080422.GB10867@linux.vnet.ibm.com>
 <544E091D.9040102@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <544E091D.9040102@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102709-0013-0000-0000-000001E5AFCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yao Dongdong <yaodongdong@huawei.com> [2014-10-27 16:58:05]:

> On 2014/10/27 16:04, Srikar Dronamraju wrote:
> > * Yao Dongdong <yaodongdong@huawei.com> [2014-10-27 11:13:17]:
> >
> >> Idle cpu is idler than non-idle cpu, so we needn't loop non-idle cpus after find an idle cpu.
> >>
> > While this check looks good,
> > I dont see how we are avoiding a loop?
> >
> > Are you suggesting that we break of the for loop once we set
> > shallowest_idle_cpu?
> >
> Thanks for your review.
> 
> I agree that the submit message is a bit misleading, what this patch do is just avoiding search for least_loaded_cpu
> in non-idle cpus.
> 
>     sched:add check of shallowest_idle_cpu before search for least_loaded_cpu
> 
>     Idle cpu is idler than non-idle cpu, so we needn't search for least_loaded_cpu
>     after we have found an idle cpu.
> 

Looks good for me.

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>


-- 
Thanks and Regards
Srikar Dronamraju

